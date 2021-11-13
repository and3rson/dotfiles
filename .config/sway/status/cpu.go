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

func (c *CPU) Run(ctx context.Context, updates chan<- Widget) {
    for {
        loads, _ := cpu.Percent(0, false)
        c.load = int(loads[0])
        updates <- c
        select {
        case <-time.After(time.Second):
            continue
        case <-ctx.Done():
            return
        }
    }
}

func (c *CPU) Content() string {
    color := "#5FD7FF"
    if c.load > 50 {
        color = "#0E0105"
    }
    return fmt.Sprintf("<span fgcolor=\"%s\">%2d%%</span>", color, c.load)
}
