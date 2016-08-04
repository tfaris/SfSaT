if [ ! -z "$TMP" ]; then
    tmp=$(mktemp -p "$TMP" 'XXXXX.sql')
elif [ ! -z "$TEMP" ]; then
    tmp=$(mktemp -p "$TEMP" 'XXXXX.sql')
elif [ ! -z "$temp" ]; then
    tmp=$(mktemp -p "$temp" 'XXXXX.sql')
else
    tmp=$(mktemp 'XXXXX.sql')
fi

sqldiff --help | sed -n 2p
sqldiff "$1" "$2" > "$tmp" 2> "$tmp"
editor=$(git config --get core.editor)
if [ -z "$editor" ]; then editor=vi; fi
eval $editor '$tmp'
