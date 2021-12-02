package main

import (
	"bufio"
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"os"
	"strings"
	"time"
)

// var Sep = " <span fgcolor=\"#666666\">\u2502</span> "
var Sep = Repr{
	FullText:   " \u2502 ",
	Background: "",
	Color:      "#666666",
}

func read(r io.Reader) <-chan string {
    lines := make(chan string)
    go func() {
        defer close(lines)
        scan := bufio.NewScanner(r)
        for scan.Scan() {
            lines <- scan.Text()
        }
    }()
    return lines
}

func main() {
    widgets := []Widget{&Clients{}, &PlayerCtl{}, &Spectrum{}, &OpenWeatherMap{}, &DF{}, &Pulse{}, &Keyboard{}, &CPU{}, &NetworkManager{}, &Time{}, &Battery{}}
	var renderer Renderer = &JSONRenderer{}

    updates := make(chan Widget)
    clicks := map[string]chan int{}
    ctx, cancel := context.WithCancel(context.Background())
    for _, widget := range widgets {
        click := make(chan int, 1)
        clicks[widget.Name()] = click
        go widget.Run(ctx, updates, click)
    }

    plainFlag := flag.Bool("plain", false, "Print plain text")
    flag.Parse()

    if *plainFlag {
		renderer = &PlainRenderer{}
	}

    stdin := read(os.Stdin)

	renderer.Start()

    for {
        select {
		case <-updates:
			renderer.BeginRow()
			for _, widget := range widgets {
				r := widget.Content()
                r.Name = widget.Name()
                r.Instance = widget.Name()
                if r.Urgent {
                    r.Urgent = false
                    r.Background, r.Color = "#AF002F", "#FFFFFF"
                }
				renderer.Render(r)
			}
			renderer.EndRow()
            // if !plain {
            //     fmt.Print(",[")
            // }
            // for _, widget := range widgets {
            //     if !first {
            //         if !plain {
            //             fmt.Print(",")
            //         } else {
            //             fmt.Print("|")
            //         }
            //     }
            //     r := widget.Content()
            //     r.Name = widget.Name()
            //     r.Instance = widget.Name()
            //     r.Markup = "pango"

            //     if r.Urgent {
            //         r.Urgent = false
            //         r.Background, r.Color = "#AF002F", "#FFFFFF"
            //     }
            //     // r.Background, r.Color = r.Color, "#222222"
            //     if len(r.FullText) > 0 {
            //         r.FullText = " " + r.FullText + " "
            //     }
            //     if !plain {
            //         fmt.Print(r.Serialize())
            //     } else {
            //         fmt.Print(r.FullText)
            //     }
            //     first = false
            // }
        case line := <-stdin:
            if line == "[" {
                continue
            }
            line = strings.Trim(line, ",")
            e := InputEvent{}
            _ = json.Unmarshal([]byte(line), &e)
            click, ok := clicks[e.Name]
            if ok {
                select {
                case click <- e.Button:
                default:
                    // fmt.Println(",[{\"full_text\":\"Click ignored\"}]")
                    // Click not being consumed
                    <-time.After(time.Second / 4.0)
                }
            }
            // fmt.Printf(",[{\"full_text\":\"%s\"}]\n", strings.Replace(line, "\"", "~", -1))
        }
    }
    fmt.Print("]")
    cancel()
}
