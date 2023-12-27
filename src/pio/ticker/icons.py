#!/usr/bin/env python3

from colorsys import rgb_to_hsv

from PIL import Image

img = Image.open("icons.png")
print('#include "icons.hpp"')
print()
print("const uint8_t ICONS[][8][8][3] = {")
for y in range(11):
    for x in range(10):
        print("    {")
        for py in range(8):
            print("        {")
            for px in range(8):
                px = img.getpixel((x * 8 + px, y * 8 + py))[:3]
                if all(c < 32 for c in px):
                    px = (0, 0, 0)
                hsv = rgb_to_hsv(*(c / 255 for c in px))
                px = [int(c * 255) for c in hsv]
                # px = [int(c * 0.1) for c in px[:3]]
                print(f"            {{0x{px[0]:02x}, 0x{px[1]:02x}, 0x{px[2]:02x}}},")
            print("        },")
        print("    },")
print("};")
