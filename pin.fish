function pin
    # We use a helper variable to track the state
    set -l apps_cmd "yay -Slq"
    set -l cats_cmd "yay -Sg | cut -d' ' -f1 | sort -u"
    
    set -l pkg (eval $apps_cmd | fzf --multi --ansi \
                    --layout=reverse \
                    --header="Search All | CTRL-C: Toggle Categories" \
                    --prompt="Apps> " \
                    --border \
                    --bind "ctrl-c:transform:[ \"\$FZF_PROMPT\" = \"Apps> \" ] && echo \"reload($cats_cmd)+change-prompt(Categories> )\" || echo \"reload($apps_cmd)+change-prompt(Apps> )\"")
    
    if test -n "$pkg"
        yay -S $pkg
    else
        echo "No selection made."
    end
end
