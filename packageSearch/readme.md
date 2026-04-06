# This script is for package listing for install and uninstall (AUR & BlackArch packages), can works with Music Search plugin, build with a file browser to open file in vscode and decompress folder
<img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/310babec-f26e-416d-beae-1897f76ef1da" />

## Package required summary
```
sudo yay -S rofi fzf kitty fish mpv yt-dlp jq unzip tar p7zip code perl-image-exiftool hexyl binwalk wl-clipboard xclip bat
```

## Dependency: 
- Rofi (configuration from adi1090x theme-6 style-6)
- fzf
- kitty (or other terminal)
- Black Arch repo (optional)

### Noctalia plugin 
- Music Search (https://noctalia.dev/plugins/music-search/)
  ! use with rofi-music.sh can search music using rofi
  ! ``` sudo pacman -S mpv yt-dlp jq ```

## File browser (decompress, open files using vscode, check meta data, hex value and find hiden files)
<img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/cd2da857-f337-4210-a154-9761b16621d7" />
<img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/53572832-eeaa-4dc4-9a98-466a6f3f0a9d" />


! use with rofi-browser.sh
! ``` sudo pacman -S unzip tar p7zip code ```

### File meta data display
- perl-image-exiftool
- bat

### File HEX value display
- hexyl
- bat

### Hiden file extract
<img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/8fcd7be1-c610-4cd2-9000-4a8c8e2d79b0" />

- ``` yay -S binwalk wl-clipboard xclip ```
  ! will show the result then optional to copy the result/ extract all/ extract selected
