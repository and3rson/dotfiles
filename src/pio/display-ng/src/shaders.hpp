#pragma once

#include <FastLED.h>

typedef CRGB (*shader_t)(uint8_t x, uint8_t y, uint32_t time);

CRGB rainbowShader(uint8_t x, uint8_t y, uint32_t time);
