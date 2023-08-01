#pragma once

#include <Arduino.h>

typedef uint8_t Glyph[9];

typedef struct {
    Glyph glyphs[128];
} Font;

extern const Font FONT_5x7 PROGMEM;
extern const Font FONT_4x7 PROGMEM;
extern const Font FONT_3x7 PROGMEM;
extern const Font FONT_3x5 PROGMEM;
