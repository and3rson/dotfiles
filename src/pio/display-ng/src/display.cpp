#include "display.hpp"
#include "mode.hpp"
#include "block.hpp"
#include "utils.hpp"

Display::Display() {}

void Display::render() {
    uint64_t start = millis64();
    if (prevMode) {
        prevMode->process();
    }
    if (currentMode) {
        currentMode->process();
    }
    if (modeChanged != -1) {
        Frame prev = {0}, current = {0};
        uint8_t offset;
        uint64_t k = (millis64() - modeChanged) * 65535 / transitionTime;
        if (k >= 65535) {
            k = 65535;
            modeChanged = -1;
        }
        offset = 0;
        for (int i = 0; i < nPrevBlocks; i++) {
            offset = prevBlocks[i]->render(&prev, offset);
        }
        offset = 0;
        for (int i = 0; i < nCurrentBlocks; i++) {
            offset = currentBlocks[i]->render(&current, offset);
        }
        for (int y = 0; y < ROWS; y++) {
            for (int x = 0; x < COLS; x++) {
                int64_t k2 = clamp(k * 4 - ((int64_t)x) * 65535 / COLS * 2 - ((int64_t)y) * 65535 / ROWS / 2, 0, 65535);
                uint16_t i = Matrix::coordToIndex(x, y);
                matrix.frame.leds[i] = prev.leds[i].lerp16(current.leds[i], k2);
            }
        }
    } else {
        uint8_t offset = 0;
        for (int i = 0; i < nCurrentBlocks; i++) {
            offset = currentBlocks[i]->render(&matrix.frame, offset);
        }
    }
    uint64_t duration = millis64() - start;
    if (lastFPSRender.after(200)) {
        lastFPS = 1000 / (duration ? duration : 1);
    }
    uint32_t fps = lastFPS;
    uint8_t pos = 0;
    while (fps >= 100) {
        matrix.frame.leds[Matrix::coordToIndex(pos++, 7)] = CRGB::Blue;
        fps -= 100;
    }
    while (fps >= 10) {
        matrix.frame.leds[Matrix::coordToIndex(pos++, 7)] = CRGB::Red;
        fps -= 10;
    }
    while (fps) {
        matrix.frame.leds[Matrix::coordToIndex(pos++, 7)] = CRGB::Green;
        fps--;
    }
    while (pos < COLS / 2) {
        matrix.frame.leds[Matrix::coordToIndex(pos++, 7)] = CRGB::Black;
    }
    /* matrix.frame.leds[Matrix::coordToIndex(frame, 7)] = CRGB::Black; */
    /* frame = (frame + 1) % COLS; */
    /* matrix.frame.leds[Matrix::coordToIndex(frame, 7)] = CRGB::Green; */
    matrix.latch();
    /* uint64_t duration = millis() - start; */
    /* if (lastFPS.after(250)) { */
    /*     for (int i = 0; i < 16; i++) { */
    /*         bool on = (duration >> i) & 1; */
    /*         matrix.frame.leds[Matrix::coordToIndex(31 - i, 7)] = on ? CRGB::Green : CRGB::Black; */
    /*     } */
    /*     matrix.latch(); */
    /* } */
}

void Display::setMode(Mode *newMode) {
    prevMode = currentMode;
    memcpy(prevBlocks, currentBlocks, sizeof(Block *) * nCurrentBlocks);
    nPrevBlocks = nCurrentBlocks;

    currentMode = newMode;
    nCurrentBlocks = 0;
    currentMode->mount(this);

    modeChanged = millis64();

    /* matrix.clear(); */
    /* matrix.latch(); */
}

void Display::addBlock(Block *block) {
    currentBlocks[nCurrentBlocks++] = block;
}
