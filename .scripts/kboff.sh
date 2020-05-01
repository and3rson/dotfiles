#!/bin/bash

export DISPLAY=:0
`xinput list | grep AT | sed -E "s/.*id=([0-9]+).*\(([0-9]+)\).*/xinput float \1/g"`

