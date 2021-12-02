package main

import (
	"bufio"
	"context"
	"fmt"
	"io"
	"os/exec"
	"os/user"
	"syscall"
	"time"
)

const SpectrumLen = 24
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

func streamCavaText(ctx context.Context) <-chan cavaInfo {
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

func streamCavaBinary(ctx context.Context) <-chan cavaInfo {
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
		line := make([]byte, 24)
		for {
			// line := []byte{}
			_, err := io.ReadFull(reader, line)
			if err != nil {
				output <- cavaInfo{err: err}
				close(output)
				return
			}
			info := cavaInfo{}
			for i := 0; i < SpectrumLen; i++ {
				info.strengths[i] = line[i] / 32
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
	output := streamCavaBinary(ctx)
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
		strength := float64(s.strengths[i]) / 8.0
		itemColor := HSV{(1.0 - strength) / 3.0, 0.5, 1}
		// char := strengthChars[s.strengths[i]]
		v := s.strengths[i] + 1
		if v > 8 {
			v = 8
		}
		char := rune(0x3000 + int(v))
		bar += fmt.Sprintf("<span color=\"%s\" font_desc=\"Bars\">%c</span>", itemColor.RGB().String(), char)
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

