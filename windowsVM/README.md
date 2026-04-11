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
