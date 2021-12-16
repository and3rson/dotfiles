package main

import (
	"fmt"
	"regexp"
)

type Renderer interface {
	Start()
	BeginRow()
	Render(Repr)
	EndRow()
}

type JSONRenderer struct {
	nItems int
}

type PlainRenderer struct{
	nItems int
}

var htmlRE = regexp.MustCompile("<[^>]+>")

func (JSONRenderer) Start() {
	fmt.Println("{\"version\": 1, \"click_events\": true}")
	fmt.Print("[")
	fmt.Print("[]")
}

func (r *JSONRenderer) BeginRow() {
	fmt.Print(",[")
	r.nItems = 0
}

func (r *JSONRenderer) Render(repr Repr) {
	repr.Separator = true
	if r.nItems > 0 {
		// repr.FullText = " " + repr.FullText
		fmt.Print(",")
	}
	fmt.Print(repr.Serialize())
	r.nItems++
}

func (JSONRenderer) EndRow() {
	fmt.Println("]")
}

func (PlainRenderer) Start() {
}

func (r *PlainRenderer) BeginRow() {
	r.nItems = 0
}

func (r *PlainRenderer) Render(repr Repr) {
	if r.nItems > 0 {
		fmt.Print(" | ")
	}
	fmt.Print(htmlRE.ReplaceAllString(repr.FullText, ""))
	r.nItems++
}

func (PlainRenderer) EndRow() {
	fmt.Println()
}
