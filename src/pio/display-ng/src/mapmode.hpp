#pragma once

#include <TZ.h>
#include "AsyncHTTPRequest_Generic.hpp"

#include <When.h>

#include "mode.hpp"
#include "imageblock.hpp"

#define MYTZ TZ_Europe_Kiev

extern uint8_t mapData[];

class MapMode : public Mode {
   public:
    MapMode();
    Block **getBlocks();
    void process();

   private:
    static void requestCB(void* optParm, AsyncHTTPRequest* request, int readyState);

    When lastUpdate;
    /* When lastIconChange; */
    /* /1* uint64_t lastSecondChange; *1/ */
    /* uint8_t prevSec = 255; */
    ImageBlock map;

    Block *blocks[16];
};
