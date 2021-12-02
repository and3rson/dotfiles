package main

import (
	"context"
	"encoding/json"
	// "fmt"
	"os/exec"
)

func SwaySubscribe(ctx context.Context, topics []string) chan struct{} {
    changed := make(chan struct{}, 1)
    topicsStr, _ := json.Marshal(topics)
    go func() {
		cmd := exec.CommandContext(ctx, "swaymsg", "-t", "subscribe", string(topicsStr))
		_, err := cmd.Output()
		if err != nil {
			// panic(fmt.Errorf("sway subscribe error: %s", err))
		} else {
			changed <- struct{}{}
		}
    }()
    return changed
}
