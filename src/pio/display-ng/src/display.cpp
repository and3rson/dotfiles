#include "display.hpp"
#include "mode.hpp"
#include "block.hpp"
#include "utils.hpp"

Display::Display() {}

void Display::render() {
    Frame prev, current;
    uint64_t start = millis64();
    if (currentMode) {
        currentMode->process();
    }
    if (modeChanged != -1) {
        if (prevMode) {
            prevMode->process();
        }

        memset(&prev, 0, sizeof(Frame));
        memset(&current, 0, sizeof(Frame));
        uint8_t offset;
        fract16 k = clamp((millis64() - modeChanged) * 65535 / transitionTime, 0, 65535);
        if (k == 65535) {
            modeChanged = -1;
        }
        renderMode(&prev, prevMode, &prevBlockmap);
        renderMode(&current, currentMode, &currentBlockmap);
        for (int y = 0; y < ROWS; y++) {
            for (int x = 0; x < COLS; x++) {
                int64_t k2 = clamp(k * 4 - ((int64_t)x) * 65535 / COLS * 2 - ((int64_t)y) * 65535 / ROWS / 2, 0, 65535);
                uint16_t i = Matrix::coordToIndex(x, y);
                matrix.frame.leds[i] = prev.leds[i].lerp16(current.leds[i], k2);
            }
        }
    } else {
        renderMode(&matrix.frame, currentMode, &currentBlockmap);
    }
    uint64_t duration = millis64() - start;
    if (lastFPSRender.after(200)) {
        lastFPS = 1000 / (duration ? duration : 1);
        lastFrameDuration = duration;
    }
    /* renderFPS(); */
    matrix.latch();
}

void Display::setMode(Mode *newMode) {
    prevMode = currentMode;
    prevBlockmap << currentBlockmap;

    currentMode = newMode;
    currentBlockmap.clear();

    Block **blocks = currentMode->getBlocks();
    while (Block *current = *(blocks++)) {
        currentBlockmap.addBlock(current);
    }

    modeChanged = millis64();
}

void Display::addBlock(Block *block) {
    currentBlockmap.blocks[currentBlockmap.count++] = block;
}

uint8_t Display::renderMode(Frame *frame, Mode *mode, Blockmap *blockmap) {
    uint8_t offset = 0;
    for (int i = 0; i < blockmap->count; i++) {
        offset = blockmap->blocks[i]->render(frame, offset);
    }
    return offset;
}

void Display::renderFPS() {
    uint32_t duration = lastFrameDuration;
    uint8_t pos = 0;
    while (duration >= 100) {
        matrix.frame.leds[Matrix::coordToIndex(pos++, 7)] = CRGB::Blue;
        duration -= 100;
    }
    while (duration >= 10) {
        matrix.frame.leds[Matrix::coordToIndex(pos++, 7)] = CRGB::Red;
        duration -= 10;
    }
    while (duration) {
        matrix.frame.leds[Matrix::coordToIndex(pos++, 7)] = CRGB::Green;
        duration--;
    }
    while (pos < COLS) {
        matrix.frame.leds[Matrix::coordToIndex(pos++, 7)] = CRGB::Black;
    }
}
