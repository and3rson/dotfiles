#include <HardwareSerial.h>
#include <ArduinoOTA.h>

#include <FastLED.h>
#include <TZ.h>

#include <Spawn.h>
#include <When.h>
#include "display.hpp"
#include "clockmode.hpp"

Spawn spawn("spawn_display_ng", false);
Display display;

void setup() {
    spawn.setup();
    /* Serial.end(); */
    ArduinoOTA.begin();

    display.setMode(new ClockMode());
}

uint32_t lastIconChange = 0;

void loop() {
    /* int prev = iter, next = ++iter; */
    /* iter = iter % 240; */
    /* leds[prev] = CRGB::Black; */
    /* leds[next] = CRGB::Green; */
    ArduinoOTA.handle();
    if (spawn.connect()) {
    }
    /* time_t now; */
    /* struct tm *timeinfo; */
    /* time(&now); */
    /* timeinfo = localtime(&now); */
    /* uint8_t values[6] = { */
    /*     (uint8_t)(timeinfo->tm_hour / 10), (uint8_t)(timeinfo->tm_hour % 10), (uint8_t)(timeinfo->tm_min / 10), (uint8_t)(timeinfo->tm_min % 10), */
    /*     (uint8_t)(timeinfo->tm_sec / 10),  (uint8_t)(timeinfo->tm_sec % 10) */
    /*     /1* timeinfo->tm_min / 10, timeinfo->tm_min % 10, timeinfo->tm_sec / 10, timeinfo->tm_sec % 10, *1/ */
    /* }; */

    /* /1* uint8_t offset = 0; *1/ */
    /* /1* for (int i = 0; i < 6; i++) { *1/ */
    /* /1*     offset = drawDigit(offset, values[i], rainbowShader); *1/ */
    /* /1* } *1/ */
    /* if (millis() - lastIconChange > 15000) { */
    /*     display.setIcon(random(100)); */
    /*     lastIconChange = millis(); */
    /* } */
    /* display.setDigits(values); */
    /* display.render(); */
    /* FastLED.show(); */
    display.render();
    delay(15);
}
