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
	headset     bool
	volume      int
	sourceMuted bool
	err         interface{}
}

func (p *Pulse) Name() string {
	return "pulse"
}

func (p *Pulse) Run(ctx context.Context, updates chan<- bool) {
	defer func() {
		if e := recover(); e != nil {
			p.err = e
			<-time.After(time.Second)
			go p.Run(ctx, updates)
		}
	}()
	client, err := pulseaudio.NewClient()
	defer client.Close()
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

		sources, err := client.Sources()
		if err != nil {
			log.Fatal(err)
		}
		for _, source := range sources {
			if source.Name == server.DefaultSource {
				p.sourceMuted = source.Muted
			}
		}

		updates <- true
		select {
		case <-time.After(time.Second * 5):
			continue
		case <-paUpdates:
		case <-ctx.Done():
			return
			// case <-click:
			//     exec.Command("pavucontrol").Start()
		}
	}
}

func main() {
	p := &Pulse{}
	context, cancel := context.WithCancel(context.Background())
	updates := make(chan bool)
	go p.Run(context, updates)
	for {
		select {
		case <-updates:
			fmt.Printf("headset|bool|%v\n", p.headset)
			fmt.Printf("volume|int|%d\n", p.volume)
			fmt.Printf("source_muted|bool|%v\n", p.sourceMuted)
			fmt.Println()
		}
	}
	cancel()
}

// func (d *Pulse) Content() Repr {
//     if (d.err != nil) {
//         return Repr{
//             FullText: fmt.Sprint(d.err),
//             // Color: "#FFD787",
//             Urgent: true,
//         }
//     }
//     icon := "\uF886"
//     if d.headset {
//         icon = "\uF7CA"
//     }
//     return Repr{
// 		FullText:   fmt.Sprintf("%s %d%%", icon, d.volume),
// 		Background: "",
// 		Color:      "#AF87FF",
//     }
//     // return fmt.Sprintf("<span bgcolor=\"#440000\" fgcolor=\"#AF87FF\">%s %d%%</span>", icon, d.volume)
//     // return fmt.Sprintf("<span fgcolor=\"#FFD787\">%s</span>", t.content)
// }
