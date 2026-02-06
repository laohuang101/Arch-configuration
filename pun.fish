function pun
    set -l pkg (yay -Qqe | fzf --multi \
                    --layout=reverse \
                    --header="Select packages to REMOVE (Tab to multi-select | Enter to confirm)" \
                    --border)
    
    if test -n "$pkg"
        yay -Rns $pkg
    else
        echo "No packages selected."
    end
end
