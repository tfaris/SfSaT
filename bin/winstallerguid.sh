#!/bin/bash
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
guid="$1"
if [ -z "$guid" ]; then
    printf "Enter the guid to pack:"
    read guid
fi
python "$scriptDir/winstallerguid.py" "$guid"
