#pragma once

#include "matrix.hpp"
#include "display.hpp"

class Block;

class Mode {
   public:
    virtual Block** getBlocks() = 0;
    virtual void process() = 0;
    virtual ~Mode() = default;
};
