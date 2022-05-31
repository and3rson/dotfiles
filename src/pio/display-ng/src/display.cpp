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
    mode = newMode;
    nBlocks = 0;
    mode->mount(this);

    matrix.clear();
    matrix.latch();
}

void Display::addBlock(Block *block) {
    blocks[nBlocks++] = block;
}
