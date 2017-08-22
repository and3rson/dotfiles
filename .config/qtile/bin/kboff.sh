#!/bin/bash

`xinput list | grep AT | sed -E "s/.*id=([0-9]+).*\(([0-9]+)\).*/xinput float \1/g"`

