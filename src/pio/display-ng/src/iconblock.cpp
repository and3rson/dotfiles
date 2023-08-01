#include "iconblock.hpp"

uint8_t IconBlock::render(Frame *frame, uint8_t offset) {
    uint8_t black[] = {0, 0, 0};
    if (iconIndex != 255) {
        for (uint8_t y = 0; y < 8; y++) {
            for (uint8_t x = 0; x < 9; x++) {
                uint8_t absOffset = offset + x;
                uint8_t hsv[3];
                memcpy_P(hsv, x < 8 ? ICONS[iconIndex][y][x] : black, 3);
                /* uint8_t *hsv = x < 8 ? ICONS[iconIndex][y][x] : black; */
                frame->leds[Matrix::coordToIndex(absOffset, y)] = CHSV(hsv[0], hsv[1], hsv[2]);
            }
        }
    }
    return 9;
}

void IconBlock::setIcon(uint8_t newIconIndex) {
    iconIndex = newIconIndex;
}
