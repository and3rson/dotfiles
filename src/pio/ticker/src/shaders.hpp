#pragma once

#include <FastLED.h>

typedef CRGB (*shader_t)(uint8_t x, uint8_t y, uint64_t time);

class Shader {
   public:
    virtual CRGB render(uint8_t x, uint8_t y, uint64_t time);
    virtual ~Shader() = default;
};

class RainbowShader : public Shader {
   public:
    CRGB render(uint8_t x, uint8_t y, uint64_t time);
};

class RandomColorShader : public Shader {
   public:
    CRGB render(uint8_t x, uint8_t y, uint64_t time);
};

class ColorShader : public Shader {
   public:
    ColorShader(CRGB color = CRGB::Black);
    void setColor(CRGB color);
    CRGB render(uint8_t x, uint8_t y, uint64_t time);
   private:
    CRGB color;
};

/* CRGB whiteShader(uint8_t x, uint8_t y, uint32_t time); */
/* CRGB redShader(uint8_t x, uint8_t y, uint32_t time); */
/* CRGB greenShader(uint8_t x, uint8_t y, uint32_t time); */
/* CRGB randomColorShader(uint8_t x, uint8_t y, uint32_t time); */
/* CRGB rainbowShader(uint8_t x, uint8_t y, uint32_t time); */
