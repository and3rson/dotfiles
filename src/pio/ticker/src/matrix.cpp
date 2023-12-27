#include "matrix.hpp"

Matrix::Matrix() {
    this->pixels = new Adafruit_NeoPixel(LED_COUNT, 21, NEO_GRB + NEO_KHZ800);
    // FastLED.addLeds<NEOPIXEL, LED_PIN>(frame.leds, LED_COUNT);
    this->pixels->begin();
    this->pixels->clear();
    this->pixels->setBrightness(12);
    for (uint16_t i = 0; i < LED_COUNT; i++) {
        this->frame.leds[i] = 0;
    }
}

void Matrix::clear() {
    for (uint16_t i = 0; i < LED_COUNT; i++) {
        this->frame.leds[i] = 0;
    }
}

void Matrix::latch() {
    pixels->clear();
    for (uint16_t i = 0; i < LED_COUNT; i++) {
        pixels->setPixelColor(i, (this->frame.leds[i].r << 16) | (this->frame.leds[i].g << 8) | this->frame.leds[i].b);
    }
    pixels->show();
    // FastLED.setBrightness(8);
    // FastLED.show();
}

// uint16_t Matrix::coordToIndex(uint8_t x, uint8_t y) {
//     if (x >= COLS) {
//         x = COLS - 1;
//     }
//     if (y >= ROWS) {
//         y = ROWS - 1;
//     }
//     if (y % 2 == 0) {
//         x = COLS - x - 1;
//     }
//     return ((uint16_t)y) * COLS + x;
// }
uint16_t Matrix::coordToIndex(uint8_t x, uint8_t y) {
    if (x >= COLS) {
        x = COLS - 1;
    }
    if (y >= ROWS) {
        y = ROWS - 1;
    }
    if (x % 2 == 1) {
        y = ROWS - y - 1;
    }
    // Horizontal rows:
    // return ((uint16_t)y) * COLS + x;
    // Vertical rows:
    return ((uint16_t)x) * ROWS + y;
}

