package main

import (
	"bufio"
	"context"
	"fmt"
	"os/exec"
	"os/user"
	"syscall"
	"time"
)

const SpectrumLen = 12
var strengthChars = []string{"\u2007", "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"}

type Spectrum struct {
    strengths [SpectrumLen]byte
	err interface{}
}

type cavaInfo struct {
	strengths [SpectrumLen]byte
	err error
}

func (s *Spectrum) Name() string {
    return "spectrum"
}

func streamCava(ctx context.Context) <-chan cavaInfo {
	// TODO: Handle errors
	output := make(chan cavaInfo, 32)
	go func() {
		usr, err := user.Current()
		if err != nil {
			output <- cavaInfo{err: err}
			return
		}
		home := usr.HomeDir
		cmd := exec.Command("cava", "-p", home + "/.config/cava/config.sway")
		cmd.SysProcAttr = &syscall.SysProcAttr{
			Pdeathsig: syscall.SIGTERM,
		}
		reader, err := cmd.StdoutPipe()
		if err != nil {
			output <- cavaInfo{err: err}
			return
		}
		err = cmd.Start()
		if err != nil {
			output <- cavaInfo{err: err}
			close(output)
			return
		}
		for {
			line := []byte{}
			bufReader := bufio.NewReader(reader)
			line, _, err := bufReader.ReadLine()
			if err != nil {
				output <- cavaInfo{err: err}
				close(output)
				return
			}
			info := cavaInfo{}
			for i := 0; i < SpectrumLen; i++ {
				info.strengths[i] = line[i * 2] - '0'
			}
			output <- info
			select {
				case <-ctx.Done():
					return
				default:
			}
		}
	}()
	return output
}

func (s *Spectrum) Run(ctx context.Context, updates chan<- Widget, click <-chan int) {
    defer func() {
        if e := recover(); e != nil {
			s.err = e
            <-time.After(time.Second)
            go s.Run(ctx, updates, click)
        }
    }()
	output := streamCava(ctx)
	for {
		select {
		case <-time.After(time.Second * 10):
			continue
		case <-ctx.Done():
			return
		case info := <-output:
			if info.err != nil {
				panic("streamCava died: " + fmt.Sprint(info.err))
			}
			s.err = nil
			s.strengths = info.strengths
			updates <- s
		}
	}
}

func (s *Spectrum) Content() Repr {
	color := "#FFD787"
	urgent := false
	if s.err != nil {
		return Repr{
            FullText: fmt.Sprint(s.err),
            Urgent: true,
		}
	}
	bar := ""
	for i := 0; i < SpectrumLen; i++ {
		bar += strengthChars[s.strengths[i]]
	}
	// for i := 0; i < SpectrumLen; i += 2 {
	// 	bar += GraphIcons[s.strengths[i]][s.strengths[i + 1]]
	// }
	return Repr{
		FullText:   "<span font_desc=\"monospace\">" + bar + "</span>",
		Background: "",
		Color:      color,
		Urgent:     urgent,
	}
	// return fmt.Sprintf("<span fgcolor=\"%s\">\uF7C9 %2dG</span>", color, d.free)
	// return fmt.Sprintf("<span fgcolor=\"#FFD787\">%s</span>", t.content)
}

