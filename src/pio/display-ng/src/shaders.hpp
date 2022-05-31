#pragma once

#include <FastLED.h>

typedef CRGB (*shader_t)(uint8_t x, uint8_t y, uint32_t time);

CRGB whiteShader(uint8_t x, uint8_t y, uint32_t time);
CRGB redShader(uint8_t x, uint8_t y, uint32_t time);
CRGB greenShader(uint8_t x, uint8_t y, uint32_t time);
CRGB randomColorShader(uint8_t x, uint8_t y, uint32_t time);
CRGB rainbowShader(uint8_t x, uint8_t y, uint32_t time);
