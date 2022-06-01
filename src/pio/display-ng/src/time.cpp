#include "time.hpp"

int64_t millis64() {
    return micros64() / 1000;
}
