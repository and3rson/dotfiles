#include "weathermode.hpp"
#include "WiFiClient.h"
#include "ESP8266HTTPClient.h"
#include "ArduinoJson.h"
#include "AsyncHTTPRequest_Generic.hpp"

static AsyncHTTPRequest request;

WeatherMode::WeatherMode() : blocks{&this->icon, &this->temp, &this->suffix, 0} {
    this->temp.setText(&FONT_5x7, 2, "--");
    this->suffix.setText(&FONT_5x7, 2, "*C");

    request.onReadyStateChange(WeatherMode::requestCB, this);
    request.setDebug(true);
}

Block **WeatherMode::getBlocks() {
    return this->blocks;
}

void WeatherMode::process() {
    if (lastUpdate.after(300000)) {
        /* if (request.readyState() == readyStateUnsent || request.readyState() == readyStateDone) */
        request.open("GET", "http://api.openweathermap.org/data/2.5/weather?appid=" OWM_APPID "&q=Lviv,Ukraine&lang=ua");
        request.send();
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

void WeatherMode::requestCB(void *optParm, AsyncHTTPRequest *request, int readyState) {
    WeatherMode *self = (WeatherMode *)optParm;

    if (readyState == readyStateDone) {
        if (request->responseHTTPcode() != 200) {
            self->temp.setText(&FONT_5x7, 2, "--");
        } else {
            DynamicJsonDocument doc(2048);
            char buf[1024];
            request->responseRead((uint8_t *)buf, request->responseLength());
            deserializeJson(doc, buf);
            double temp = ((double)doc["main"]["temp"]) - 273.15f;
            char tempStr[3];
            itoa((int)temp, tempStr, 10);
            self->temp.setText(&FONT_5x7, strlen(tempStr), tempStr);

            const char *iconCode = doc["weather"][0]["icon"];
            uint8_t iconIndex = self->findIcon(iconCode);
            self->icon.setIcon(iconIndex);

            Serial.print("Temp: ");
            Serial.println(tempStr);
        }
    }
}
