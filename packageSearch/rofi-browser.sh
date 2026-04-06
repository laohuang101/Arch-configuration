THEME="$HOME/.config/rofi/launchers/type-6/style-6.rasi"
TARGET_DIR="$(realpath "${1:-$HOME}")"

while true; do
    list=$(ls -ap --group-directories-first "$TARGET_DIR" | grep -v '^\./$')
    selected=$(echo -e "$list" | rofi -dmenu -i -p "󱆒 ${TARGET_DIR##*/}/" -theme "$THEME")

    if [ -z "$selected" ]; then exit 0; fi

    clean_name=$(echo "$selected" | sed 's|/$||')
    full_path="$TARGET_DIR/$clean_name"

    if [ -d "$full_path" ]; then
        TARGET_DIR="$full_path"
    elif [ -f "$full_path" ]; then
        
        menu_options="󰨞 Open with VSCode\n󰛒 Binwalk (Interactive)\n󱏒 View Hex (Hexyl)\n󰋽 View Meta Data"

        if [[ "$full_path" =~ \.(zip|tar\.gz|tgz|tar\.xz|7z)$ ]]; then
            menu_options="󰿗 Extract Archive\n$menu_options"
        fi

        action=$(echo -e "$menu_options" | rofi -dmenu -i -p "Action for $clean_name" -theme "$THEME")

        case "$action" in
            *Binwalk*)
                raw_output=$(binwalk "$full_path")
                
                bw_action=$(echo -e "󰿗 Extract (Files)\n󰅍 Copy Output to Clipboard" | \
                    rofi -dmenu -i -p "Binwalk Action" -theme "$THEME")

                case "$bw_action" in
                    *Extract*)
                        bw_list=$(echo "$raw_output" | awk 'NR>4 {
                            if ($0 ~ /^Analyzed/ || $0 ~ /^---/ || NF<3) next;
                            dec=$1; hex=$2; 
                            desc=""; for(i=3; i<=NF; i++) desc=desc $i " ";
                            printf "%-10s | %s [%s]\n", hex, desc, dec
                        }')

                        pick=$(echo -e "󰈄 Extract ALL Entries\n$bw_list" | \
                            rofi -dmenu -i -p "Select Entry" -theme "$THEME")

                        if [ -n "$pick" ]; then
                            if [[ "$pick" == *"Extract ALL"* ]]; then
                                out_dir="$TARGET_DIR/extracted_all_${clean_name}"
                                notify-send "Binwalk" "Extracting ALL to $out_dir..."
                                (binwalk -e --matryoshka "$full_path" -C "$out_dir" && \
                                 notify-send "Success" "All files extracted successfully" || \
                                 notify-send "Error" "Extraction failed!") &
                            else
                                offset=$(echo "$pick" | sed 's/.*\[\([0-9]*\)\].*/\1/')
                                out_dir="$TARGET_DIR/extracted_${offset}"
                                notify-send "Binwalk" "Extracting offset $offset..."
                                (binwalk -e --offset="$offset" "$full_path" -C "$out_dir" && \
                                 notify-send "Success" "Offset $offset extracted to $out_dir" || \
                                 notify-send "Error" "Extraction failed!") &
                            fi
                        fi
                        ;;

                    *Copy*)
                        if command -v wl-copy &> /dev/null; then
                            echo "$raw_output" | wl-copy
                        elif command -v xclip &> /dev/null; then
                            echo "$raw_output" | xclip -selection clipboard
                        else
                            notify-send "Error" "No clipboard tool (wl-copy or xclip) found!"
                            exit 1
                        fi
                        notify-send "Binwalk" "Table copied to clipboard!"
                        ;;
                esac
                exit 0
                ;;
            *Meta*)
                kitty --hold sh -c "exiftool '$full_path' | bat --language yaml --style=plain" &
                exit 0
                ;;
            *Extract*)
                notify-send "Extracting" "Processing $clean_name..."
                (
                    case "$full_path" in
                        *.zip) unzip -o "$full_path" -d "$TARGET_DIR" ;;
                        *.tar.*|*.tgz) tar -xf "$full_path" -C "$TARGET_DIR" ;;
                        *.7z) 7z x "$full_path" -o"$TARGET_DIR" ;;
                    esac
                ) && notify-send "Success" "Extracted $clean_name" || notify-send "Error" "Failed to extract $clean_name" &
                exit 0
                ;;
            *VSCode*)
                code "$full_path" > /dev/null 2>&1 &
                exit 0
                ;;

            *Hex*)
                hex_choice=$(echo -e "󱏒 Hexyl (Quick Preview)\n󰘦 Cutter (Reverse Engineering)\n󰨞 VSCode Hex (Editor)" | \
                    rofi -dmenu -i -p "Select Hex Tool" -theme "$THEME")

                case "$hex_choice" in
                    *Hexyl*)
                        kitty --hold sh -c "hexyl --color always '$full_path' | bat -p" &
                        ;;
                    *Cutter*)
                        notify-send "Cutter" "Loading $clean_name for analysis..."
                        cutter "$full_path" > /dev/null 2>&1 &
                        ;;
                    *VSCode*)
                        code --hex "$full_path" > /dev/null 2>&1 &
                        ;;
                esac
                exit 0
                ;;
        esac
    fi
done
