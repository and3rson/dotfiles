#pragma once

#include "block.hpp"

class ImageBlock : public Block {
   public:
    uint8_t render(Frame *frame, uint8_t offset);
    void setExtraOffset(uint8_t newExtraOffset);
    void setTemplate(uint8_t *newTpl);
    void setWidth(uint8_t newWidth);
    void setColor(uint8_t id, CHSV color);

   private:
    uint8_t *tpl;
    uint8_t extraOffset;
    uint8_t width = 8;
    CHSV colors[255];
};

