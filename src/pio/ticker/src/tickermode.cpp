#include <HTTPClient.h>
#include <WiFiClientSecure.h>
#include "tickermode.hpp"
#include "ArduinoJson.h"

TickerMode::TickerMode() : blocks{&this->icon, &this->count, 0} {
    this->icon.setIcon(0);
    this->count.setText(&FONT_4x6, 5, "    0");
    // this->suffix.setText(&FONT_5x7, 2, "*C");
}

Block **TickerMode::getBlocks() {
    return this->blocks;
}

void TickerMode::process() {
    if (lastUpdate.after(60000)) {
        /* if (request.readyState() == readyStateUnsent || request.readyState() == readyStateDone) */
        WiFiClientSecure client;
        client.setInsecure();
        HTTPClient https;
        // TODO: Hard-coded API key
        https.begin(client, "https://www.googleapis.com/youtube/v3/channels?part=statistics&id=UCMG7VBRuorMH-0clR1BBnZg&key=" YOUTUBE_API_KEY);
        int code = https.GET();
        DynamicJsonDocument doc(2048);
        deserializeJson(doc, https.getString());
        String subCount = doc["items"][0]["statistics"]["subscriberCount"].as<String>();
        // Pad subCount with spaces
        while (subCount.length() < 5) {
            subCount = " " + subCount;
        }
        this->count.setText(&FONT_4x6, 5, subCount.c_str());
        Serial.println(subCount);
        https.end();
    }
}
