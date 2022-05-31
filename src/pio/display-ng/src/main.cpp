#include <HardwareSerial.h>
#include <ArduinoOTA.h>

#include <FastLED.h>
#include <TZ.h>

#include <Spawn.h>
#include <When.h>
#include "display.hpp"
#include "clockmode.hpp"
#include "weathermode.hpp"

Spawn spawn("spawn_display_ng", false);
Display display;
When modeSwitch;
uint8_t nextMode = 0;

ClockMode clockMode;
WeatherMode weatherMode;

void setup() {
    spawn.setup();
    ArduinoOTA.begin();
    spawn.connect();
    for (int i = 0; i < 300; i++) {
        ArduinoOTA.handle();
        delay(10);
    }
}

uint32_t lastIconChange = 0;

void loop() {
    ArduinoOTA.handle();
    if (spawn.connect()) {
    }

    if (modeSwitch.after(5000)) {
        if (nextMode == 0) {
            display.setMode(&clockMode);
        } else if (nextMode == 1) {
            display.setMode(&weatherMode);
        }
        nextMode = (nextMode + 1) % 2;
    }
    display.render();
    delay(15);
}
