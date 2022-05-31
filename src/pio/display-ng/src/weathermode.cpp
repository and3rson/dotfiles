#include "weathermode.hpp"
#include "WiFiClient.h"
#include "ESP8266HTTPClient.h"
#include "ArduinoJson.h"

static WiFiClient wifiClient;

WeatherMode::WeatherMode() {
    char values[5] = "--*C";
    this->temp.setText(&FONT_5x7, 2, values);
    this->suffix.setText(&FONT_5x7, 2, values + 2);
}

void WeatherMode::mount(Display *display) {
    display->addBlock(&this->icon);
    display->addBlock(&this->temp);
    display->addBlock(&this->suffix);
}

static volatile int a;

void WeatherMode::process() {
    if (lastUpdate.after(300000)) {
        HTTPClient client;
        client.begin(wifiClient, "http://api.openweathermap.org/data/2.5/weather?appid=5041ca48d55a6669fe8b41ad1a8af753&q=Lviv,Ukraine&lang=ua");
        int code = client.GET();
        if (code != 200) {
            char err[3] = "--";
            this->temp.setText(&FONT_5x7, 2, err);
        } else {
            DynamicJsonDocument doc(1024);
            String body = client.getString();
            deserializeJson(doc, body);
            double temp = ((double)doc["main"]["temp"]) - 273.15f;
            char tempStr[3];
            itoa((int)temp, tempStr, 10);
            this->temp.setText(&FONT_5x7, strlen(tempStr), tempStr);

            const char *iconCode = doc["weather"][0]["icon"];
            uint8_t iconIndex = findIcon(iconCode);
            icon.setIcon(iconIndex);
        }
    }
}

uint8_t WeatherMode::findIcon(const char *code) {
    for (uint8_t i = 0; i < ICONDEF_COUNT; i++) {
        const char *otherCode = icondefs[i].code;
        if (!strncmp(otherCode, code, strlen(otherCode))) {
            return icondefs[i].index;
        }
    }
    return 255;
}
