#include "WiFiClient.h"
#include "ESP8266HTTPClient.h"
#include "ArduinoJson.h"

#include "mapmode.hpp"

static AsyncHTTPRequest request;

uint8_t mapData[] = {
    0,  2,  2,  16, 0,  0,  24, 17, 0,  0,  0,  0,

    0,  2,  2,  16, 5,  9,  24, 17, 17, 0,  0,  0,

    12, 12, 18, 21, 5,  25, 22, 15, 19, 19, 11, 11,

    6,  8,  18, 21, 1,  22, 10, 15, 3,  19, 4,  11,

    0,  6,  23, 0,  14, 14, 10, 3,  3,  7,  4,  0,

    0,  0,  0,  0,  0,  14, 13, 20, 7,  7,  0,  0,

    0,  0,  0,  0,  14, 14, 0,  20, 0,  0,  0,  0,

    0,  0,  0,  0,  0,  0,  0,  99, 99, 0,  0,  0,
};

MapMode::MapMode() : blocks{&this->map, 0} {
    this->map.setWidth(12);
    this->map.setExtraOffset(12);
    this->map.setTemplate(mapData);
    for (int i = 1; i <= 25; i++) {
        this->map.setColor(i, CHSV(96, 255, 128));
    }
    this->map.setColor(99, CHSV(64, 128, 64));

    request.onReadyStateChange(MapMode::requestCB, this);
    request.setDebug(true);
}

Block **MapMode::getBlocks() {
    return this->blocks;
}

void MapMode::process() {
    /* Serial.setDebugOutput(true); */
    if (lastUpdate.after(5000)) {
        /* if (request.readyState() == readyStateUnsent || request.readyState() == readyStateDone) */
        request.setDebug(true);
        if (!request.open("GET", "http://alerts.com.ua/api/states?short")) {
            Serial.println("Failed to open request");
            return;
        }
        request.setReqHeader("X-API-Key", "11235813araa");
        if (!request.send()) {
            Serial.println("Failed to send request");
            return;
        }
    }
}

void MapMode::requestCB(void *optParm, AsyncHTTPRequest *request, int readyState) {
    MapMode *self = (MapMode *)optParm;

    if (readyState == readyStateDone) {
        if (request->responseHTTPcode() != 200) {
            Serial.print("HTTP ");
            Serial.println(request->responseHTTPcode());
            Serial.println(request->responseText());
        } else {
            DynamicJsonDocument doc(2048);
            Serial.println("HTTP 200 OK!");
            char buf[1024];
            request->responseRead((uint8_t *)buf, request->responseLength());
            deserializeJson(doc, buf);
            Serial.println(buf);
            JsonArray states = doc["states"].as<JsonArray>();
            for (JsonArray::iterator it = states.begin(); it != states.end(); ++it) {
                JsonObject state = it->as<JsonObject>();
                uint8_t id = state["id"];
                bool alert = state["alert"];
                Serial.printf("%d %d\r\n", id, alert);
                self->map.setColor(id, alert ? CHSV(16, 255, 128) : CHSV(96, 255, 128));
            }
        }
    }
}
