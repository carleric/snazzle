# snazzle

An experiment to see how a mobile app might connect to a service running on a IOT like device (given an arbitrary name "snazzle").

## hardware components

1. The snazzle device: A raspberry pi 3 kit, with ethernet, wifi and bluetooth included.
2. A mobile device: an iPhone 5S for starters

## snazzle device software and setup

1. raspian operating system
2. configured as a wireless access point, following instructions here: https://medium.com/@edoardo849/turn-a-raspberrypi-3-into-a-wifi-router-hotspot-41b03500080e#.xai92bxk0
3. a quick setup of the mock service using the zeroconf Python library https://github.com/wmcbrine/pyzeroconf

## mobile device software and setup

1. SnazzleClient (from this repo) installed on an iOS device.
2. In the device Wifi settings, connect to the  "Snazzle" ssid.
3. In the SnazzleClient app, notice that the Snazzle service is listed, meaning that it has been detected, and any properties from it could be used to show a configuration webview of a webapp that is served from the snazzle device.
