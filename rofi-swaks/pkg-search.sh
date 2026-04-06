THEME="$HOME/.config/rofi/launchers/type-6/style-6.rasi"
TERMINAL="kitty"

action=$(echo -e "󰨞 File\n󰐊 Install (AUR/Repo)\n󰗠 BlackArch Tools\n󰛌 Uninstall (Local)\n Flatpak\n󰎆 Music" | \
    rofi -dmenu -i -p "󰚗 Action" -theme "$THEME")

case "$action" in
    *File*)
	"/home/loke/scripts/rofi-browser.sh"
        ;;

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
    *Flatpak*)
        fp_action=$(echo -e "󰐊 Install App\n󰛌 Uninstall App\n󰚗 Update All\n󰃢 Cleanup (Unused)" | \
            rofi -dmenu -i -p "󰏖 Flatpak Management" -theme "$THEME")

        case "$fp_action" in
           *Install*)
                notify-send "Flatpak" "Fetching app list..."
                
                full_list=$(flatpak remote-ls flathub --columns=name,application 2>/dev/null | sed '1d')

                if [ -z "$full_list" ]; then
                    notify-send "Error" "Flathub list is empty or check your internet."
                    exit 1
                fi

                selected_line=$(echo "$full_list" | rofi -dmenu -i -p "󰏖 Browse Flathub:" -theme "$THEME")
                
                if [ -n "$selected_line" ]; then
                    app_id=$(echo "$selected_line" | awk '{print $NF}')
                    app_name=$(echo "$selected_line" | rev | cut -f2- | rev)
                    
                    notify-send "Flatpak" "Installing $app_name..."
                    $TERMINAL --hold -e flatpak install flathub "$app_id" -y
                fi
                ;;

            *Uninstall*)
                selected_uninstall=$(flatpak list --app --columns=application,name | \
                    rofi -dmenu -i -p "󰛌 Uninstall Flatpak" -theme "$THEME")
                
                if [ -n "$selected_uninstall" ]; then
                    app_id=$(echo "$selected_uninstall" | awk '{print $1}')
                    $TERMINAL --hold -e flatpak uninstall "$app_id"
                fi
                ;;

            *Update*)
                $TERMINAL --hold -e flatpak update
                ;;

            *Cleanup*)
                $TERMINAL --hold -e flatpak uninstall --unused
                ;;
        esac
        ;;
    *Music*)
        sub_action=$(echo -e "󰎆 Search & Play\n󰓛 Stop Music" | rofi -dmenu -p "󰎆 Music" -theme "$THEME")
        
        if [[ "$sub_action" == *"Search"* ]]; then
            ~/scripts/rofi-music.sh
        elif [[ "$sub_action" == *"Stop"* ]]; then
            qs -c noctalia-shell ipc call plugin:music stop
        fi
        ;;
   *)
        exit 0
        ;;
esac
