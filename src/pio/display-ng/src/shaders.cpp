#include "shaders.hpp"

CRGB randomColorShader(uint8_t x, uint8_t y, uint32_t time) {
    return CHSV(random(255), 255, 64);
}

CRGB whiteShader(uint8_t x, uint8_t y, uint32_t time) {
    return CRGB(255, 255, 32);
}

CRGB redShader(uint8_t x, uint8_t y, uint32_t time) {
    return CHSV(0, 255, 64);
}

CRGB greenShader(uint8_t x, uint8_t y, uint32_t time) {
    return CHSV(64, 255, 64);
}

CRGB rainbowShader(uint8_t x, uint8_t y, uint32_t time) {
    return CHSV(x * 16 + y * 4 + time / 5, 255, 64);
}
