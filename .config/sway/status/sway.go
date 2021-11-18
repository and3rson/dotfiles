package main

import (
	"context"
	"encoding/json"
	"os/exec"
)

func SwaySubscribe(ctx context.Context, topics []string) chan struct{} {
    changed := make(chan struct{}, 1)
    topicsStr, _ := json.Marshal(topics)
    go func() {
        exec.CommandContext(ctx, "swaymsg", "-t", "subscribe", string(topicsStr)).Output()
        changed <- struct{}{}
    }()
    return changed
}
