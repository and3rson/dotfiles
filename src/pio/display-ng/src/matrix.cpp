#include "matrix.hpp"

Matrix::Matrix() {
    FastLED.addLeds<NEOPIXEL, LED_PIN>(frame.leds, LED_COUNT);
    for (uint16_t i = 0; i < LED_COUNT; i++) {
        this->frame.leds[i] = 0;
    }
}

void Matrix::latch() {
    FastLED.show();
}

uint16_t Matrix::coordToIndex(uint8_t x, uint8_t y) {
    if (x > COLS) {
        x = COLS - 1;
    }
    if (y > ROWS) {
        y = ROWS - 1;
    }
    if (y % 2 == 0) {
        x = COLS - x - 1;
    }
    return ((uint16_t)y) * COLS + x;
}
