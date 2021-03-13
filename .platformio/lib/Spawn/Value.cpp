#include "Value.h"

template <typename T>
Value<T>::Value(T initialValue) {
    this->value = initialValue;
    this->modified = false;
}

template <typename T>
void Value<T>::set(T newValue) volatile {
    this->value = newValue;
    this->metadata = 0;
    this->modified = true;
}

template <typename T>
void Value<T>::set(T newValue, int newMetadata) volatile {
    this->value = newValue;
    this->metadata = newMetadata;
    this->modified = true;
}

template <typename T>
void Value<T>::invert(void) volatile {
    this->set(!this->value);
}

template <typename T>
bool Value<T>::ack(void) volatile {
    if (this->modified) {
        this->modified = false;
        return true;
    }
    return false;
}

template <typename T>
T Value<T>::get(void) volatile {
    return this->value;
}

template <typename T>
int Value<T>::getMetadata(void) volatile {
    return this->metadata;
}

template class Value<uint8_t>;
template class Value<uint16_t>;
template class Value<uint32_t>;
template class Value<int8_t>;
template class Value<int16_t>;
template class Value<int32_t>;
template class Value<bool>;
