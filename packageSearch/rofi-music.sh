THEME="$HOME/.config/rofi/launchers/type-6/style-6.rasi"

query=$(rofi -dmenu -p "󰎆 Search YouTube" -theme "$THEME")

if [ -z "$query" ]; then exit 0; fi

notify-send "Music Search" "Searching for '$query'..."
results=$(yt-dlp "ytsearch5:$query" --get-title --get-id --flat-playlist | sed 'N;s/\n/ -- /')

choice=$(echo -e "$results" | rofi -dmenu -i -p "󰝚 Results" -theme "$THEME")

if [ -n "$choice" ]; then
    video_id=$(echo "$choice" | awk -F ' -- ' '{print $NF}')
    url="https://www.youtube.com/watch?v=$video_id"

    qs -c noctalia-shell ipc call plugin:music play "$url"
    notify-send "Now Playing" "$(echo "$choice" | awk -F ' -- ' '{print $1}')"
fi
