THEME="$HOME/.config/rofi/launchers/type-6/style-6.rasi"
THEME2="$HOME/.config/rofi/launchers/type-4/style-4.rasi"
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
        office_regex="\.(docx|doc|dotx|odt|rtf|txt|xlsx|xls|xltx|ods|csv|pptx|ppt|potx|odp|pdf)$"
        pcap_regex="\.(pcap|pcapng|cap|erf|snoop|5vw|trc|raw|pklg)$"
        img_regex="\.(img(\.gz)?|dd(\.bz2)?|raw|iso)$"
        compress_regex="\.(zip|tar\.gz|tgz|tar\.xz|7z)$"
        
        if [[ "${clean_name,,}" =~ $pcap_regex ]]; then
            menu_options="󰈸 Open with Wireshark\n󱚽 Quick Preview (TShark)\n$menu_options"
        fi

        if [[ "$clean_name" =~ $office_regex ]]; then
            menu_options="󰏆 Open with OnlyOffice\n$menu_options"
        fi

        if [[ "$full_path" =~ $compress_regex ]]; then
            menu_options="󰿗 Extract Archive\n$menu_options"
        fi

        if [[ "${clean_name,,}" =~ $img_regex ]]; then
             menu_options="󰭟 Quick Extract & Analyze\n󰭟 Timeline\n Recover\n$menu_options"
        fi

        action=$(echo -e "$menu_options" | rofi -dmenu -i -p "Action for $clean_name" -theme "$THEME")

        case "$action" in
            *Wireshark*)
                notify-send "Wireshark" "Loading packet capture..."
                wireshark "$full_path" > /dev/null 2>&1 &
                exit 0
                ;;
            *TShark*)
                kitty --hold sh -c "echo '--- Protocol Hierarchy ---'; tshark -r '$full_path' -z io,phs -q | bat -p; echo -e '\n--- Top 20 Packets ---'; tshark -r '$full_path' -c 20 | bat -p" &
                exit 0
                ;;
            *Quick* | *Recover* | *Timeline*)
                current_action="$action" 
                if [[ "$full_path" == *.gz ]]; then
                    img="${full_path%.gz}"
                    [[ ! -f "$img" ]] && notify-send "Gzip" "Extracting..." && gunzip -fk "$full_path"
                elif [[ "$full_path" == *.bz2 ]]; then
                    img="${full_path%.bz2}"
                    [[ ! -f "$img" ]] && notify-send "Bzip2" "Extracting..." && bunzip2 -fk "$full_path"
                else
                    img="$full_path"
                fi

                partition_list=$(mmls "$img" 2>/dev/null | grep -E "DOS|Win95|Linux|NTFS|FAT")
                
                if [[ -n "$partition_list" ]]; then
                    selected_part=$(echo "$partition_list" | rofi -dmenu -p "Select Partition:" -i -theme "$THEME2")
                    [[ -z "$selected_part" ]] && exit 0
                    offset=$(echo "$selected_part" | awk '{print $3}' | tr -d '[:space:]')
                    notify-send "Debug" "Offset captured: [$offset]"
                    fs_opts="-o $offset"
                else
                    fs_opts=""
                    offset="0"
                    notify-send "Forensics" "No partition table, treating as raw."
                fi

                case "$current_action" in
                    *Recover*)
                        all_metadata=$(fls $fs_opts -r "$img" 2>/dev/null)
                        
                        if [[ -z "$all_metadata" ]]; then
                            notify-send "Error" "No filesystem found at offset $offset."
                            ans=$(echo -e "Try-Deep-Carve\nCancel" | rofi -dmenu -p "Action:" -theme "$THEME2")
                            [[ "$ans" == *"Deep-Carve"* ]] && action="*Deep-Carve-Only*" || exit 0
                        fi

                        view_mode=$(echo -e "Show-All-Files-In-Partition" | rofi -dmenu -p "View Mode:" -theme "$THEME2")
                        
                        if [[ "$view_mode" == *"Show-All-Files-In-Partition"* ]]; then
                            display_list=$(echo "$all_metadata" | grep -v "V/V\|v/v") 
                        fi

                        if [[ -z "$display_list" ]]; then
                            notify-send "Recover" "No files found in this category."
                            exit 0
                        fi
                        selected=$(echo "$display_list" | rofi -dmenu -multi-select -p "Select to Recover (Shift+Enter):" -theme "$THEME2")
                        [[ -z "$selected" ]] && exit 0

                        out_base="$(realpath .)/recovered_$(date +%s)_p$offset"
                        mkdir -p "$out_base"

                        echo "$selected" | while read -r line; do
                            inode=$(echo "$line" | awk '{print $3}' | tr -d '[:space:]' | tr -d ':')
                            fname=$(echo "$line" | cut -d':' -f2- | xargs | tr ' ' '_')
                            [[ "$fname" == _* ]] && fname="recovered${fname}"
                            
                            icat $fs_opts "$img" "$inode" > "$out_base/$fname"
                        done
                        
                        notify-send "Success" "Files extracted to $out_base"
                        xdg-open "$out_base"
                        ;;

                    *Quick*|*Analyze*)
                        list_file="${img}_p${offset}_filelist.txt"
                        notify-send "Forensics" "Generating file list..."
                        fls $fs_opts -r "$img" > "$list_file"
                        if [ -s "$list_file" ]; then
                            code "$list_file"
                        else
                            notify-send "Error" "List is empty."
                        fi
                        ;;

                    *Timeline*)
                        timeline_file="${img}_p${offset}_timeline.txt"
                        body_file="${img}_p${offset}.body"
                        notify-send "Timeline" "Generating MACB timeline..."
                        fls $fs_opts -r -m / "$img" > "$body_file"
                        mactime -b "$body_file" > "$timeline_file"
                        kitty --title "Timeline" sh -c "less -Si '$timeline_file'" &
                        ;;
                    *)
                        # This will trigger if the 'case' fails to match the action string
                        notify-send "Debug Error" "Action '$current_action' did not match any case."
                        ;;
                esac
                exit 0
                ;;
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
                        *.bz2) bunzip2 -fk "$TARGET_DIR" ;;
                    esac
                ) && notify-send "Success" "Extracted $clean_name" || notify-send "Error" "Failed to extract $clean_name" &
                exit 0
                ;;
            *VSCode*)
                code "$full_path" > /dev/null 2>&1 &
                exit 0
                ;;
            *OnlyOffice*)
                desktopeditors "$full_path" > /dev/null 2>&1 &
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
