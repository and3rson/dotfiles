#include "imageblock.hpp"

uint8_t ImageBlock::render(Frame *frame, uint8_t offset) {
    /* uint8_t black[] = {0, 0, 0}; */
    /* if (iconIndex != 255) { */
    /*     for (uint8_t y = 0; y < 8; y++) { */
    /*         for (uint8_t x = 0; x < 9; x++) { */
    /*             uint8_t absOffset = offset + x; */
    /*             uint8_t *hsv = x < 8 ? ICONS[iconIndex][y][x] : black; */
    /*             frame->leds[Matrix::coordToIndex(absOffset, y)] = CHSV(hsv[0], hsv[1], hsv[2]); */
    /*         } */
    /*     } */
    /* } */
    for (uint8_t y = 0; y < 8; y++) {
        for (uint8_t x = 0; x < width; x++) {
            uint16_t tplOffset = ((uint16_t)y) * width + ((uint16_t)x);
            uint8_t id = tpl[tplOffset];
            CHSV color = colors[id];

            uint8_t absOffset = offset + extraOffset + x;
            frame->leds[Matrix::coordToIndex(absOffset, y)] = color;
        }
    }
    return width + 1;
}

void ImageBlock::setExtraOffset(uint8_t newExtraOffset) {
    extraOffset = newExtraOffset;
}

void ImageBlock::setTemplate(uint8_t *newTpl) {
    tpl = newTpl;
}

void ImageBlock::setWidth(uint8_t newWidth) {
    width = newWidth;
}

void ImageBlock::setColor(uint8_t id, CHSV color) {
    colors[id] = color;
}
