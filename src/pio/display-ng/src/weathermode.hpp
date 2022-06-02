#pragma once

#include <When.h>

#include "mode.hpp"
#include "iconblock.hpp"
#include "textblock.hpp"

#ifndef OWM_APPID
#    error "OWM_APPID is missing"
#endif

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
};
