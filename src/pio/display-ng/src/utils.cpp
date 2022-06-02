#include "utils.hpp"

int64_t millis64() {
    return micros64() / 1000;
}

int64_t clamp(int64_t value, int64_t min, int64_t max) {
    return value < min ? min : value > max ? max : value;
}
