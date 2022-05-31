#include "display.hpp"
#include "mode.hpp"
#include "block.hpp"

Display::Display() {}

void Display::render() {
    if (mode) {
        mode->process();
    }
    uint8_t offset = 0;
    for (int i = 0; i < nBlocks; i++) {
        offset = blocks[i]->render(&matrix.frame, offset);
    }
    matrix.latch();
}

void Display::setMode(Mode *newMode) {
    if (mode) {
        delete mode;
    }
    mode = newMode;
    while (nBlocks) {
        delete blocks[--nBlocks];
    }
    mode->mount(this);
}

void Display::addBlock(Block *block) {
    blocks[nBlocks++] = block;
}
