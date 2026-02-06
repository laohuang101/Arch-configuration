function pclean
    echo "--- Releasing package manager locks ---"
    sudo rm -f /var/lib/pacman/db.lck
    
    echo "--- Clearing broken/incomplete downloads ---"
    sudo sh -c 'rm -rf /var/cache/pacman/pkg/*.part 2>/dev/null'
    sudo sh -c 'rm -rf /var/cache/pacman/pkg/download-* 2>/dev/null'
    
    echo "--- Removing Orphaned Dependencies (Safe) ---"
    set orphans (pacman -Qdtq)
    if test -n "$orphans"
        sudo pacman -R $orphans --noconfirm
    else
        echo "No orphans found. System is lean!"
    end
    
    echo "--- Cleaning Pacman Cache (keeping last 2) ---"
    if command -v paccache > /dev/null
        sudo paccache -rk2
    else
        sudo pacman -S --noconfirm pacman-contrib
        sudo paccache -rk2
    end
    
    echo "--- Cleaning System Logs (older than 3 days) ---"
    sudo journalctl --vacuum-time=3d
    
    echo "--- Cleaning Yay/AUR build cache ---"
    yay -Sc --noconfirm
    
    echo "--- Cleanup finished! ---"
end
