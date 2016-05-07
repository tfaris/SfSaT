if (( $# == 0 )); then
    echo "Usage: sleep_when_file_found.sh FILE..."
    echo "Suspend the system after each FILE is found."
    exit 0
else
    filesFoundCount=0
    for ((i=1;i<$#+1;));
    do
        echo "checking ${!i}"
        if [ -f "${!i}" ]; then
            echo "found it"
            (( i++ ))
            (( filesFoundCount++ ))
        else
            sleep 2m
        fi
    done
    
    if (( filesFoundCount == $# )); then
        sleep 1m  # give it a minute to make sure the file is totally ready
                  # before we suspend
        echo "Night..."
        # apparently this doesn't work if hibernation is enabled
        rundll32.exe powrprof.dll,setsuspendstate sleep
    else
        echo "Exited the loop without finding all files. Don't ask me what happened..."
    fi
    
fi
