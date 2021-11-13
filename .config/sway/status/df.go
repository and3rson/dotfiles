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

func (d *DF) Run(ctx context.Context, updates chan<- Widget) {
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
        }
    }
}

func (d *DF) Content() string {
    color := "#FFD787"
    if d.free < 10 {
        color = "#FF005F"
    }
    return fmt.Sprintf("<span fgcolor=\"%s\">\uF7C9 %2dG</span>", color, d.free)
    // return fmt.Sprintf("<span fgcolor=\"#FFD787\">%s</span>", t.content)
}

