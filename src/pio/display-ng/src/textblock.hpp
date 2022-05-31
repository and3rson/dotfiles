#pragma once

#include "block.hpp"
#include "fonts.hpp"
#include "shaders.hpp"

class TextBlock : public Block {
   public:
    uint8_t render(Frame *frame, uint8_t offset);
    void setText(Font *font, uint8_t nDigits, uint8_t *digits);
    uint8_t drawChars(Frame *frame, uint8_t offset, uint8_t nChars, uint8_t *chars, Font *font, shader_t shader);

   private:
    Font *prevFont = 0;
    uint8_t prevDigits[16];
    uint8_t nPrevDigits = 0;
    Font *font = 0;
    uint8_t digits[16];
    uint8_t nDigits = 0;
    int32_t changed = -1; // TODO: int64?
};
