#include <HardwareSerial.h>
#include <ArduinoOTA.h>

// #include <FastLED.h>
// #include <TZ.h>

#include "credentials.h"
#include <Spawn.h>
#include <When.h>

#include "main.hpp"
#include "display.hpp"
#include "tickermode.hpp"
#include "clockmode.hpp"

#include <Adafruit_NeoPixel.h>

Spawn spawn("office_ticker", false);
Display display;
When modeSwitch;

TickerMode tickerMode;
ClockMode clockMode;

uint8_t modeIndex;

// Frame tmp;

void setup() {
    Serial.begin(115200);
    Serial.println("spawn.setup()");
    spawn.setup(OFFICE_WIFI_SSID, OFFICE_WIFI_BSSID);
    Serial.println("ArduinoOTA.begin()");
    // ArduinoOTA.begin();
    Serial.println("spawn.connect()");
    spawn.connect();
    for (int i = 0; i < 100; i++) {
        ArduinoOTA.handle();
        delay(10);
    }
    modeIndex = 0;
    display.setMode(&tickerMode);
    // pixels.begin();
    // FastLED.addLeds<NEOPIXEL, LED_PIN>(tmp.leds, 32);
}

When heapDebug;

void loop() {
    // FastLED.setBrightness(8);
    // pixels.clear();
    // for (int i = 0; i < 10; i++) {
    //     pixels.setPixelColor(i, pixels.Color(255, 0, 0));
    //     // tmp.leds[i] = CRGB::Red;
    // }
    // pixels.show();
    // // FastLED.show();
    // delay(2500);
    // ArduinoOTA.handle();
    if (spawn.connect()) {
    }

    if (modeSwitch.after(5000)) {
        Serial.print("Switching mode to ");
        Serial.println(modeIndex);
        modeIndex = (modeIndex + 1) % 2;
        if (modeIndex == 0) {
            display.setMode(&tickerMode);
        } else {
            display.setMode(&clockMode);
        }
    }
    display.render();
    delay(25);

    // if (heapDebug.after(10000)) {
    //     Serial.print("Free heap: ");
    //     Serial.println(ESP.getFreeHeap());
    //     Serial.print("Free cont stack: ");
    //     Serial.println(ESP.getFreeContStack());
    // }
}
