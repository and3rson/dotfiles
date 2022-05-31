#pragma once

#include <When.h>

#include "mode.hpp"
#include "iconblock.hpp"
#include "textblock.hpp"

#define ICONDEF_COUNT 11

typedef struct {
    const char *code;
    int index;
} icondef_t;

class WeatherMode : public Mode {
   public:
    WeatherMode();
    void mount(Display *display);
    void process();
    uint8_t findIcon(const char *code);

   private:
    IconBlock icon;
    TextBlock temp;
    TextBlock suffix;
    When lastUpdate;

    icondef_t icondefs[ICONDEF_COUNT] = {
        {"01d", 100},
        {"01n", 101},
        {"02d", 102},
        {"02n", 103},
        {"03", 104},
        {"04", 104},
        {"09", 105},
        {"10", 105},
        {"11", 106},
        {"13", 107},
        {"50", 108},
    };
};
