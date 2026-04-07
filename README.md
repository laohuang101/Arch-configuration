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

# WinApps
## Insatll
```
sudo pacman -Syu --needed -y qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat libguestfs ebtables iptables swtpm libtpms dialog
sudo usermod -aG libvirt,kvm $(whoami)
sudo systemctl enable --now libvirtd
sudo systemctl enable --now virtlogd
mkdir -p ~/.config/libvirt
echo 'uri_default = "qemu:///system"' > ~/.config/libvirt/libvirt.conf
git clone https://github.com/winapps-org/winapps.git ~/.local/share/winapps
cd ~/.local/share/winapps
mkdir -p ~/.config/winapps
nano ~/.config/winapps/winapps.conf
```
```
RDP_USER="winapps"
RDP_PASS="mypassword"
WAFLAVOR="libvirt"
GUEST_NAME="RDPWindows"
LIBVIRT_URI="qemu:///system"
```

## Check Windows Activation key
```
sudo strings /sys/firmware/acpi/tables/MSDM
```

## Configure (VM xml)
```
<sysinfo type="smbios">
    <oemStrings>
      <entry>BypassTPMCheck</entry>
      <entry>BypassSecureBootCheck</entry>
    </oemStrings>
  </sysinfo>
  <os firmware="efi">
    <type arch="x86_64" machine="pc-q35-10.2">hvm</type>
    <firmware>
      <feature enabled="no" name="enrolled-keys"/>
      <feature enabled="yes" name="secure-boot"/>
    </firmware>
    <loader readonly="yes" secure="yes" type="pflash" format="raw">/usr/share/edk2/x64/OVMF_CODE.secboot.4m.fd</loader>
    <nvram template="/usr/share/edk2/x64/OVMF_VARS.4m.fd" templateFormat="raw" format="raw">/var/lib/libvirt/qemu/nvram/RDPWindows_VARS.fd</nvram>
    <boot dev="hd"/>
    <smbios mode="sysinfo"/>
  </os>
```

## Upgrate to windows pro key
```
VK7JG-NPHTM-C97JM-9MPGT-3V66T
```

## Create Remote user & allow all app for remote
```
net user winapps mypassword /add
net localgroup administrators winapps /add
:: 1. The standard allowlist disable
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList" /v fDisabledAllowList /t REG_DWORD /d 1 /f

:: 2. The Group Policy override
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fAllowUnlistedRemotePrograms /t REG_DWORD /d 1 /f

:: 3. The 'Applications Specified' override
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList" /v fApplicationsSpecified /t REG_DWORD /d 0 /f
```

## After all apps intall on windows, create shortcut on linux
```
rm -rf ~/.config/freerdp/server
cd ~/.local/share/winapps
LIBVIRT_DEFAULT_URI="qemu:///system" ./setup.sh
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

# Cloudflare WARP
- Download and connect
```
yay -S cloudflare-warp-bin
sudo systemctl enable --now warp-svc
warp-cli registration new
warp-cli connect
```

- Disconnect
```
warp-cli disconnect
```

- Check Status
```
ip addr
warp-cli status
ip route show
curl ipconfig.me
```

- Disable ivp6 (optional if WARP still not running)
```
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
```

- Changing to tunnel mode
```
warp-cli mode warp
```

- Changing to 1.1.1.1
```
warp-cli mode dns
```

- Checking WARP connection point
```
curl -s https://www.cloudflare.com/cdn-cgi/trace | grep colo
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
