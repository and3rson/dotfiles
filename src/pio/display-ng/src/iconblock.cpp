#include "iconblock.hpp"

uint8_t IconBlock::render(Frame *frame, uint8_t offset) {
    if (iconIndex != 255) {
        for (uint8_t y = 0; y < 8; y++) {
            for (uint8_t x = 0; x < 8; x++) {
                uint8_t *hsv = ICONS[iconIndex][y][x];
                uint8_t absOffset = offset + x;
                frame->leds[Matrix::coordToIndex(absOffset, y)] = CHSV(hsv[0], hsv[1], hsv[2] / 4);
            }
        }
    }
    return 9;
}

void IconBlock::setIcon(uint8_t newIconIndex) {
    iconIndex = newIconIndex;
}
