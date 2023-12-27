#ifndef _WHEN_H_
#define _WHEN_H_

#include <ESP8266WiFi.h>
#include <stdint.h>

class When {
private:
    volatile bool initial;
    volatile uint32_t time;
public:
    When();
    When(uint32_t);
    bool after(uint32_t) volatile;
};
#endif
