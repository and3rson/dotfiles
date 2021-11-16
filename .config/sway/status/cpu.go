package main

import (
	"context"
	"fmt"
	"time"

	"github.com/shirou/gopsutil/cpu"
)

const HistorySize = 12

type CPU struct {
    load int
    history [HistorySize]int
}

func (c *CPU) Name() string {
    return "cpu"
}

func (c *CPU) Run(ctx context.Context, updates chan<- Widget, click <-chan int) {
    for {
        loads, err := cpu.Percent(0, false)
        if err == nil {
            c.load = int(loads[0])
            for i := range c.history {
                if i < HistorySize - 1 {
                    c.history[i] = c.history[i + 1]
                } else {
                    c.history[i] = c.load
                }
            }
            // fmt.Println(c.history)
            // c.history = append(c.history, c.load)
            // c.history = c.history[int(math.Max(float64(len(c.history)) - 12, 0)):]
            updates <- c
        }
        select {
        case <-time.After(time.Second / 5.0):
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

    bar := ""
    for i := 0; i < HistorySize; i += 2 {
        load1 := int(float64(c.history[i]) / 100 * 4) + 1
        load2 := int(float64(c.history[i + 1]) / 100 * 4) + 1
        if load1 > 4 {
            load1 = 4
        }
        if load2 > 4 {
            load2 = 4
        }
        bar += GraphIcons[load1][load2]
    }

    if c.load > 70 {
        color = "#0E0105"
        urgent = true
    }
    var loadStr string
    if c.load > 99 {
        loadStr = "100"
    } else {
        loadStr = fmt.Sprintf("%2d%%", c.load)
    }
    return Repr{
        // \uf437
    	FullText:   fmt.Sprintf("%s %c %s", bar, icon, loadStr),
    	Background: "",
    	Color:      color,
        Urgent:     urgent,
    }
    // return fmt.Sprintf("<span fgcolor=\"%s\">%2d%%</span>", color, c.load)
}
