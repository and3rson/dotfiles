#include "textblock.hpp"

uint8_t TextBlock::render(Frame *frame, uint8_t offset) {
    /* return drawChars(frame, offset, nDigits, digits, font, rainbowShader); */
    if (changed != -1 && millis() - changed < 250 && prevFont) {
        Frame prev, next;
        uint8_t offset1 = drawChars(&prev, offset, nPrevDigits, prevDigits, prevFont, rainbowShader);
        uint8_t offset2 = drawChars(&next, offset, nDigits, digits, font, rainbowShader);
        float k = ((float)millis() - changed) / 250.0f;
        uint8_t newOffset = offset1 > offset2 ? offset1 : offset2;
        for (uint8_t y = 0; y < ROWS; y++) {
            for (uint8_t x = offset; x < newOffset; x++) {
                uint16_t i = Matrix::coordToIndex(x, y);
                frame->leds[i].r = (1.0f - k) * prev.leds[i].r + k * next.leds[i].r;
                frame->leds[i].g = (1.0f - k) * prev.leds[i].g + k * next.leds[i].g;
                frame->leds[i].b = (1.0f - k) * prev.leds[i].b + k * next.leds[i].b;
            }
        }
        return offset2;
    } else if (font) {
        changed = -1;
        return drawChars(frame, offset, nDigits, digits, font, rainbowShader);
    } else {
        return nDigits;
    }
}

void TextBlock::setText(Font *newFont, uint8_t nNewDigits, uint8_t *newDigits) {
    bool changed = false;
    if (newFont != font) {
        changed = true;
    } else if (nNewDigits != nDigits) {
        changed = true;
    } else {
        for (uint8_t i = 0; i < nDigits; i++) {
            if (newDigits[i] != digits[i]) {
                changed = true;
            }
        }
    }
    if (changed) {
        prevFont = font;
        memcpy(prevDigits, digits, nDigits);
        nPrevDigits = nDigits;

        font = newFont;
        memcpy(digits, newDigits, nNewDigits);
        nDigits = nNewDigits;

        changed = millis();
    }
}

uint8_t TextBlock::drawChars(Frame *frame, uint8_t offset, uint8_t nChars, uint8_t *chars, Font *font, shader_t shader) {
    for (uint8_t i = 0; i < nChars; i++) {
        uint32_t time = millis();
        uint8_t *value = font->glyphs[chars[i]];
        uint8_t width = value[0];
        for (uint8_t y = 0; y < ROWS; y++) {
            if (y >= ROWS) {
                continue;
            }
            for (uint8_t x = 0; x < width; x++) {
                uint8_t absOffset = offset + x;
                if (absOffset >= COLS) {
                    continue;
                }
                if (value[1 + y] & (1 << (width - x - 1))) {
                    frame->leds[Matrix::coordToIndex(absOffset, y)] = shader(absOffset, y, time);
                    /* display[y] |= (1 << (31 - absOffset)); */
                } else {
                    frame->leds[Matrix::coordToIndex(absOffset, y)] = CRGB::Black;
                }
            }
        }
        offset += width;
    }
    return offset + 1;
}
