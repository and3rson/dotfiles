package main

import (
	"context"
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"
)

type Battery struct {
    status string
    charge int
	blink bool
}

func (b *Battery) Name() string {
    return "battery"
}

func (b *Battery) Run(ctx context.Context, updates chan<- Widget, click <-chan int) {
    for {
        statusBytes, statusErr := os.ReadFile("/sys/class/power_supply/BAT0/status")
        chargeBytes, bytesErr := os.ReadFile("/sys/class/power_supply/BAT0/capacity")
        if statusErr != nil || bytesErr != nil {
            b.status = "Unknown"
            b.charge = 0
        } else {
            b.status = strings.TrimSpace(string(statusBytes))
            chargeInt, _ := strconv.Atoi(strings.TrimSpace(string(chargeBytes)))
            b.charge = chargeInt
        }
		timeout := time.Second
		if b.status != "Charging" && b.charge < 20 {
			b.blink = !b.blink
			timeout = time.Second / 5
		}
        select {
        case <-time.After(timeout):
            continue
        case <-ctx.Done():
            return
        }
    }
}

func (b *Battery) Content() Repr {
    color := "#FFFFFF"
    urgent := false
    icon := "\u2665" // heart
    if b.status == "Charging" || b.status == "Full" || b.status == "Not charging" {
        color = "#AFFF00"
        icon = "\uF0E7" // bolt
    } else if b.charge < 20 {
        urgent = true
    }
	if urgent {
		urgent = b.blink
	}
    return Repr{
		FullText:   fmt.Sprintf("%s %d%%", icon, b.charge),
		Background: "",
		Color:      color,
        Urgent:     urgent,
    }
    // return fmt.Sprintf("<span fgcolor=\"%s\">\uF7C9 %2dG</span>", color, d.free)
    // return fmt.Sprintf("<span fgcolor=\"#FFD787\">%s</span>", t.content)
}

