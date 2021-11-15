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
    title string
    err interface{}
}

func (p *PlayerCtl) Name() string {
    return "playerctl"
}

func FetchMetadata(obj dbus.BusObject) dbus.Variant {
    // TODO: return err
    result, err := obj.GetProperty("org.mpris.MediaPlayer2.Player.Metadata")
    if err != nil {
        panic("fetch metadata: " + err.Error())
    }
    return result
}

func GetTitleFromMetadata(rawMetadata dbus.Variant) string {
    var metadata map[string]interface{}
    rawMetadata.Store(&metadata)
    parts := []string{}
    artists, ok := metadata["xesam:artist"].([]string)
    if ok && len(artists) > 0 {
        parts = append(parts, strings.Join(artists, ", "))
        // parts = append(parts, strings.Join(artistsIf.([]string), ", "))
    }
    title, ok := metadata["xesam:title"].(string)
    if ok && len(title) > 0 {
        if len(artists) > 0 {
            parts = append(parts, "-")
        }
        parts = append(parts, title)
    }
    length, ok := metadata["mpris:length"].(uint64)
    if ok {
        length = length / 1e6
        parts = append(parts, fmt.Sprintf("(%02d:%02d)", length / 60, length % 60))
    }
    if len(parts) == 0 {
        return "Not playing"
    }
    return strings.Join(parts, " ")
}

func FetchPlaybackStatus(obj dbus.BusObject) dbus.Variant {
    result, err := obj.GetProperty("org.mpris.MediaPlayer2.Player.PlaybackStatus")
    if err != nil {
        panic("fetch playback status: " + err.Error())
    }
    return result
}

func GetPlayingFromPlaybackStatus(rawPlaybackStatus dbus.Variant) bool {
    var playbackStatus string
    rawPlaybackStatus.Store(&playbackStatus)
    return playbackStatus == "Playing"
}

func (p *PlayerCtl) Run(ctx context.Context, updates chan<- Widget, click <-chan int) {
    defer func() {
        if e := recover(); e != nil {
            p.err = e
            <-time.After(time.Second)
            go p.Run(ctx, updates, click)
        }
    }()

    conn, err := dbus.ConnectSessionBus()
    if err != nil {
        panic("Failed to connect to DBus: " + err.Error())
    }
    obj := conn.Object("org.mpris.MediaPlayer2.playerctld", "/org/mpris/MediaPlayer2")
    obj.AddMatchSignal("org.freedesktop.DBus.Properties", "PropertiesChanged")

    c := make(chan *dbus.Signal, 10)
    conn.Signal(c)

    metadata := FetchMetadata(obj)
    p.title = GetTitleFromMetadata(metadata)
    playbackStatus := FetchPlaybackStatus(obj)
    p.isPlaying = GetPlayingFromPlaybackStatus(playbackStatus)
    p.err = nil
    updates <- p

    for {
        select {
        case <-time.After(5 * time.Second):
            metadata := FetchMetadata(obj)
            p.title = GetTitleFromMetadata(metadata)
            playbackStatus := FetchPlaybackStatus(obj)
            p.isPlaying = GetPlayingFromPlaybackStatus(playbackStatus)
            p.err = nil
            updates <- p
        case v := <-c:
            variants := v.Body[1]
            for name, variant := range variants.(map[string]dbus.Variant) {
                matched := false
                if name == "Metadata" {
                    title := GetTitleFromMetadata(variant)
                    if title != p.title {
                        p.title = title
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
                    updates <- p
                }
            }
            // w.content = ParseMetadata(v.Body[1].(dbus.Variant))
        case <-ctx.Done():
            return
        case <-click:
        }
    }
}

func (p *PlayerCtl) Content() Repr {
    if (p.err != nil) {
        return Repr{
            FullText: fmt.Sprint(p.err),
            Color: "#FFD787",
            Urgent: true,
        }
    }
    icon := "\uF04B"
    color := "#87D787"
    if !p.isPlaying {
        icon = "\uF04C"
        color = "#FF005F"
    }
    return Repr{
    	FullText:   fmt.Sprintf("%v %s", icon, p.title),
    	Background: "",
    	Color:      color,
    }
    // return fmt.Sprintf("<span fgcolor=\"%s\">%v %s</span>", color, icon, p.title)
}
