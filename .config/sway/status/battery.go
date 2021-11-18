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
        select {
        case <-time.After(time.Second * 1):
            continue
        case <-ctx.Done():
            return
        }
    }
}

func (d *Battery) Content() Repr {
    color := "#FFFFFF"
    urgent := false
    icon := "\u2665" // heart
    if d.status == "Charging" || d.status == "Full" || d.status == "Not charging" {
        color = "#AFFF00"
        icon = "\uF0E7" // bolt
    } else if d.charge < 20 {
        urgent = true
    }
    return Repr{
		FullText:   fmt.Sprintf("%s %d%%", icon, d.charge),
		Background: "",
		Color:      color,
        Urgent:     urgent,
    }
    // return fmt.Sprintf("<span fgcolor=\"%s\">\uF7C9 %2dG</span>", color, d.free)
    // return fmt.Sprintf("<span fgcolor=\"#FFD787\">%s</span>", t.content)
}

