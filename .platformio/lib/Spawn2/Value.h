#ifndef _VALUE_H_
#define _VALUE_H_

#include <stdint.h>

template <typename T>
class Value {
private:
    volatile T value;
    volatile bool modified;
    volatile int metadata;
public:
    Value(T);
    void set(T) volatile;
    void set(T, int) volatile;
    void invert(void) volatile;
    bool ack(void) volatile;
    T get(void) volatile;
    int getMetadata(void) volatile;
};
#endif
