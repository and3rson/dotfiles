package main

import (
	"context"
	"fmt"
	"log"
	"os/exec"
	"strings"
	"time"

	"github.com/lawl/pulseaudio"
)

type Pulse struct {
    headset bool
    volume int
    err interface{}
}

func (p *Pulse) Name() string {
    return "pulse"
}

func (p *Pulse) Run(ctx context.Context, updates chan<- Widget, click <-chan int) {
    defer func() {
        if e := recover(); e != nil {
            p.err = e
            <-time.After(time.Second)
            go p.Run(ctx, updates, click)
        }
    }()
    client, err := pulseaudio.NewClient()
    if err != nil {
        panic("failed to create pulseaudio client")
    }
    paUpdates, err := client.Updates()
    if err != nil {
        panic("failed to subscribe to pulseaudio updates")
    }
    for {
        if !client.Connected() {
            panic("pulseaudio client not connected")
        }

        // TODO: Move this out of the loop?
        server, err := client.ServerInfo()

        p.headset = strings.Contains(server.DefaultSink, "bluez")

        volume, err := client.Volume()
        if err != nil {
            log.Fatal(err)
        }
        p.volume = int(volume * 100)
        p.err = nil
        updates <- p
        select {
        case <-time.After(time.Second * 5):
            continue
        case <-paUpdates:
        case <-ctx.Done():
            return
        case <-click:
            exec.Command("pavucontrol").Start()
        }
    }
}

func (d *Pulse) Content() Repr {
    if (d.err != nil) {
        return Repr{
            FullText: fmt.Sprint(d.err),
            // Color: "#FFD787",
            Urgent: true,
        }
    }
    icon := "\uF886"
    if d.headset {
        icon = "\uF7CA"
    }
    return Repr{
    	FullText:   fmt.Sprintf("%s %d%%", icon, d.volume),
    	Background: "",
    	Color:      "#AF87FF",
    }
    // return fmt.Sprintf("<span bgcolor=\"#440000\" fgcolor=\"#AF87FF\">%s %d%%</span>", icon, d.volume)
    // return fmt.Sprintf("<span fgcolor=\"#FFD787\">%s</span>", t.content)
}


