import re
import sys

file = open(sys.argv[1], 'r')

def sym(s):
    if not s.startswith('.'):
        return '_' + s
    return s

while True:
    line = file.readline()
    if not line:
        break

    # sections
    if re.match("\t.section\t.text.", line):
        print "\t.section\t__TEXT,__text,regular,pure_instructions"
        continue
    if re.match("\t.size\t", line):
        continue
    if re.match("\t.type\t", line):
        continue
    if re.match("\t.section\t.data.rel", line):
        print "\t.section\t__DATA,__data"
        continue
    if re.match("\t.section\t.rodata.str1.8", line):
        print "\t.section\t__TEXT,__cstring,cstring_literals"
        continue
    if re.match("\t.section\t.rodata", line):
        print "\t.section\t__DATA,__const"
        continue
    if re.match("\t.section\t.debug_info", line):
        break

    #   adrp    x0, :got:ftiming             => adrp    adrp x8, _ftiming@GOTPAGE
    #   ldr     x0, [x0, #:got_lo12:ftiming] => ldr     x8, [x8, _ftiming@GOTPAGEOFF]
    m = re.match("\tadrp\tx([0-9]{1,2}), :got:(.*)", line)
    if m:
        print("\tadrp\tx{0}, {1}@GOTPAGE".format(m.group(1), sym(m.group(2))))
        continue
    m = re.match("\tldr\tx([0-9]{1,2}), \[x([0-9]{1,2}), #:got_lo12:(.*)\]", line)
    if m:
        print("\tldr\tx{0}, [x{1}, {2}@GOTPAGEOFF]".format(m.group(1), m.group(2), sym(m.group(3))))
        continue

    # adrp    x1, .LC11           => adrp    x1, l_.str.6@PAGE
    # add     x1, x1, :lo12:.LC11 => add     x1, x1, l_.str.6@PAGEOFF
    m = re.match("\tadrp\tx([0-9]{1,2}), (.*)", line)
    if m:
        print("\tadrp\tx{0}, {1}@PAGE".format(m.group(1), sym(m.group(2))))
        continue
    m = re.match("\tadd\tx([0-9]{1,2}), x([0-9]{1,2}), :lo12:(.*)", line)
    if m:
        print("\tadd\tx{0}, x{1}, {2}@PAGEOFF".format(m.group(1), m.group(2), sym(m.group(3))))
        continue

    # symbols
    m = re.match("\tbl\t(.*)", line)
    if m:
        print("\tbl\t{0}".format(sym(m.group(1))))
        continue
    m = re.match("(.*):", line)
    if m and not m.group(1).startswith('\t'):
        print("{0}:".format(sym(m.group(1))))
        continue
    m = re.match("\t.global\t(.*)", line)
    if m:
        print("\t.global\t{0}".format(sym(m.group(1))))
        continue

    print line,
