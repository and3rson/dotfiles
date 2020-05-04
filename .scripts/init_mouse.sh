#xinput set-prop 'TPPS/2 IBM TrackPoint' 323 -0.5
xinput set-prop 'TPPS/2 IBM TrackPoint' 'Device Accel Constant Deceleration' 1.8
xinput set-prop 'TPPS/2 IBM TrackPoint' 'Device Accel Velocity Scaling' 20

xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Timeout" 200

xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Axes" 6 7 4 5

xinput set-prop 'TPPS/2 IBM TrackPoint' 'Evdev Wheel Emulation Inertia' 25


#xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Synaptics Scrolling Distance' 20 20
synclient CoastingSpeed=0 VertScrollDelta=500 HorizScrollDelta=500 HorizTwoFingerScroll=1
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Synaptics Circular Scrolling' 0
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Synaptics Circular Scrolling Trigger' 2


xinput set-prop 'HTIX5288:00 0911:5288 Touchpad' 'Synaptics Edges' 71 1728 53 720
xinput set-prop 'HTIX5288:00 0911:5288 Touchpad' 'Synaptics Tap Durations' 120 120 100
xinput set-prop 'HTIX5288:00 0911:5288 Touchpad' 'Synaptics Tap Action' 0 0 0 0 1 3 2
xinput set-prop 'HTIX5288:00 0911:5288 Touchpad' 'Synaptics Scrolling Distance' 100 100

