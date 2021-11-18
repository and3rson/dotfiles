package main

import (
	"context"
	"encoding/json"
	"os/exec"
	"time"
)

type Input struct {
    Identifier string `json:"identifier"`
    ActiveLayoutName string `json:"xkb_active_layout_name"`
}

func getInputs() []Input {
    inputsRaw, _ := exec.Command("swaymsg", "-t", "get_inputs", "-r").Output()
    var inputs []Input
    _ = json.Unmarshal(inputsRaw, &inputs)
    for index, input := range inputs {
        if input.ActiveLayoutName == "Ukrainian" {
            inputs[index].ActiveLayoutName = "Українська"
        }
    }
    return inputs
}

func getActiveLayoutName(inputs []Input) string {
    for _, input := range inputs {
        if input.ActiveLayoutName != "" {
            return input.ActiveLayoutName
        }
    }
    return "Unknown"
}

type Keyboard struct {
    layout string
}

func (k *Keyboard) Name() string {
    return "clients"
}

func (k *Keyboard) Run(ctx context.Context, updates chan<- Widget, click <-chan int) {
    k.layout = getActiveLayoutName(getInputs())
    changed := SwaySubscribe(ctx, []string{"input"})
    for {
        select {
        case <-time.After(time.Second * 10):
            continue
        case <-ctx.Done():
            return
        case <-changed:
            k.layout = getActiveLayoutName(getInputs())
            updates <- k
            changed = SwaySubscribe(ctx, []string{"input"})
        }
    }
}

func (k *Keyboard) Content() Repr {
    return Repr{
		FullText:   k.layout,
		// Background: "",
        // MinWidth: 150,
        Align: "left",
        // Background: "#448844",
		Color:      "#AF87FF",
    }
    // return fmt.Sprintf("<span fgcolor=\"%s\">\uF7C9 %2dG</span>", color, d.free)
    // return fmt.Sprintf("<span fgcolor=\"#FFD787\">%s</span>", t.content)
}


