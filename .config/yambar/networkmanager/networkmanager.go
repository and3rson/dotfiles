package main

import (
	"context"
	"fmt"
	"time"

	"github.com/Wifx/gonetworkmanager"
	"github.com/godbus/dbus/v5"
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

func (n *NetworkManager) Run(ctx context.Context, updates chan<- bool) {
    defer func() {
        if e := recover(); e != nil {
            n.err = e
            <-time.After(time.Second)
            go n.Run(ctx, updates)
        }
    }()

    nm, err := gonetworkmanager.NewNetworkManager()
    if err != nil {
        panic("failed to connect to networkmanager")
    }
    nmUpdates := nm.Subscribe()

    needsRefresh := true

    for {
        if needsRefresh {
            devices, err := nm.GetPropertyAllDevices() // TODO: Or GetAllDevices?
            if err != nil {
				if e, ok := err.(dbus.Error); ok && e.Name == "org.freedesktop.DBus.Error.ServiceUnknown" {
					panic("disabled")
				}
				// panic(fmt.Sprintf("%T", err))
                panic("failed to get all devices")
            }
            found := false
            for _, device := range devices {
                deviceType, err := device.GetPropertyDeviceType()
                if err != nil {
                    panic("failed to get device type")
                }
                if (deviceType == gonetworkmanager.NmDeviceTypeWifi) {
                    conn, err := device.GetPropertyActiveConnection()
                    if err != nil {
                        panic("failed to get active connection")
                    }
                    if conn == nil {
                        // No connection at all - WiFi disabled?
                        continue
                    }
                    found = true
                    obj, err := conn.GetPropertySpecificObject()
                    if err != nil {
                        panic("failed to get specific object")
                    }
                    ssid, err := obj.GetPropertySSID()
                    if err != nil {
                        panic("failed to get ssid")
                    }
                    state, err := conn.GetPropertyState()
                    if err != nil {
                        panic("failed to get state")
                    }
                    found = true
                    n.isConnected = state == gonetworkmanager.NmActiveConnectionStateActivating || state == gonetworkmanager.NmActiveConnectionStateActivated
                    if state == gonetworkmanager.NmActiveConnectionStateActivating || state == gonetworkmanager.NmActiveConnectionStateDeactivating {
                        n.network = ssid
                        n.isChanging = true
                    } else {
                        n.network = ssid
                        n.isChanging = false
                    }
                    n.err = nil
                    updates <- true
                }
            }
            if !found {
                n.isConnected = false
                n.isChanging = false
                n.network = "Offline"
                n.err = nil
                updates <- true
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
        }
    }
}

func main() {
	n := &NetworkManager{}
	context, cancel := context.WithCancel(context.Background())
	updates := make(chan bool)
	go n.Run(context, updates)
	for {
		select {
		case <-updates:
			if n.isChanging {
				fmt.Printf("state|string|changing\n")
			} else if n.isConnected {
				fmt.Printf("state|string|connected\n")
			} else {
				fmt.Printf("state|string|disconnected\n")
			}
			fmt.Printf("network|string|%s\n", n.network)
			fmt.Println()
		}
	}
	cancel()
}
