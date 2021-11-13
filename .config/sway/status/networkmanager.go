package main

import (
    "context"
    "fmt"
    "log"
    "time"

    "github.com/Wifx/gonetworkmanager"
)

type NetworkManager struct {
    isChanging bool
    isConnected bool
    network string
}

func (n *NetworkManager) Run(ctx context.Context, updates chan<- Widget) {
    nm, err := gonetworkmanager.NewNetworkManager()
    nmUpdates := nm.Subscribe()
    if err != nil {
        log.Fatal(err)
    }

    needsRefresh := true

    for {
        if needsRefresh {
            devices, err := nm.GetPropertyAllDevices() // TODO: Or GetAllDevices?
            if err != nil {
                log.Fatal(err)
            }
            found := false
            for _, device := range devices {
                deviceType, err := device.GetPropertyDeviceType()
                if err != nil {
                    log.Fatal(err)
                }
                if (deviceType == gonetworkmanager.NmDeviceTypeWifi) {
                    conn, err := device.GetPropertyActiveConnection()
                    if err != nil {
                        log.Fatal(err)
                    }
                    if conn == nil {
                        // No connection at all - WiFi disabled?
                        continue
                    }
                    found = true
                    obj, err := conn.GetPropertySpecificObject()
                    if err != nil {
                        log.Fatal(err)
                    }
                    ssid, err := obj.GetPropertySSID()
                    if err != nil {
                        log.Fatal(err)
                    }
                    state, err := conn.GetPropertyState()
                    if err != nil {
                        log.Fatal(err)
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
                    updates <- n
                }
            }
            if !found {
                n.isConnected = false
                n.isChanging = false
                n.network = "Offline"
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
        }
    }
}

func (n *NetworkManager) Content() string {
    icon := "\uFAA8"
    color := "#5FD7FF"
    if n.isChanging {
        icon = "\uF6D7"
    }
    if !n.isConnected {
        color = "#FF005F"
    }
    return fmt.Sprintf("<span fgcolor=\"%s\">%s %s</span>", color, icon, n.network)
}
