#pragma once

#include <FastLED.h>

#include <When.h>

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

    uint64_t transitionTime = 500;
    int64_t modeChanged = -1;

    Mode *prevMode = 0;
    Block *prevBlocks[16];
    uint8_t nPrevBlocks = 0;
    Mode *currentMode = 0;
    Block *currentBlocks[16];
    uint8_t nCurrentBlocks = 0;

    When lastFPSRender;
    uint8_t frame = 0;
    uint64_t lastFPS = 0;
};
