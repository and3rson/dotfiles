#include "When.h"

When::When() {
    this->time = 0;
    this->initial = true;
}

When::When(uint32_t initialTime) {
    this->time = initialTime;
    this->initial = false;
}

bool When::after(uint32_t delta) volatile {
    uint32_t now = millis();
    if (this->initial || (now - this->time) > delta) {
        this->time = now;
        this->initial = false;
        return true;
    }
    return false;
}
