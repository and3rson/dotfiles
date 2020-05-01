#!/bin/bash

export DISPLAY=:0
`xinput list | grep AT | sed -E "s/.*id=([0-9]+).*/xinput reattach \1 3/g"`

