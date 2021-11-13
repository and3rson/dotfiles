package main

import (
	"context"
	"fmt"
	"time"
)

type Time struct {
    content string
}

func (t *Time) Run(ctx context.Context, updates chan<- Widget) {
    for {
        t.content = time.Now().Format("15:03") // :05
        updates <- t
        select {
        case <-time.After(1 * time.Second):
            continue
        case <-ctx.Done():
            return
        }
    }
}

func (t *Time) Content() string {
    return fmt.Sprintf("<span fgcolor=\"#FFD787\">%s</span>", t.content)
}
