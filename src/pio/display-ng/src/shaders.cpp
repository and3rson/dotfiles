#include "shaders.hpp"

CRGB rainbowShader(uint8_t x, uint8_t y, uint32_t time) {
    return CHSV(x * 16 + y * 4 + time / 5, 255, 64);
}
