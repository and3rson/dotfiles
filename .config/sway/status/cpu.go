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
        case <-click:
        }
    }
}

func (c *CPU) Content() Repr {
    color := "#5FD7FF"
    urgent := false
    if c.load > 50 {
        color = "#0E0105"
        urgent = true
    }
    return Repr{
    	FullText:   fmt.Sprintf("%2d%%", c.load),
    	Background: "",
    	Color:      color,
        Urgent:     urgent,
    }
    // return fmt.Sprintf("<span fgcolor=\"%s\">%2d%%</span>", color, c.load)
}
