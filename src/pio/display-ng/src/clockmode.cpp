#include "clockmode.hpp"

void ClockMode::mount(Display *display) {
    display->addBlock(&this->icon);
    display->addBlock(&this->hours);
    display->addBlock(&this->minutes);
    display->addBlock(&this->seconds);

    uint8_t values[6] = {1, 2, 3, 4, 5, 6};
    this->hours.setText(&FONT_4x7, 2, values);
    this->minutes.setText(&FONT_4x7, 2, values + 2);
    this->seconds.setText(&FONT_4x7, 2, values + 4);
}

void ClockMode::process() {
    if (lastUpdate.after(60000)) {
        /* Serial.println("Update"); */
        configTime(MYTZ, "pool.ntp.org");
    }

    if (lastIconChange.after(15000)) {
        this->icon.setIcon(random(100));
    }

    time_t now;
    struct tm *timeinfo;
    time(&now);
    timeinfo = localtime(&now);
    if (prevSec == 255 || prevSec != timeinfo->tm_sec) {
        prevSec = timeinfo->tm_sec;

        uint8_t values[9] = {
            (uint8_t)(timeinfo->tm_hour / 10), 10, (uint8_t)(timeinfo->tm_hour % 10),
            (uint8_t)(timeinfo->tm_min / 10), 10, (uint8_t)(timeinfo->tm_min % 10),
            (uint8_t)(timeinfo->tm_sec / 10), 10, (uint8_t)(timeinfo->tm_sec % 10),
        };
        this->hours.setText(&FONT_4x7, 3, values);
        this->minutes.setText(&FONT_4x7, 3, values + 3);
        this->seconds.setText(&FONT_3x5, 3, values + 6);
    }
}
