#include <HardwareSerial.h>
#include <ArduinoOTA.h>

#include <FastLED.h>
#include <TZ.h>

#include <Spawn.h>
#include <When.h>

#include "main.hpp"
#include "display.hpp"
#include "clockmode.hpp"
#include "weathermode.hpp"
#include "mapmode.hpp"

Spawn spawn("spawn_display_ng", false);
Display display;
When modeSwitch;
uint8_t nextMode = 0;

ClockMode clockMode;
WeatherMode weatherMode;
MapMode mapMode;

void setup() {
    spawn.setup();
    ArduinoOTA.begin();
    spawn.connect();
    for (int i = 0; i < 100; i++) {
        ArduinoOTA.handle();
        delay(10);
    }
}

When heapDebug;

void loop() {
    ArduinoOTA.handle();
    if (spawn.connect()) {
    }

    if (modeSwitch.after(nextMode == 1 ? 5000 : 2000)) {
        Serial.print("Switching mode to ");
        Serial.println(nextMode);
        if (nextMode == 0) {
            display.setMode(&clockMode);
        } else if (nextMode == 1) {
            display.setMode(&weatherMode);
        } else if (nextMode == 2) {
            display.setMode(&mapMode);
        }
        nextMode = (nextMode + 1) % 3;
    }
    display.render();
    delay(15);

    if (heapDebug.after(10000)) {
        Serial.print("Free heap: ");
        Serial.println(ESP.getFreeHeap());
        Serial.print("Free cont stack: ");
        Serial.println(ESP.getFreeContStack());
    }
}
