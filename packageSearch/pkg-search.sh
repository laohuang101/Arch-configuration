THEME="$HOME/.config/rofi/launchers/type-6/style-6.rasi"
TERMINAL="kitty"

action=$(echo -e "󰐊 Install (AUR/Repo)\n󰗠 BlackArch Tools\n󰛌 Uninstall (Local)" | \
    rofi -dmenu -i -p "󰚗 Action" -theme "$THEME")

case "$action" in
    *Install*)

        selected_pkg=$(yay -Slq | rofi -dmenu -i -p "󰆧 Search AUR/Repo" -theme "$THEME")
        if [ -n "$selected_pkg" ]; then
            $TERMINAL --hold -e yay -S "$selected_pkg"
        fi
        ;;

    *BlackArch*)

        list=$(pacman -Sl blackarch | awk '{print $2}')
        selected_tool=$(echo -e "$list" | rofi -dmenu -i -p "󰗠 BlackArch Tools" -theme "$THEME")
        if [ -n "$selected_tool" ]; then

            $TERMINAL --hold -e sudo pacman -S "blackarch/$selected_tool"
        fi
        ;;
                
    *Uninstall*)

        selected_pkg=$(pacman -Qeq | rofi -dmenu -i -p "󰛌 Uninstall" -theme "$THEME")
        if [ -n "$selected_pkg" ]; then
            $TERMINAL --hold -e sudo pacman -Rns "$selected_pkg"
        fi
        ;;
        
    *)
        exit 0
        ;;
esac