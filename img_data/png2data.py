import sys
from PIL import Image

path_name = 'cat.data'

def binstr(x, length):
    str = bin(x)[2:]
    l = length - len(str)
    if l > 0:
        return '0' * l + str
    else:
        return str

def hexstr(x, length):
    str = hex(x)[2:]
    l = length - len(str)
    if l > 0:
        return '0' * l + str
    else:
        return str

addr = 32768;

with open(path_name, 'wb') as f:
    img = sys.argv[1]
    im = Image.open(img)
    width, height = im.size
    print(im.mode)

    ratio = 0
    change = 0
    if (width > 320):
        width = 320
        change = 1
    else:
        if width < 16:
            exit()

    if (height > 240):
        height = 240
        change = 1
    else:
        if height < 8:
            exit()

    if change == 1:
        new_im = im.resize((width, height), Image.ANTIALIAS)

    pix = new_im.load()

    print(pix[0, 0])
    for y in range(height):
        for x in range(width):
            tmp = hex(addr)[2:]
            ddr = "0"*(6-len(tmp)) + tmp;
            addr += 1
            R = pix[x, y][0]
            G = pix[x, y][1]
            B = pix[x, y][2]
            i=R/32*64+G/32*8+B/32
            s=hex(int(i))[2:]
            s="0"*(4-len(s))+s
            w_str = ddr + '=' + s + "\n"
            f.write(str.encode(w_str))