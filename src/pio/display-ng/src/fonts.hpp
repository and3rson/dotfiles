#pragma once

#include <Arduino.h>

typedef uint8_t Glyph[9];

typedef struct {
    Glyph glyphs[128];
} Font;

extern Font FONT_5x7;
extern Font FONT_4x7;
extern Font FONT_3x7;
extern Font FONT_3x5;
