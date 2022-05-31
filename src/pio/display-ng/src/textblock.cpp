#include "textblock.hpp"

uint8_t TextBlock::render(Frame *frame, uint8_t offset) {
    if (lastChange != -1 && millis() - lastChange < 250 && prevFont) {
        Frame prev, current;
        uint8_t offset1 = drawChars(&prev, offset, nPrevChars, prevChars, prevFont, whiteShader);
        uint8_t offset2 = drawChars(&current, offset, nCurrentChars, currentChars, currentFont, whiteShader);
        float k = ((float)millis() - lastChange) / 250.0f;
        uint8_t newOffset = offset1 > offset2 ? offset1 : offset2;
        for (uint8_t y = 0; y < ROWS; y++) {
            for (uint8_t x = offset; x < newOffset; x++) {
                uint16_t i = Matrix::coordToIndex(x, y);
                frame->leds[i].r = (1.0f - k) * prev.leds[i].r + k * current.leds[i].r;
                frame->leds[i].g = (1.0f - k) * prev.leds[i].g + k * current.leds[i].g;
                frame->leds[i].b = (1.0f - k) * prev.leds[i].b + k * current.leds[i].b;
            }
        }
        return offset2;
    } else if (currentFont) {
        lastChange = -1;
        return drawChars(frame, offset, nCurrentChars, currentChars, currentFont, whiteShader);
    } else {
        return nCurrentChars;
    }
}

void TextBlock::setText(Font *newFont, uint8_t nNewChars, char *newChars) {
    bool changed = false;
    if (newFont != currentFont) {
        changed = true;
    } else if (nNewChars != nCurrentChars) {
        changed = true;
    } else {
        for (uint8_t i = 0; i < nCurrentChars; i++) {
            if (newChars[i] != currentChars[i]) {
                changed = true;
            }
        }
    }
    if (changed) {
        if (currentFont) {
            prevFont = currentFont;
            memcpy(prevChars, currentChars, nCurrentChars);
            nPrevChars = nCurrentChars;
        }

        currentFont = newFont;
        memcpy(currentChars, newChars, nNewChars);
        nCurrentChars = nNewChars;

        /* shader = shader == redShader ? greenShader : redShader; */

        lastChange = millis();
    }
}

uint8_t TextBlock::drawChars(Frame *frame, uint8_t offset, uint8_t nChars, char *chars, Font *font, shader_t shader) {
    for (uint8_t i = 0; i < nChars; i++) {
        uint32_t time = millis();
        uint8_t *value = font->glyphs[chars[i]];
        uint8_t width = value[0];
        for (uint8_t relX = 0; relX < width; relX++) {
            if (offset < COLS) {
                for (uint8_t y = 0; y < ROWS; y++) {
                    if (value[1 + y] & (1 << (width - relX - 1))) {
                        frame->leds[Matrix::coordToIndex(offset, y)] = shader(offset, y, time);
                        /* display[y] |= (1 << (31 - absOffset)); */
                    } else {
                        frame->leds[Matrix::coordToIndex(offset, y)] = CRGB::Black;
                    }
                }
                offset++;
            }
        }
        if (offset < COLS) {
            for (uint8_t y = 0; y < ROWS; y++) {
                frame->leds[Matrix::coordToIndex(offset, y)] = CRGB::Black;
            }
            offset++;
        }
    }
    return offset;
}
