#include "Spawn.h"
#include <stdarg.h>

int lastReconnect = 0;

Spawn::Spawn(const char *deviceName, const bool useMQTT) {
    this->deviceName = deviceName;
    this->client = PubSubClient(this->wifiClient);
    this->useMQTT = useMQTT;
}

void Spawn::setup() {
    setup(
            SPAWN_WIFI_SSID, SPAWN_WIFI_BSSID, SPAWN_WIFI_PASS, SPAWN_MQTT_SERVER,
            SPAWN_MQTT_PORT, SPAWN_MQTT_USER, SPAWN_MQTT_PASS
    );
}

void Spawn::setup(
        const char *wifiSSID, const unsigned char *wifiBSSID, const char *wifiPass,
        const char *mqttServer, uint16_t mqttPort,
        const char *mqttUser, const char *mqttPass
) {
    Serial.begin(115200, SERIAL_8N1, SERIAL_TX_ONLY);
    //Serial.begin(115200);

    this->wifiSSID = wifiSSID;
    this->wifiBSSID = wifiBSSID;
    this->wifiPass = wifiPass;
    this->mqttUser = mqttUser;
    this->mqttPass = mqttPass;

    if (this->useMQTT) {
        this->client.setServer(mqttServer, mqttPort);
        this->client.setBufferSize(1024);
    }
}

bool Spawn::isConnected() {
    return this->isWiFiConnected() && (!this->useMQTT || this->client.connected());
}

bool Spawn::isWiFiConnected() {
    return WiFi.status() == WL_CONNECTED;
}

bool Spawn::connect() {
    // Return true if managed to connect, false if failed
    int attempts = 3;
    while (!this->isConnected()) {
        if (!attempts--) {
            return false;
        }
        if (!this->isWiFiConnected()) {
            Serial.println("WiFi not connected, initializing connect sequence...");
            wifi_station_set_hostname(this->deviceName);
            WiFi.hostname(this->deviceName);
            WiFi.begin(this->wifiSSID, this->wifiPass, 0, this->wifiBSSID, true);
            Serial.print("Connecting to WiFi");
            int wifiTimeout = 20; // 5 seconds
            while (!this->isWiFiConnected() && wifiTimeout--) {
                Serial.print(".");
                delay(250);
            }
            if (this->isWiFiConnected()) {
                Serial.println(" Connected!");
            } else {
                Serial.println(" Failed to connect to WiFi!");
                continue; // Restart loop since it makes no sense to proceed to MQTT connection
            }
        }
        if (this->useMQTT) {
            if (!this->client.connected()) {
                Serial.println("MQTT not connected, initializing connect sequence...");
                char willTopic[64];
                sprintf(willTopic, "devices/%s", this->deviceName);
                if (this->client.connect(this->deviceName, this->mqttUser, this->mqttPass, willTopic, 0, true, "OFFLINE", true)) {
                    Serial.println("Connected to MQTT!");
                    this->client.publish(willTopic, "ON AIR", true);
                } else {
                    Serial.print("MQTT failed with state ");
                    Serial.println(this->client.state());
                }
            }
        } else {
            Serial.println("MQTT disabled.");
        }
    }

    return true;
}

void Spawn::loop() {
    if (this->useMQTT) {
        this->client.loop();
    }
}

void Spawn::log(const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    int len = vsnprintf(NULL, 0, fmt, args);
    char message[len];
    vsprintf(message, fmt, args);
    va_end(args);

    char channel[64];
    sprintf(channel, "logs/%s", this->deviceName);
    Serial.print("[LOG] ");
    Serial.println(message);
    if (this->useMQTT) {
        this->client.publish(channel, message);
    }
}
