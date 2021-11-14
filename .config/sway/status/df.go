package main

import (
	"context"
	"fmt"
	"time"

	"golang.org/x/sys/unix"
)

type DF struct {
    free uint64
}

func (d *DF) Name() string {
    return "df"
}

func (d *DF) Run(ctx context.Context, updates chan<- Widget, click <-chan int) {
    for {
        var stat unix.Statfs_t
        // wd, _ := os.Getwd()
        unix.Statfs("/", &stat)
        d.free = stat.Bavail * uint64(stat.Bsize) / 1000000000

        select {
        case <-time.After(time.Second * 10):
            continue
        case <-ctx.Done():
            return
        case <-click:
        }
    }
}

func (d *DF) Content() Repr {
    color := "#FFD787"
    urgent := false
    if d.free < 10 {
        color = "#FF005F"
        urgent = true
    }
    return Repr{
    	FullText:   fmt.Sprintf("\uF7C9 %2dG", d.free),
    	Background: "",
    	Color:      color,
        Urgent:     urgent,
    }
    // return fmt.Sprintf("<span fgcolor=\"%s\">\uF7C9 %2dG</span>", color, d.free)
    // return fmt.Sprintf("<span fgcolor=\"#FFD787\">%s</span>", t.content)
}

