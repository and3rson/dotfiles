#pragma once

#include <FastLED.h>

#include <When.h>

#include "matrix.hpp"

class Mode;
class Block;

#define BLOCKMAP_SIZE 16

class Blockmap {
   public:
    Block *blocks[BLOCKMAP_SIZE];
    uint8_t count = 0;

    void addBlock(Block *block) {
        blocks[count++] = block;
    };
    void clear() {
        count = 0;
    }
    Blockmap *operator<<(Blockmap &other) {
        memcpy(this->blocks, other.blocks, sizeof(Block *) * BLOCKMAP_SIZE);
        this->count = other.count;
        return this;
    }
};

class Display {
   public:
    Display();
    void render();

    void setMode(Mode *mode);
    void addBlock(Block *blocks);

   private:
    uint8_t renderMode(Frame *frame, Mode *mode, Blockmap *blockmap);
    void renderFPS();

    Matrix matrix;

    uint64_t transitionTime = 500;
    int64_t modeChanged = -1;

    Mode *prevMode = 0;
    Blockmap prevBlockmap;
    Mode *currentMode = 0;
    Blockmap currentBlockmap;

    When lastFPSRender;
    uint64_t lastFPS = 0;
    uint64_t lastFrameDuration = 0;
};
