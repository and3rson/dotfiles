#include "utils.hpp"

int64_t millis64() {
    return micros64() / 1000;
}

int64_t clamp(int64_t value, int64_t min, int64_t max) {
    return value < min ? min : value > max ? max : value;
}

int64_t dist(int64_t a, int64_t b, int64_t m) {
    if (a > b) {
        int64_t tmp = a;
        a = b;
        b = tmp;
    }
    int64_t resA = b - a;
    int64_t resB = abs(b - m - a);
    return resA < resB ? resA : resB;
}
