#pragma once

#include <FastLED.h>

#define ROWS 8
#define COLS 36
#define LED_COUNT (ROWS * COLS) // 288
#define LED_PIN 3

typedef struct {
    CRGB leds[LED_COUNT];
} Frame;

class Matrix {
   public:
    Matrix();
    void clear();
    void latch();
    static uint16_t coordToIndex(uint8_t x, uint8_t y);

    Frame frame;
};
