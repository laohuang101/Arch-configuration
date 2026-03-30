# Arch-configuration
Arch configuration file 

# install yay
```
sudo pacman -S --needed base-devel git
cd yay
makepkg -si
```

# fonts
```
sudo pacman -S --needed ttf-liberation ttf-dejavu noto-fonts noto-fonts-emoji noto-fonts-cjk
fc-cache -fv
```

# Change default shell
```
chsh -s /usr/bin/fish
```

# Noctalia 
## Check path
```
pacman -Q1 noctalia-bin
quickshell --path /etc/xdg/quickshell/noctalia-shell/shell.qml
```
## In niri/config.kdl
```
spawn-at-startup "quickshell" "--path" "/etc/xdg/quickshell/noctalia-shell/shell.qml"
```


# Java based app cant run issue
```
echo $DISPLAY
```

: if is empty 

```
sudo pacman -S xorg-xwayland 
  
sudo pacman -S xwayland-satellite 
``` 
then exit niri (Mod + Shift + E)

# Brightness Fix  
## Boot loader
: this will check for the real bootloader

``` sudo grep -rn "NVreg_EnableBacklightHandler" /boot /efi /etc 2>/dev/null ```

: If is rEFInd
  !! Delete conflict file
  - ```
    sudo rm /etc/modprobe.d/nvidia.conf
    ```

  :: change the Real configuration
  - ```
    sudo nano /boot/refind_linux.conf
    ```

: Get UUID
``` 
findmnt / -o UUID -n
```

: Rewrite the default configuration

```
"Boot with standard options"  "root=UUID=<UUID> rw rootflags=subvol=@ zswap.enabled=0 rootfstype=btrfs loglevel=3 quiet nvidia-drm.modeset=1 acpi_backlight=native"

"Boot to single-user mode"    "root=UUID=<UUID> rw rootflags=subvol=@ zswap.enabled=0 rootfstype=btrfs loglevel=3 quiet nvidia-drm.modeset=1 acpi_backlight=native single"
```

# Winboat
## Install
```
yay -S winboat-bin
sudo pacman -S --needed docker docker-compose freerdp
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
```
# 32 bit (for lutris)
## Enable multilib
```
sudo nano /etc/pacman.conf
```
uncommand the following line
```
[multilib]
Include = /etc/pacman.d/mirrorlist
```

```
sudo pacman -Syu
sudo pacman -Syu lib32-nvidia-utils lib32-gnutls lib32-libx11 lib32-libpipewire
```
