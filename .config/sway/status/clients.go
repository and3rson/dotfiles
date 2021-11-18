package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os/exec"
	"strings"
	"time"
)

var nodeIcons = map[string]string{
    "alacritty": "\uf120",
    "hometerm": "\uf120",
    "firefoxdeveloperedition": "\uf269",
    "telegramdesktop": "\uf2c6",
    "spotify": "\uf1bc",
}

type Node struct {
    Type string `json:"type"`
    Focused bool `json:"focused"`
    Name string `json:"name"`
    Nodes []*Node `json:"nodes"`
    AppID string `json:"app_id"`
    Representation string `json:"representation"`
    WindowProperties map[string]string `json:"window_properties"`
}

func (n *Node) Icon() string {
    if icon, ok := nodeIcons[strings.ToLower(n.AppID)]; ok {
        return icon
    }
    for _, value := range n.WindowProperties {
        if icon, ok := nodeIcons[strings.ToLower(value)]; ok {
            return icon
        }
    }
    return ""
}

func getTree() *Node {
    tree, _ := exec.Command("swaymsg", "-t", "get_tree").Output()
    var root Node
    _ = json.Unmarshal(tree, &root)
    return &root
}

func findFocusedNode(root *Node) *Node {
    for _, node := range root.Nodes {
        if node.Focused {
            return node
        }
        found := findFocusedNode(node)
        if found != nil {
            return found
        }
    }
    return nil
}

func getClientNode(root *Node) *Node {
    focused := findFocusedNode(root)
    if focused != nil && focused.Type == "con" {
        return focused
    }
    return nil
}

func getCurrentWorkspace(root *Node) *Node {
    for _, node := range root.Nodes {
        if node.Type == "workspace" {
            if focused := findFocusedNode(node); focused != nil {
                return node
            }
        }
        if child := getCurrentWorkspace(node); child != nil {
            return child
        }
    }
    return nil
}

type Clients struct {
    workspace *Node
    node *Node
}

func (c *Clients) Name() string {
    return "clients"
}

func (c *Clients) Run(ctx context.Context, updates chan<- Widget, click <-chan int) {
    root := getTree()
    c.workspace = getCurrentWorkspace(root)
    c.node = getClientNode(root)
    updates <- c
    changed := SwaySubscribe(ctx, []string{"window", "workspace"})
    for {
        select {
        case <-time.After(time.Second * 10):
            continue
        case <-ctx.Done():
            return
        case <-changed:
            root := getTree()
            c.workspace = getCurrentWorkspace(root)
            c.node = getClientNode(root)
            updates <- c
            changed = SwaySubscribe(ctx, []string{"window", "workspace"})
        }
    }
}

func (c *Clients) Content() Repr {
	// color := "#FFD787"
    if c.node == nil {
        return Repr{}
    }
    parts := []string{}
    if icon := c.node.Icon(); icon != "" {
        parts = append(parts, fmt.Sprintf("<span color=\"#87D787\">%s</span>", icon))
    }
    parts = append(parts, c.workspace.Representation)
    return Repr{
		FullText:   strings.Join(parts, " "),
		// Background: "",
        // MinWidth: 150,
        Align: "left",
        // Background: "#448844",
		Color:      "#FFFFFF",
    }
    // return fmt.Sprintf("<span fgcolor=\"%s\">\uF7C9 %2dG</span>", color, d.free)
    // return fmt.Sprintf("<span fgcolor=\"#FFD787\">%s</span>", t.content)
}


