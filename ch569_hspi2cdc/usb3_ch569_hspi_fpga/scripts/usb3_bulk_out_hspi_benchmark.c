#include <libusb-1.0/libusb.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define VID 0x359f
#define PID 0x3001
#define EP_OUT 0x01
#define EP_IN 0x82
#define CHUNK (1024 * 1024)

static double now_s(void) {
    struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t);
    return t.tv_sec + t.tv_nsec / 1e9;
}
static void put16(unsigned char *p, uint16_t v) { p[0]=v; p[1]=v>>8; }
static void put32(unsigned char *p, uint32_t v) { put16(p,v); put16(p+2,v>>16); }
static uint16_t get16(const unsigned char *p) { return p[0] | (uint16_t)p[1]<<8; }
static uint32_t get32(const unsigned char *p) { return get16(p) | (uint32_t)get16(p+2)<<16; }

int main(int argc, char **argv) {
    uint32_t mib = argc > 1 ? strtoul(argv[1], NULL, 0) : 64;
    uint32_t total = mib * 1024u * 1024u, seed = 0x13579bdf;
    if (!total || total % 4096) { fprintf(stderr,"size must be a nonzero 4KiB multiple\n"); return 2; }
    libusb_context *ctx=NULL; libusb_device_handle *dev=NULL;
    int rc=libusb_init(&ctx), done=0;
    if (rc) goto fail;
    dev=libusb_open_device_with_vid_pid(ctx,VID,PID);
    if (!dev) { fprintf(stderr,"device not found\n"); return 2; }
    if ((rc=libusb_claim_interface(dev,0))) goto fail;
    libusb_clear_halt(dev,EP_OUT); libusb_clear_halt(dev,EP_IN);
    if ((rc=libusb_control_transfer(dev,0x40,0x8f,0x007e,0,NULL,0,1000))<0) goto fail;

    unsigned char cmd[64]={0};
    put32(cmd,0x42425348); put16(cmd+4,1); put16(cmd+6,1);
    put32(cmd+8,total); put32(cmd+12,seed);
    if ((rc=libusb_bulk_transfer(dev,EP_OUT,cmd,sizeof(cmd),&done,2000)) || done!=sizeof(cmd)) goto fail;

    unsigned char *buf=aligned_alloc(64,CHUNK);
    uint32_t sent=0; double start=now_s();
    while (sent < total) {
        uint32_t amount=total-sent; if (amount>CHUNK) amount=CHUNK;
        uint32_t base_word=sent/2;
        for (uint32_t i=0;i<amount/2;i++) {
            uint32_t w=base_word+i;
            put16(buf+2*i,(uint16_t)w ^ (uint16_t)(w>>8) ^ (uint16_t)seed);
        }
        uint32_t off=0;
        while (off<amount) {
            done=0; rc=libusb_bulk_transfer(dev,EP_OUT,buf+off,amount-off,&done,5000);
            if (rc) goto fail;
            if (done <= 0) {
                fprintf(stderr,"bulk OUT made no progress\n");
                rc = LIBUSB_ERROR_IO;
                goto fail;
            }
            off+=(uint32_t)done;
        }
        sent+=amount;
    }
    double elapsed=now_s()-start;
    unsigned char report[1024]; done=0;
    rc=libusb_bulk_transfer(dev,EP_IN,report,sizeof(report),&done,5000);
    if (rc) goto fail;
    printf("bytes=%u elapsed=%.6f rate=%.3f Mbit/s (%.3f MB/s)\n",
           total,elapsed,total*8.0/elapsed/1e6,total/elapsed/1e6);
    printf("report_bytes=%d magic=%08x version=%u op=%u total=%u frames=%u "
           "hspi_crc_trailer=%u hspi_seq_diag=%u pattern_errors=%u "
           "cycles=%u seed=%08x crc_residue=%04x\n",done,
           get32(report),get16(report+4),get16(report+6),get32(report+8),
           get32(report+12),get32(report+16),get32(report+20),
           get32(report+24),get32(report+40),get32(report+56),get16(report+60));
    free(buf); libusb_release_interface(dev,0); libusb_close(dev); libusb_exit(ctx);
    /* FPGA pattern is the end-to-end payload integrity criterion. CH569
       normal-mode TX emits a zero CRC trailer, so retain the trailer and
       dependent sequence counters as diagnostics without treating them as
       payload corruption. See docs/PROTOCOL.md. */
    return get32(report)!=0x52505348 || get32(report+24);
fail:
    fprintf(stderr,"libusb error: %s done=%d\n",libusb_error_name(rc),done);
    return 2;
}
