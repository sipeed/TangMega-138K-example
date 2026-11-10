#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
# Contributed by NextTang (github.com/jattree/NextTang).
"""Bring the quad's REFCLK out of a Gowin-generated SerDes_Top for serdes_reinit.

usage: add_refclk_tap.py src/serdes/serdes.v      (edits the file in place)

Adds one output port, serdes_refclk_o, driven by the wire
q0_fabric_cmu_ck_ref_o that the generated file already has. serdes_reinit
measures it to know when the PCIe reference clock is a steady 100 MHz. Run it
again after regenerating the SerDes/PCIe IP; running it twice is refused.
"""
import re
import sys

PORT = 'serdes_refclk_o'
WIRE = 'q0_fabric_cmu_ck_ref_o'


def main(argv):
    if len(argv) != 1:
        sys.exit(__doc__)
    path = argv[0]
    with open(path, encoding='utf-8', newline='') as f:
        s = f.read()
    if PORT in s:
        sys.exit('%s already has %s' % (path, PORT))
    if not re.search(r'\bwire\s+%s\s*;' % WIRE, s):
        sys.exit('%s: no wire %s (not a Gowin SerDes_Top?)' % (path, WIRE))
    m = re.search(r'module\s+SerDes_Top\s*\(', s)
    if not m:
        sys.exit('%s: no module SerDes_Top' % path)
    nl = '\r\n' if '\r\n' in s else '\n'
    s = s[:m.end()] + PORT + ', ' + s[m.end():]
    end = s.index(';', m.end()) + 1                      # end of the port list
    s = s[:end] + nl + 'output %s;  // add_refclk_tap.py: REFCLK for serdes_reinit' % PORT + s[end:]
    tail = s.rindex('endmodule')
    s = s[:tail] + 'assign %s = %s;  // add_refclk_tap.py%s' % (PORT, WIRE, nl) + s[tail:]
    with open(path, 'w', encoding='utf-8', newline='') as f:
        f.write(s)
    print('%s: added %s' % (path, PORT))


if __name__ == '__main__':
    main(sys.argv[1:])
