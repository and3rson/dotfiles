#pragma once

#include "matrix.hpp"

class Block {
   public:
    virtual uint8_t render(Frame *frame, uint8_t offset) = 0;
    virtual ~Block() = default;
};
