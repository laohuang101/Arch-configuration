function fpun
    # 1. List installed apps
    # 2. Filter out runtimes (we usually only want to uninstall the apps)
    set -l pkg (flatpak list --app --columns=name,application | fzf --multi --ansi \
                    --layout=reverse \
                    --header="Flatpak Uninstall | TAB to multi-select" \
                    --border)
    
    if test -n "$pkg"
        # Extract the ID and uninstall
        echo $pkg | awk '{print $NF}' | xargs flatpak uninstall -y
    else
        echo "No selection made."
    end
end
