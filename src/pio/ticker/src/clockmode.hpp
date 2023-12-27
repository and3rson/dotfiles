#pragma once

#include <When.h>

#include "mode.hpp"
#include "iconblock.hpp"
#include "textblock.hpp"

#define MYTZ PSTR("EET-2EEST,M3.5.0/3,M10.5.0/4") // Europe/Kyiv

class ClockMode : public Mode {
   public:
    ClockMode();
    Block **getBlocks();
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

    Block *blocks[16];
};
