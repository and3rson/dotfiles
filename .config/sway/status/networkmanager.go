package main

import (
	"context"
	"fmt"
	"time"

	"github.com/Wifx/gonetworkmanager"
)

type NetworkManager struct {
    isChanging bool
    isConnected bool
    network string
    err interface{}
}

func (n *NetworkManager) Name() string {
    return "networkmanager"
}

func (n *NetworkManager) Run(ctx context.Context, updates chan<- Widget, click <-chan int) {
    defer func() {
        if e := recover(); e != nil {
            n.err = e
            <-time.After(time.Second)
            go n.Run(ctx, updates, click)
        }
    }()

    nm, err := gonetworkmanager.NewNetworkManager()
    if err != nil {
        panic("connect to networkmanager: " + err.Error())
    }
    nmUpdates := nm.Subscribe()

    needsRefresh := true

    for {
        if needsRefresh {
            devices, err := nm.GetPropertyAllDevices() // TODO: Or GetAllDevices?
            if err != nil {
                panic("get all devices: " + err.Error())
            }
            found := false
            for _, device := range devices {
                deviceType, err := device.GetPropertyDeviceType()
                if err != nil {
                    panic("get device type: " + err.Error())
                }
                if (deviceType == gonetworkmanager.NmDeviceTypeWifi) {
                    conn, err := device.GetPropertyActiveConnection()
                    if err != nil {
                        panic("get active connection: " + err.Error())
                    }
                    if conn == nil {
                        // No connection at all - WiFi disabled?
                        continue
                    }
                    found = true
                    obj, err := conn.GetPropertySpecificObject()
                    if err != nil {
                        panic("get specific object: " + err.Error())
                    }
                    ssid, err := obj.GetPropertySSID()
                    if err != nil {
                        panic("get ssid: " + err.Error())
                    }
                    state, err := conn.GetPropertyState()
                    if err != nil {
                        panic("get state: " + err.Error())
                    }
                    found = true
                    n.isConnected = state == gonetworkmanager.NmActiveConnectionStateActivating || state == gonetworkmanager.NmActiveConnectionStateActivated
                    if state == gonetworkmanager.NmActiveConnectionStateActivating || state == gonetworkmanager.NmActiveConnectionStateDeactivating {
                        n.network = ssid + "..."
                        n.isChanging = true
                    } else {
                        n.network = ssid
                        n.isChanging = false
                    }
                    n.err = nil
                    updates <- n
                }
            }
            if !found {
                n.isConnected = false
                n.isChanging = false
                n.network = "Offline"
                n.err = nil
                updates <- n
            }
            needsRefresh = false
        }

        select {
        case <-time.After(5 * time.Second):
            needsRefresh = true
        case s := <-nmUpdates:
            if s.Name == "org.freedesktop.NetworkManager.StateChanged" {
                needsRefresh = true
            }
        case <-ctx.Done():
            return
        case <-click:
        }
    }
}

func (n *NetworkManager) Content() Repr {
    if n.err != nil {
        return Repr{
            FullText: fmt.Sprint(n.err),
            Color: "#FFD787",
            Urgent: true,
        }
    }
    icon := "\uFAA8"
    color := "#5FD7FF"
    urgent := false
    if n.isChanging {
        icon = "\uF6D7"
    }
    if !n.isConnected {
        color = "#FF005F"
        urgent = true
    }
    return Repr{
    	FullText:   fmt.Sprintf("%s %s", icon, n.network),
    	Background: "",
    	Color:      color,
        Urgent:     urgent,
    }
    // return fmt.Sprintf("<span fgcolor=\"%s\">%s %s</span>", color, icon, n.network)
}
