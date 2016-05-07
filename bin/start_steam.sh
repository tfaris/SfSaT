#!/bin/bash
# Does the following when it detects steam:
# 1. Kills f.lux so screen color isn't messed up
# 2. Switches to a basic windows theme for performance
# 3. Switches the audio device to the TV audio, if optional argument --tv is found.
# Undoes all of these when steam stops.

pcSoundDevice="Speakers (Realtek"
tvSoundDevice="SAMSUNG"
themeSwitcher="C:\Program Files (x86)\WinaeroThemeSwitcher\ThemeSwitcher.exe"
desktopTheme="$LOCALAPPDATA\Microsoft\Windows\Themes\desktop.theme"
basicTheme="$LOCALAPPDATA\Microsoft\Windows\Themes\w7 basic.theme"
tvMode=false

function normalTheme() {
    echo "Changing back to desktop theme..."
    "$themeSwitcher" "$desktopTheme"
    echo "Restarting f.lux..."
    start $LOCALAPPDATA/FluxSoftware/Flux/flux.exe
    if [ $tvMode = true ]
    then
        selectAudioDevice "$pcSoundDevice"
    fi
}
function selectAudioDevice() {
    app="$LOCALAPPDATA\Apps\2.0\K8HX0D3Z.9LB\0O0B47AH.A0N\soun..tion_0000000000000000_0002.0004_f839aedc2aa2d7a7\lib\SoundSwitch.AudioInterface.exe"
    device=$("$app" | grep "$1")
    deviceNumber=$(echo $device | sed -r 's/([0-9])\:.*/\1/g')
    if [ "$deviceNumber" == "" ]; then
        echo "Device "$1" not found (line item found: $device)."
    else
        "$app" $deviceNumber
    fi    
}

while [[ $# > 0 ]]
do
    key="$1"
    
    case $key in
        --tv)
        tvMode=true
        ;;
        *)
        ;;
    esac
    shift
done

echo "Starting Steam..."
cd "C:\Program Files (x86)\Steam"
if [ $tvMode = true ]
then
    ./Steam.exe -tenfoot &
else
    ./Steam.exe &
fi

trap normalTheme EXIT
while [[ 1 ]]
do
    steamRunning=$(ps -eW | grep Steam.exe)
    fluxRunning=$(ps -eW | grep flux.exe)
    if [ -n "$steamRunning" ] && [ -n "$fluxRunning" ]
    then
        echo "Killing f.lux..."
        taskkill //IM flux.exe
        if [ $tvMode = true ]
        then
            echo "Switching audio devices..."
            selectAudioDevice "$tvSoundDevice"
        fi
        echo "Changing to a basic theme..."
        "$WinaeroThemeSwitcher" "$basicTheme"
    else        
        if !([ -n "$fluxRunning" ]) && !([ -n "$steamRunning" ])
        then
            normalTheme
        fi
    fi
    sleep 1m
done
