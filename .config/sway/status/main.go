package main

import (
	"context"
	"fmt"
	"strings"
)

var Sep = " <span fgcolor=\"#666666\">\u2502</span> "

func main() {
    widgets := []Widget{&PlayerCtl{}, &DF{}, &CPU{}, &NetworkManager{}, &Pulse{}, &Time{}}

    updates := make(chan Widget)
    ctx, cancel := context.WithCancel(context.Background())
    for _, widget := range widgets {
        go widget.Run(ctx, updates)
    }

    for {
        select {
        case _ = <-updates:
            outputs := []string{}
            for _, widget := range widgets {
                outputs = append(outputs, widget.Content())
            }
            fmt.Println(strings.Join(outputs, Sep))
        }
    }
    cancel()
}
