#pragma once

#include "block.hpp"
#include "fonts.hpp"
#include "shaders.hpp"

class TextBlock : public Block {
   public:
    uint8_t render(Frame *frame, uint8_t offset);
    void setText(Font *font, uint8_t nChars, const char *chars);
    uint8_t drawChars(Frame *frame, uint8_t offset, uint8_t nChars, char *chars, Font *font, Shader *shader);
    void setBorder(sfract15 ratio, bool visible);

   private:
    Font *prevFont = 0;
    char prevChars[16];
    uint8_t nPrevChars = 0;
    Font *currentFont = 0;
    char currentChars[16];
    uint8_t nCurrentChars = 0;
    int64_t lastChange = -1;
    sfract15 borderRatio = 0;
    bool borderVisible = false;

    Frame prev;
    ColorShader whiteShader = ColorShader(CHSV(0, 0, 64));
    /* shader_t shader = redShader; */
};
