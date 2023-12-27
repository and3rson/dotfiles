#include "clockmode.hpp"
#include "utils.hpp"

// ClockMode::ClockMode() : blocks{&this->icon, &this->hours, &this->minutes, 0} {
ClockMode::ClockMode() : blocks{&this->icon, &this->hours, &this->minutes, 0} {
    char values[7] = "0000";
    this->hours.setText(&FONT_3x5, 2, values);
    this->minutes.setText(&FONT_3x5, 2, values + 2);
}

Block **ClockMode::getBlocks() {
    return this->blocks;
}

void ClockMode::process() {
    if (lastUpdate.after(60000)) {
        /* Serial.println("Update"); */
        // configTime(MYTZ, "pool.ntp.org");
        configTzTime(MYTZ, "pool.ntp.org");
    }

    if (lastIconChange.after(15000)) {
        this->icon.setIcon(random(100));
    }

    struct timeval tv;
    gettimeofday(&tv, NULL);
    struct tm *timeinfo = localtime(&tv.tv_sec);
    /* localtime(const time_t *_timer); */
    /* gettimeofday(struct timeval *__p, void *__tz); */
    /* timeinfo = localtime(&now); */
    bool blink = (tv.tv_usec / 500000) % 2;
    // if (prevSec == 255 || prevSec != timeinfo->tm_sec) {
    //     prevSec = timeinfo->tm_sec;
    /* lastSecondChange = millis64(); // TODO: Draw underline for seconds? */

    char values[11] = {
        // Hours
        0,
        0,
        0,
        (char)(timeinfo->tm_hour / 10 + '0'),
        (char)(timeinfo->tm_hour % 10 + '0'),
        blink ? ':' : ' ',
        // Minutes
        (char)(timeinfo->tm_min / 10 + '0'),
        (char)(timeinfo->tm_min % 10 + '0'),
        // Seconds
        (char)(timeinfo->tm_sec / 10 + '0'),
        (char)(timeinfo->tm_sec % 10 + '0'),
    };
    this->hours.setText(&FONT_3x5, 6, values);
    this->minutes.setText(&FONT_3x5, 2, values + 6);
    // }
    /* sfract15 ratio = clamp((millis64() - lastSecondChange) * 16384 / 1000 + (timeinfo->tm_sec % 2) * 16384, 0, 32767); */
    sfract15 ratio = clamp(((uint64_t)tv.tv_usec) * 16384 / 1000000 + (timeinfo->tm_sec % 2) * 16384, 0, 32767);
}
