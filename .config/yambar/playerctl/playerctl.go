package main

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/godbus/dbus/v5"
)

type PlayerCtl struct {
    isPlaying bool
    info Info
    err interface{}
}

type Info struct {
    title string
    duration string
}

func (p *PlayerCtl) Name() string {
    return "playerctl"
}

func FetchMetadata(obj dbus.BusObject) (bool, dbus.Variant) {
    // TODO: return err
    result, err := obj.GetProperty("org.mpris.MediaPlayer2.Player.Metadata")
    if err != nil {
		if err, ok := err.(dbus.Error); ok {
			parts := strings.Split(err.Name, ".")
			if parts[len(parts)-1] == "NoActivePlayer" {
				return false, dbus.Variant{}
			}
		} else {
			panic("failed to fetch metadata: " + err.Error())
		}
    }
    return true, result
}

func GetInfoFromMetadata(rawMetadata dbus.Variant) Info {
    var metadata map[string]interface{}
    var result Info
    rawMetadata.Store(&metadata)
    artists, ok := metadata["xesam:artist"].([]string)
    if ok && len(artists) > 0 {
        result.title = strings.Join(artists, ", ")
        // parts = append(parts, strings.Join(artistsIf.([]string), ", "))
    }
    title, ok := metadata["xesam:title"].(string)
    if ok && len(title) > 0 {
        if len(result.title) > 0 {
            result.title += " - "
        }
        result.title += title
    }
    length, ok := metadata["mpris:length"].(uint64)
    result.duration = "(00:00)"
    if ok {
        length = length / 1e6
        result.duration = fmt.Sprintf("(%02d:%02d)", length / 60, length % 60)
    }
    return result
}

func FetchPlaybackStatus(obj dbus.BusObject) dbus.Variant {
    result, err := obj.GetProperty("org.mpris.MediaPlayer2.Player.PlaybackStatus")
    if err != nil {
        panic("failed to fetch playback status")
    }
    return result
}

func GetPlayingFromPlaybackStatus(rawPlaybackStatus dbus.Variant) bool {
    var playbackStatus string
    rawPlaybackStatus.Store(&playbackStatus)
    return playbackStatus == "Playing"
}

func ellipsize(s string) string {
    runes := []rune(s)
    if len(runes) > 48 {
        runes = append(runes[:48], rune('\u2026'))
    }
    return string(runes)
}

func (p *PlayerCtl) update(obj dbus.BusObject) {
    controlled, metadata := FetchMetadata(obj)
	if controlled {
		p.info = GetInfoFromMetadata(metadata)
		playbackStatus := FetchPlaybackStatus(obj)
		p.isPlaying = GetPlayingFromPlaybackStatus(playbackStatus)
	} else {
		p.info = Info{
			title:    "No players",
			duration: "",
		}
		p.isPlaying = false
	}
	p.err = nil
}

func (p *PlayerCtl) Run(ctx context.Context, updates chan<- bool) {
    defer func() {
        if e := recover(); e != nil {
            p.err = e
            <-time.After(time.Second)
            go p.Run(ctx, updates)
        }
    }()

    conn, err := dbus.ConnectSessionBus()
    if err != nil {
        panic("failed to connect to DBus")
    }
    obj := conn.Object("org.mpris.MediaPlayer2.playerctld", "/org/mpris/MediaPlayer2")
    obj.AddMatchSignal("org.freedesktop.DBus.Properties", "PropertiesChanged")

    c := make(chan *dbus.Signal, 10)
    conn.Signal(c)

    p.update(obj)
    updates <- true

    for {
        select {
        case <-time.After(5 * time.Second):
            p.update(obj)
            updates <- true
        case v := <-c:
            variants := v.Body[1]
            for name, variant := range variants.(map[string]dbus.Variant) {
                matched := false
                if name == "Metadata" {
                    info := GetInfoFromMetadata(variant)
                    if info != p.info {
                        p.info = info
                        matched = true
                    }
                } else if name == "PlaybackStatus" {
                    isPlaying := GetPlayingFromPlaybackStatus(variant)
                    if isPlaying != p.isPlaying {
                        p.isPlaying = isPlaying
                        matched = true
                    }
                }
                if matched {
                    p.err = nil
                    updates <- true
                }
            }
            // w.content = ParseMetadata(v.Body[1].(dbus.Variant))
        case <-ctx.Done():
            return
        }
    }
}

func main() {
	p := &PlayerCtl{}
	context, cancel := context.WithCancel(context.Background())
	updates := make(chan bool)
	go p.Run(context, updates)
	for {
		select {
		case <-updates:
			fmt.Printf("playing|bool|%v\n", p.isPlaying)
			fmt.Printf("title|string|%s\n", ellipsize(p.info.title))
			fmt.Printf("duration|string|%s\n", p.info.duration)
			fmt.Println()
		}
	}
	cancel()
}

// func (p *PlayerCtl) Content() Repr {
//     if (p.err != nil) {
//         return Repr{
//             FullText: fmt.Sprint(p.err),
//             Color: "#FFD787",
//             Urgent: true,
//         }
//     }
//     icon := "\uF04B"
//     color := "#87D787"
//     if !p.isPlaying {
//         icon = "\uF04C"
//         color = "#FF005F"
//     }
//     return Repr{
// 		FullText:   fmt.Sprintf("%v %s %s", icon, ellipsize(p.info.title), p.info.duration),
// 		Background: "",
// 		Color:      color,
//         // MinWidth:   150,
//         // Align:      "left",
//     }
//     // return fmt.Sprintf("<span fgcolor=\"%s\">%v %s</span>", color, icon, p.title)
// }
