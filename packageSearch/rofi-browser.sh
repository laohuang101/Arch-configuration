THEME="$HOME/.config/rofi/launchers/type-6/style-6.rasi"
TARGET_DIR="$(realpath "${1:-$HOME}")"

while true; do
    list=$(ls -p --group-directories-first "$TARGET_DIR")
    list="..\n$list"

    selected=$(echo -e "$list" | rofi -dmenu -i -p "󱆒 ${TARGET_DIR##*/}/" -theme "$THEME")

    if [ -z "$selected" ]; then
        exit 0
    fi

    clean_name=$(echo "$selected" | sed 's|/$||')

    if [ "$clean_name" == ".." ]; then
        TARGET_DIR="$(dirname "$TARGET_DIR")"
        continue
    fi

    full_path="$TARGET_DIR/$clean_name"

    if [ -d "$full_path" ]; then
        TARGET_DIR="$full_path"
    elif [ -f "$full_path" ]; then
        case "$full_path" in
            *.zip)
                notify-send "Unzipping" "$clean_name..."
                unzip -o "$full_path" -d "$TARGET_DIR" && notify-send "Success" "Extracted $clean_name" &
                exit 0
                ;;
            *.tar.gz|*.tgz)
                notify-send "Extracting" "$clean_name..."
                tar -xzf "$full_path" -C "$TARGET_DIR" && notify-send "Success" "Extracted $clean_name" &
                exit 0
                ;;
            *.tar.xz)
                notify-send "Extracting" "$clean_name..."
                tar -xJf "$full_path" -C "$TARGET_DIR" && notify-send "Success" "Extracted $clean_name" &
                exit 0
                ;;
            *.7z)
                notify-send "Extracting" "$clean_name..."
                7z x "$full_path" -o"$TARGET_DIR" && notify-send "Success" "Extracted $clean_name" &
                exit 0
                ;;
            *)
                code "$full_path" > /dev/null 2>&1 &
                exit 0
                ;;
        esac
    else
        notify-send "Error" "Cannot access: $full_path"
        sleep 1
    fi
done
