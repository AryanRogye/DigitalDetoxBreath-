#!/bin/bash

set -e

create-dmg \
    --volname "DigtalDetox Installer" \
    --window-pos 200 120 \
    --window-size 800 400 \
    --icon-size 100 \
    --icon "DigitalDetoxBreathmacOS.app" 200 190 \
    --hide-extension "DigitalDetoxBreathmacOS.app" \
    --app-drop-link 600 185 \
    "DigitalDetoxBreath.dmg" \
    "./"
