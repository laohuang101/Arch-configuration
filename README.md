# Arch-configuration
Arch configuration file 


# Java based app cant run issue
echo $DISPLAY

: if is empty 

  ~ sudo pacman -S xorg-xwayland 
  
  ~ sudo pacman -S xwayland-satellite 
  
  ~ then exit niri (Mod + Shift + E)
  
# Brightness
-- this will check for the real bootloader
sudo grep -rn "NVreg_EnableBacklightHandler" /boot /efi /etc 2>/dev/null
: If is rEFInd
  !! Delete conflict file
  - sudo rm /etc/modprobe.d/nvidia.conf

  !! change the Real configuration
  - sudo nano /boot/refind_linux.conf
``` "Boot with standard options"  "root=UUID=<UUID> rw rootflags=subvol=@ zswap.enabled=0 rootfstype=btrfs loglevel=3 quiet nvidia-drm.modeset=1 acpi_backlight=native"
"Boot to single-user mode"    "root=UUID=<UUID> rw rootflags=subvol=@ zswap.enabled=0 rootfstype=btrfs loglevel=3 quiet nvidia-drm.modeset=1 acpi_backlight=native single" ```

