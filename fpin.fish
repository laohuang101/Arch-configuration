function fpin
    # 1. Fetch available apps from Flathub
    # 2. Use awk to format the list (Name + ID)
    set -l pkg (flatpak remote-ls flathub --columns=name,application | fzf --multi --ansi \
                    --layout=reverse \
                    --header="Flatpak Install | TAB to multi-select" \
                    --border)
    
    if test -n "$pkg"
        # Extract the Application ID (the second column) and install
        echo $pkg | awk '{print $NF}' | xargs flatpak install -y flathub
    else
        echo "No selection made."
    end
end
