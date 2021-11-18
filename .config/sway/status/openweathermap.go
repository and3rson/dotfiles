package main

import (
	"context"
	"fmt"
	"strings"
	"time"
	"unicode/utf8"

	"github.com/briandowns/openweathermap"
)

type OpenWeatherMap struct {
    icon string
    content string
    err interface{}
}

func (o *OpenWeatherMap) Name() string {
    return "openweathermap"
}

func (o *OpenWeatherMap) Run(ctx context.Context, updates chan<- Widget, click <-chan int) {
    defer func() {
        if e := recover(); e != nil {
            o.err = e
            <-time.After(time.Second)
            go o.Run(ctx, updates, click)
        }
    }()
    for {
        if o.content == "" {
            o.content = "..."
        } else {
            o.content = strings.Repeat(".",  utf8.RuneCountInString(o.content))
        }
        o.err = nil
        updates <- o
        w, err := openweathermap.NewCurrent("C", "UA", "5041ca48d55a6669fe8b41ad1a8af753") // Be a nice boi, don't abuse this ;)
        if err != nil {
            panic("failed to init weather")
        }
        err = w.CurrentByName("Lviv,Ukraine")
        if err != nil {
            panic("failed to retrieve weather")
        }
        // mmhg := int(w.Main.Pressure / 1.33322387415)
        temp := int(w.Main.Temp)
        temp_feel := int(w.Main.FeelsLike)
        humidity := int(w.Main.Humidity)
        parts := []string{}
        weather_id := 0
        icons := ""
        for _, weather := range w.Weather {
            // parts = append(parts, weather.Description)
            weather_id = weather.ID
            icons += string(rune(60000 + weather_id))
        }
        o.icon = icons
        temp_full := fmt.Sprintf("%d\u00b0", temp)
        if temp_feel != temp {
            // temp_full += " " + fmt.Sprintf("<span size=\"8000\" rise=\"0\">(%d\u00b0)</span>", temp_feel)
            temp_full += " " + fmt.Sprintf("(%d\u00b0)", temp_feel)
        }
        parts = append(parts, temp_full)
        // parts = append(parts, fmt.Sprintf("%d<span size=\"8000\" rise=\"0\">%% RH</span>", humidity))
        parts = append(parts, fmt.Sprintf("%d%% RH", humidity))
        // parts = append(parts, fmt.Sprintf("%dmm", mmhg))
        o.content = strings.Join(parts, ", ")
        o.err = nil
        updates <- o
        select {
        case <-time.After(60 * time.Second):
            continue
        case <-ctx.Done():
            return
        case <-click:
        }
    }
}

func (o *OpenWeatherMap) Content() Repr {
    if (o.err != nil) {
        return Repr{
            FullText: fmt.Sprint(o.err),
            // Color: "#FFD787",
            Urgent: true,
        }
    }
    return Repr{
		FullText:   fmt.Sprintf("<span font_desc=\"owfont\" rise=\"-2000\">%s</span><span> %s</span>", o.icon, o.content),
		Background: "",
		// Color:      "#FFD787",
		Color:      "#FFD787",
    }
    // return fmt.Sprintf("<span fgcolor=\"#FFD787\">%s</span>", t.content)
}

