#pragma once

#include <When.h>

#include "mode.hpp"
#include "iconblock.hpp"
#include "textblock.hpp"

#ifndef YOUTUBE_API_KEY
#    error "YOUTUBE_API_KEY not defined"
#endif

#define ICONDEF_COUNT 11

typedef struct {
    const char *code;
    int index;
} icondef_t;

class TickerMode : public Mode {
   public:
    TickerMode();
    Block **getBlocks();
    void process();

   private:
    IconBlock icon;
    TextBlock count;
    // TextBlock suffix;
    When lastUpdate;

    icondef_t icondefs[ICONDEF_COUNT] = {
        // Clear
        {"01d", 100},
        {"01n", 101},
        // Few clouds
        {"02d", 102},
        {"02n", 103},
        // Scattered clouds
        {"03", 104},
        // Broken clouds
        {"04", 104},
        // Shower rain
        {"09", 105},
        // Rain
        {"10", 105},
        // Thunderstorm
        {"11", 106},
        // Snow
        {"13", 107},
        // Mist
        {"50", 108},
    };

    Block *blocks[16];
};
