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
    widgets := []Widget{&PlayerCtl{}, &OpenWeatherMap{}, &DF{}, &CPU{}, &NetworkManager{}, &Pulse{}, &Time{}}

    updates := make(chan Widget)
    clicks := map[string]chan int{}
    ctx, cancel := context.WithCancel(context.Background())
    for _, widget := range widgets {
        click := make(chan int, 10)
        clicks[widget.Name()] = click
        go widget.Run(ctx, updates, click)
    }

    plainFlag := flag.Bool("plain", false, "Print plain text")
    flag.Parse()

    plain := *plainFlag

    stdin := read(os.Stdin)

    if !plain {
        fmt.Println("{\"version\": 1, \"click_events\": true}")
        fmt.Print("[")
        fmt.Print("[]")
    }

    for {
        select {
        case _ = <-updates:
            first := true
            if !plain {
                fmt.Print(",[")
            }
            for _, widget := range widgets {
                if !first {
                    if !plain {
                        fmt.Print(",")
                    } else {
                        fmt.Print("|")
                    }
                }
                r := widget.Content()
                r.Name = widget.Name()
                r.Instance = widget.Name()
                r.Markup = "pango"
                if len(r.FullText) > 0 {
                    r.FullText = " " + r.FullText + " "
                }
                if !plain {
                    fmt.Print(r.Serialize())
                } else {
                    fmt.Print(r.FullText)
                }
                first = false
            }
            if !plain {
                fmt.Print("]")
            } else {
                fmt.Println()
            }
            // fmt.Println(strings.Join(outputs, Sep))
        case line := <-stdin:
            if line == "[" {
                continue
            }
            line = strings.Trim(line, ",")
            e := InputEvent{}
            _ = json.Unmarshal([]byte(line), &e)
            click, ok := clicks[e.Name]
            if ok {
                click <- e.Button
            }
            // fmt.Printf(",[{\"full_text\":\"%s\"}]\n", strings.Replace(line, "\"", "~", -1))
        }
    }
    fmt.Print("]")
    cancel()
}
