# Arch-configuration
Arch configuration file 

# install yay
```
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
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
## Install
```
yay -S noctalia-shell
```
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
"Boot with standard options"  "root=UUID=<UUID> rw rootflags=subvol=@ zswap.enabled=0 rootfstype=btrfs loglevel=3 quiet nvidia-drm.modeset=1 acpi_backlight=native ipv6.disable=1"

"Boot to single-user mode"    "root=UUID=<UUID> rw rootflags=subvol=@ zswap.enabled=0 rootfstype=btrfs loglevel=3 quiet nvidia-drm.modeset=1 acpi_backlight=native single ipv6.disable=1"
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

# Pinyin input
```
sudo pacman -S fcitx5
sudo pacman -S --needed fcitx5-chinese-addons fcitx5-pinyin-zhwiki
```

# Fixing brave cant do pinyin input
```
brave --ozone-platform-hint=auto
```

# Black arch repo
```
curl -O https://blackarch.org/strap.sh
chmod +x ./strap.sh
sudo ./strap.sh
sudo pacman -Syyu
```

# rofi-swaks usage
- Have some scripts that can run on rofi
- Detail stated in https://github.com/laohuang101/Arch-configuration/blob/main/rofi-swaks/readme.md

# Foot Printing
- Tools required
  ``` sudo pacman whois bind  ```

# uninstall and cleanup from yay
```
yay -Rsc <name>
```

# Remove unused dependency
```
sudo pacman -Rns $(pacman -Qdtq)
```

# Reset password wrong count
```
sudo faillock --user <name> --reset
```

# Pulling beta kernel (currently pull for 7.0)

```
yay -S linux-mainline
```

If get gpg key: server receive fail error
- bypass gpg key


```
yay -S linux-mainline --mflags "--skippgpcheck"
```
