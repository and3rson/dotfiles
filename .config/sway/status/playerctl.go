package main

import (
    "context"
    "fmt"
    "log"
    "strings"
    "time"

    "github.com/godbus/dbus/v5"
)

type PlayerCtl struct {
    isPlaying bool
    title string
}

func FetchMetadata(obj dbus.BusObject) dbus.Variant {
    // TODO: return err
    result, err := obj.GetProperty("org.mpris.MediaPlayer2.Player.Metadata")
    if err != nil {
        log.Fatal("Failed to fetch metadata")
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
        log.Fatal("Failed to fetch playback status")
    }
    return result
}

func GetPlayingFromPlaybackStatus(rawPlaybackStatus dbus.Variant) bool {
    var playbackStatus string
    rawPlaybackStatus.Store(&playbackStatus)
    return playbackStatus == "Playing"
}

func (w *PlayerCtl) Run(ctx context.Context, updates chan<- Widget) {
    conn, err := dbus.ConnectSessionBus()
    if err != nil {
        log.Fatal("Failed to connect to DBus")
    }
    obj := conn.Object("org.mpris.MediaPlayer2.playerctld", "/org/mpris/MediaPlayer2")
    obj.AddMatchSignal("org.freedesktop.DBus.Properties", "PropertiesChanged")

    c := make(chan *dbus.Signal, 10)
    conn.Signal(c)

    metadata := FetchMetadata(obj)
    w.title = GetTitleFromMetadata(metadata)
    playbackStatus := FetchPlaybackStatus(obj)
    w.isPlaying = GetPlayingFromPlaybackStatus(playbackStatus)
    updates <- w

    for {
        select {
        case <-time.After(5 * time.Second):
            metadata := FetchMetadata(obj)
            w.title = GetTitleFromMetadata(metadata)
            playbackStatus := FetchPlaybackStatus(obj)
            w.isPlaying = GetPlayingFromPlaybackStatus(playbackStatus)
            updates <- w
        case <-ctx.Done():
            return
        case v := <-c:
            variants := v.Body[1]
            for name, variant := range variants.(map[string]dbus.Variant) {
                matched := false
                if name == "Metadata" {
                    title := GetTitleFromMetadata(variant)
                    if title != w.title {
                        w.title = title
                        matched = true
                    }
                } else if name == "PlaybackStatus" {
                    isPlaying := GetPlayingFromPlaybackStatus(variant)
                    if isPlaying != w.isPlaying {
                        w.isPlaying = isPlaying
                        matched = true
                    }
                }
                if matched {
                    updates <- w
                }
            }
            // w.content = ParseMetadata(v.Body[1].(dbus.Variant))
        }
    }
}

func (w *PlayerCtl) Content() string {
    icon := "\uF04B"
    color := "#FFD787"
    if !w.isPlaying {
        icon = "\uF04C"
        color = "#FF005F"
    }
    return fmt.Sprintf("<span fgcolor=\"%s\">%v %s</span>", color, icon, w.title)
}
