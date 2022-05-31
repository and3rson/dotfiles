#pragma once

#include <Arduino.h>

typedef struct {
    uint8_t glyphs[11][9];
} Font;

extern Font FONT_5x7;
extern Font FONT_4x7;
extern Font FONT_3x7;
extern Font FONT_3x5;
