#pragma once

#include "matrix.hpp"
#include "display.hpp"

class Mode {
   public:
    virtual void mount(Display *display) = 0;
    virtual void process() = 0;
    virtual ~Mode() = default;
};
