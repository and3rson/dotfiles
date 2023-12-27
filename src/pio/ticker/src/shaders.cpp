#include "shaders.hpp"

CRGB RainbowShader::render(uint8_t x, uint8_t y, uint64_t time) {
    return CHSV(x * 16 + y * 4 + time / 5, 255, 64);
}

CRGB RandomColorShader::render(uint8_t x, uint8_t y, uint64_t time) {
    return CHSV(random(255), 255, 64);
}

ColorShader::ColorShader(CRGB color) : color(color) {}

void ColorShader::setColor(CRGB color) {
    this->color = color;
}

CRGB ColorShader::render(uint8_t x, uint8_t y, uint64_t time) {
    return color;
}
