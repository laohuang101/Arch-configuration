# Using theme from (https://github.com/gutlessCGH/RONBM.git)

```
git clone https://github.com/gutlessCGH/RONBM.git
sudo mkdir /boot/EFI/refind/themes 
sudo cp -r ./RONBM /boot/EFI/refind/themes/RONBM
sudo nano /boot/EFI/refind/refind.conf
```
Add
```
include themes/RONBM/theme.conf
menuentry "Arch Linux" {
    icon     /EFI/refind/themes/RONBM/icons/os_arch.png
    loader   /vmlinuz-linux
    initrd   /initramfs-linux.img
    options  "root=UUID=<UUID> rw rootflags=subvol=@ zswap.enabled=0 rootfstype=btrfs loglevel=3 quiet nvidia-drm.modeset=1 acpi_backlight=native ipv6.disable=1"
}
```
Uncomment & Change
```
scanfor internal,external,optical,manual
dont_scan_files shim.efi,MokManager.efi, vmlinuz-linux, initramfs-linux.img, vmlinuz-linux-zen
```
