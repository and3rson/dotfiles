package main

import (
	"context"
	"fmt"
	"log"
	"strings"
	"time"

	"github.com/lawl/pulseaudio"
)

type Pulse struct {
    headset bool
    volume int
}

func (d *Pulse) Run(ctx context.Context, updates chan<- Widget) {
    // TODO: Error handling
    client, err := pulseaudio.NewClient()
    if err != nil {
        log.Fatal(err)
    }
    paUpdates, err := client.Updates()
    if err != nil {
        log.Fatal(err)
    }
    for {
        // TODO: Move this out of the loop?
        server, err := client.ServerInfo()

        d.headset = strings.Contains(server.DefaultSink, "bluez")

        //if err != nil {
        //    log.Fatal(err)
        //}
        //sinks, err := client.Sinks()
        //if err != nil {
        //    log.Fatal(err)
        //}
        //for _, sink := range sinks {
        //    if sink.Name == server.DefaultSink {
        //        //
        //    }
        //}

        volume, err := client.Volume()
        if err != nil {
            log.Fatal(err)
        }
        d.volume = int(volume * 100)
        updates <- d
        select {
        case <-time.After(time.Second * 5):
            continue
        case <-ctx.Done():
            return
        case <-paUpdates:
        }
    }
}

func (d *Pulse) Content() string {
    icon := "\uF886"
    if d.headset {
        icon = "\uF7CA"
    }
    return fmt.Sprintf("<span fgcolor=\"#AF87FF\">%s %d%%</span>", icon, d.volume)
    // return fmt.Sprintf("<span fgcolor=\"#FFD787\">%s</span>", t.content)
}


