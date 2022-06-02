#include "textblock.hpp"
#include "utils.hpp"

uint8_t TextBlock::render(Frame *frame, uint8_t offset) {
    uint8_t newOffset = offset;
    if (lastChange != -1 && prevFont) {
        float k = (millis64() - lastChange) * 65535 / 250;
        if (k >= 65535) {
            k = 65535;
            lastChange = -1;
        }
        Frame current;
        uint8_t width = drawChars(&current, 0, nCurrentChars, currentChars, currentFont, &whiteShader);
        for (uint8_t relX = 0; relX < width; relX++) {
            for (uint8_t y = 0; y < ROWS; y++) {
                if (newOffset < COLS) {
                    uint16_t relI = Matrix::coordToIndex(relX, y);
                    uint16_t i = Matrix::coordToIndex(newOffset, y);
                    frame->leds[i] = prev.leds[relI].lerp16(current.leds[relI], k);
                }
            }
            newOffset++;
        }
    } else if (currentFont) {
        newOffset = drawChars(frame, offset, nCurrentChars, currentChars, currentFont, &whiteShader);
    } else {
        newOffset = nCurrentChars;
    }
    if (newOffset > offset) {
        uint8_t maxWidth = newOffset - offset - 1;
        uint8_t underlineWidth = clamp(((int32_t)underlineRatio) * maxWidth / 32767, 0, maxWidth);
        for (uint8_t i = 0; i < maxWidth; i++) {
            uint8_t x = offset + i;
            if (x < COLS) {
                frame->leds[Matrix::coordToIndex(x, 7)] = ((i < underlineWidth) != underlineInvert) ? CHSV(64, 255, 64) : CHSV(0, 0, 0);
            }
        }
    }
    return newOffset;
}

void TextBlock::setText(Font *newFont, uint8_t nNewChars, const char *newChars) {
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

            drawChars(&prev, 0, nPrevChars, prevChars, prevFont, &whiteShader);
        }

        currentFont = newFont;
        memcpy(currentChars, newChars, nNewChars);
        nCurrentChars = nNewChars;

        /* shader = shader == redShader ? greenShader : redShader; */

        lastChange = millis64();
    }
}

uint8_t TextBlock::drawChars(Frame *frame, uint8_t offset, uint8_t nChars, char *chars, Font *font, Shader *shader) {
    for (uint8_t i = 0; i < nChars; i++) {
        uint64_t time = millis64();
        uint8_t *value = font->glyphs[chars[i]];
        uint8_t width = value[0];
        for (uint8_t relX = 0; relX < width; relX++) {
            if (offset < COLS) {
                for (uint8_t y = 0; y < ROWS; y++) {
                    if (value[1 + y] & (1 << (width - relX - 1))) {
                        frame->leds[Matrix::coordToIndex(offset, y)] = shader->render(offset, y, time);
                        /* display[y] |= (1 << (31 - absOffset)); */
                    } else {
                        frame->leds[Matrix::coordToIndex(offset, y)] = CRGB::Black;
                    }
                }
            }
            offset++;
        }
        if (offset < COLS) {
            for (uint8_t y = 0; y < ROWS; y++) {
                frame->leds[Matrix::coordToIndex(offset, y)] = CRGB::Black;
            }
        }
        offset++;
    }
    return offset;
}

void TextBlock::setUnderline(sfract15 ratio, bool invert) {
    underlineRatio = ratio;
    underlineInvert = invert;
}
