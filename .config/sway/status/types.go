package main

import (
	"context"
	"encoding/json"
)

type Repr struct {
    Name string `json:"name"`
    Instance string `json:"instance"`
    FullText string `json:"full_text"`
    Background string `json:"background"`
    Color string `json:"color"`
	Markup string `json:"markup"`
    Urgent bool `json:"urgent"`
    MinWidth int `json:"min_width,omitempty"`
    Align string `json:"align,omitempty"`
	Separator bool `json:"separator"`
}

func (r Repr) Serialize() string {
	r.Markup = "pango"
    b, err := json.Marshal(r)
    if err != nil {
        return "serialization failed: " + err.Error()
    }
    return string(b)
}

type InputEvent struct {
    Name string `json:"name"`
    Instance string `json:"instance"`
    Button int `json:"button"`
}

type Widget interface {
    Name() string
    Run(ctx context.Context, updates chan<- Widget, click <-chan int)
    Content() Repr
}
