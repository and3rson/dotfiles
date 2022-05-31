#pragma once

#include "block.hpp"
#include "icons.hpp"

class IconBlock : public Block {
   public:
    uint8_t render(Frame *frame, uint8_t offset);
    void setIcon(uint8_t newIconIndex);

   private:
    uint8_t iconIndex = 255;
};

