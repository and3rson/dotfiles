#include "clockmode.hpp"
#include "utils.hpp"

ClockMode::ClockMode() {
    char values[7] = "000000";
    this->hours.setText(&FONT_4x7, 2, values);
    this->minutes.setText(&FONT_4x7, 2, values + 2);
    this->seconds.setText(&FONT_4x7, 2, values + 4);
}

void ClockMode::mount(Display *display) {
    display->addBlock(&this->icon);
    display->addBlock(&this->hours);
    display->addBlock(&this->minutes);
    display->addBlock(&this->seconds);
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
        lastSecondChange = millis64(); // TODO: Draw underline for seconds?

        char values[6] = {
            (char)(timeinfo->tm_hour / 10 + '0'), (char)(timeinfo->tm_hour % 10 + '0'), (char)(timeinfo->tm_min / 10 + '0'), (char)(timeinfo->tm_min % 10 + '0'), (char)(timeinfo->tm_sec / 10 + '0'), (char)(timeinfo->tm_sec % 10 + '0'),
        };
        this->hours.setText(&FONT_4x7, 2, values);
        this->minutes.setText(&FONT_4x7, 2, values + 2);
        this->seconds.setText(&FONT_3x5, 2, values + 4);
    }
    sfract15 ratio = clamp((millis64() - lastSecondChange) * 32768 / 1000, 0, 32767);
    this->seconds.setUnderline(ratio, timeinfo->tm_sec % 2);
}
