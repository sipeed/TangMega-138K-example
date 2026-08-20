#include <libusb-1.0/libusb.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define VID 0x359f
#define PID 0x3001
#define EP_IN 0x82
#define N_XFERS 8
#define XFER_SIZE (256 * 1024)

static volatile sig_atomic_t running = 1;
static uint64_t total_bytes, completions, errors;
static uint64_t pattern_errors;
static int pattern_locked;
static int mismatch_prints;
static uint32_t stream_base_word;

static uint16_t fpga_pattern(uint32_t word) {
    return (uint16_t)word ^ (uint16_t)(word >> 8);
}

static uint32_t modeled_word(uint32_t base, uint32_t offset) {
    uint32_t frame_word = offset & 2047u;
    return base + (offset & ~2047u) + (frame_word & 511u);
}

static void check_payload(const unsigned char *data, int length, uint64_t byte_offset) {
    int words = length / 2;
    if (words < 64) { pattern_errors++; return; }
    if (!pattern_locked) {
        for (uint32_t candidate = 0; candidate < (1u << 24); candidate += 2048) {
            int ok = 1;
            for (int i = 0; i < words; i += 127) {
                uint16_t got = (uint16_t)data[2*i] | (uint16_t)data[2*i+1] << 8;
                if (got != fpga_pattern(modeled_word(candidate, (uint32_t)i))) {
                    ok = 0; break;
                }
            }
            if (ok) {
                stream_base_word = candidate - (uint32_t)(byte_offset / 2);
                pattern_locked = 1;
                break;
            }
        }
    }
    if (!pattern_locked) { pattern_errors++; return; }
    uint32_t base = stream_base_word + (uint32_t)(byte_offset / 2);
    for (int i = 0; i < words; i++) {
        /* The current FPGA source has a 9-bit TX RAM address.  A 4096-byte
           HSPI frame therefore repeats its 512-word pattern four times, then
           advances tx_word_base by 2048 for the following frame. */
        uint32_t want_word = modeled_word(base, (uint32_t)i);
        uint16_t got = (uint16_t)data[2*i] | (uint16_t)data[2*i+1] << 8;
        if (got != fpga_pattern(want_word)) {
            pattern_errors++;
            if (mismatch_prints < 12) {
                fprintf(stderr, "mismatch byte=%llu local_word=%d base=%08x got=%04x want=%04x\n",
                        (unsigned long long)total_bytes, i, base, got,
                        fpga_pattern(want_word));
                mismatch_prints++;
            }
        }
    }
}

static double now_s(void) {
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return t.tv_sec + t.tv_nsec / 1e9;
}

static void on_transfer(struct libusb_transfer *xfer) {
    if (xfer->status == LIBUSB_TRANSFER_COMPLETED) {
        check_payload(xfer->buffer, xfer->actual_length, total_bytes);
        total_bytes += (uint64_t)xfer->actual_length;
        completions++;
    } else if (xfer->status != LIBUSB_TRANSFER_CANCELLED) {
        fprintf(stderr, "transfer status=%s actual=%d\n",
                libusb_error_name(xfer->status), xfer->actual_length);
        errors++;
        running = 0;
    }
    if (running) {
        if (libusb_submit_transfer(xfer) != 0) running = 0;
    }
}

int main(int argc, char **argv) {
    double seconds = argc > 1 ? strtod(argv[1], NULL) : 10.0;
    libusb_context *ctx = NULL;
    libusb_device_handle *dev = NULL;
    struct libusb_transfer *xfers[N_XFERS] = {0};
    unsigned char *buffers[N_XFERS] = {0};
    int rc = libusb_init(&ctx);
    if (rc) goto fail;
    dev = libusb_open_device_with_vid_pid(ctx, VID, PID);
    if (!dev) { fprintf(stderr, "device %04x:%04x not found\n", VID, PID); return 2; }
    rc = libusb_claim_interface(dev, 0);
    if (rc) goto fail;
    libusb_clear_halt(dev, EP_IN);

    for (int i = 0; i < N_XFERS; i++) {
        buffers[i] = aligned_alloc(64, XFER_SIZE);
        xfers[i] = libusb_alloc_transfer(0);
        libusb_fill_bulk_transfer(xfers[i], dev, EP_IN, buffers[i], XFER_SIZE,
                                  on_transfer, NULL, 2000);
        rc = libusb_submit_transfer(xfers[i]);
        if (rc) goto fail;
    }

    /* The firmware starts capture 20 ms after this request.  All bulk URBs
       are already queued, so no 64 KiB ring startup race is possible. */
    rc = libusb_control_transfer(dev, 0x40, 0x8f, 0x007f, 0, NULL, 0, 1000);
    if (rc < 0) goto fail;
    double start = now_s(), deadline = start + seconds;
    while (running && now_s() < deadline) {
        struct timeval tv = {.tv_sec = 0, .tv_usec = 10000};
        libusb_handle_events_timeout_completed(ctx, &tv, NULL);
    }
    running = 0;
    for (int i = 0; i < N_XFERS; i++) libusb_cancel_transfer(xfers[i]);
    for (int n = 0; n < 100; n++) {
        struct timeval tv = {.tv_sec = 0, .tv_usec = 1000};
        libusb_handle_events_timeout_completed(ctx, &tv, NULL);
    }
    double elapsed = now_s() - start;
    printf("bytes=%llu completions=%llu usb_errors=%llu pattern_errors=%llu elapsed=%.6f s\n",
           (unsigned long long)total_bytes, (unsigned long long)completions,
           (unsigned long long)errors, (unsigned long long)pattern_errors, elapsed);
    printf("rate=%.3f Mbit/s (%.3f MB/s)\n",
           total_bytes * 8.0 / elapsed / 1e6, total_bytes / elapsed / 1e6);
    for (int i = 0; i < N_XFERS; i++) { libusb_free_transfer(xfers[i]); free(buffers[i]); }
    libusb_release_interface(dev, 0);
    libusb_close(dev);
    libusb_exit(ctx);
    return (errors || pattern_errors || !pattern_locked) ? 1 : 0;
fail:
    fprintf(stderr, "libusb: %s\n", libusb_error_name(rc));
    return 2;
}
