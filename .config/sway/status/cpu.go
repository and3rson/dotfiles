package main

import (
	"context"
	"fmt"
	"time"

	"github.com/shirou/gopsutil/cpu"
)

type CPU struct {
    load int
}

func (c *CPU) Name() string {
    return "cpu"
}

func (c *CPU) Run(ctx context.Context, updates chan<- Widget, click <-chan int) {
    for {
        loads, err := cpu.Percent(0, false)
        if err == nil {
            c.load = int(loads[0])
            updates <- c
        }
        select {
        case <-time.After(time.Second):
            continue
        case <-ctx.Done():
            return
        }
    }
}

func (c *CPU) Content() Repr {
    color := "#5FD7FF"
    urgent := false
    // urgent = rand.Float64() < 0.5

    rel_value := int(float64(c.load) / 100 * 8)
    if rel_value > 7 {
        rel_value = 7
    }
    icon := rune(0x2581 + rel_value)

    if c.load > 50 {
        color = "#0E0105"
        urgent = true
    }
    return Repr{
        // \uf437
    	FullText:   fmt.Sprintf("%c %2d%%", icon, c.load),
    	Background: "",
    	Color:      color,
        Urgent:     urgent,
    }
    // return fmt.Sprintf("<span fgcolor=\"%s\">%2d%%</span>", color, c.load)
}
