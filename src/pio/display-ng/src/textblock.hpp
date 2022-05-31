#pragma once

#include "block.hpp"
#include "fonts.hpp"
#include "shaders.hpp"

class TextBlock : public Block {
   public:
    uint8_t render(Frame *frame, uint8_t offset);
    void setText(Font *font, uint8_t nChars, char *chars);
    uint8_t drawChars(Frame *frame, uint8_t offset, uint8_t nChars, char *chars, Font *font, shader_t shader);

   private:
    Font *prevFont = 0;
    char prevChars[16];
    uint8_t nPrevChars = 0;
    Font *currentFont = 0;
    char currentChars[16];
    uint8_t nCurrentChars = 0;
    int32_t lastChange = -1; // TODO: int64?
    /* shader_t shader = redShader; */
};
