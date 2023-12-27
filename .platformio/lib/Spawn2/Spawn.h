#include <ESP8266WiFi.h>
#include <PubSubClient.h>

#include "defaults.h"

class Spawn {
private:
    const char *deviceName;
    const char *wifiSSID;
    const unsigned char *wifiBSSID;
    const char *wifiPass;
    const char *mqttUser;
    const char *mqttPass;
    bool useMQTT;
    WiFiClient wifiClient;
public:
    PubSubClient client;
    Spawn(const char *, const bool);
    void setup();
    void setup(const char *, const unsigned char *, const char *, const char *, uint16_t, const char *, const char *);
    bool isConnected();
    bool isWiFiConnected();
    bool connect();
    void loop();
    void log(const char *, ...);
};
