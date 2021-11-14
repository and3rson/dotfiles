package main

import (
	"context"
	"os/exec"
	"time"
)

type Time struct {
    content string
}

func (t *Time) Name() string {
    return "time"
}

func (t *Time) Run(ctx context.Context, updates chan<- Widget, click <-chan int) {
    for {
        t.content = time.Now().Format("15:03") // :05
        updates <- t
        select {
        case <-time.After(1 * time.Second):
            continue
        case <-ctx.Done():
            return
        case <-click:
            cmd := exec.Command("alacritty")
            cmd.Args = append(cmd.Args, "-e", "sh", "-c", "cal -3; read -n 1")
            cmd.Start()
        }
    }
}

func (t *Time) Content() Repr {
    return Repr{
    	FullText:   t.content,
    	Background: "",
    	Color:      "#FFD787",
    }
    // return fmt.Sprintf("<span fgcolor=\"#FFD787\">%s</span>", t.content)
}
