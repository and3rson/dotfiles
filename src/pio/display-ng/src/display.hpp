#pragma once

#include <FastLED.h>

#include "matrix.hpp"

class Mode;
class Block;

class Display {
   public:
    Display();
    void render();

    void setMode(Mode *mode);
    void addBlock(Block *blocks);

   private:
    Matrix matrix;

    Mode *mode = 0;

    Block *blocks[16];
    uint8_t nBlocks = 0;
};
