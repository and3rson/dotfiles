#pragma once

#include <TZ.h>

#include <When.h>

#include "mode.hpp"
#include "iconblock.hpp"
#include "textblock.hpp"

#define MYTZ TZ_Europe_Kiev

class ClockMode : public Mode {
   public:
    ClockMode();
    void mount(Display *display);
    void process();

   private:
    When lastUpdate;
    When lastIconChange;
    /* uint64_t lastSecondChange; */
    uint8_t prevSec = 255;
    IconBlock icon;
    TextBlock hours;
    TextBlock minutes;
    TextBlock seconds;
};
