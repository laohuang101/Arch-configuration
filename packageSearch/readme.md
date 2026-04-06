# Simple File/ Package Manager/ Music player (Noctalia Plugin)
## Use for
- Folder extract
- File open (only office, vscode)
- Hidden file check and extract (binwalk)
- Hex value check and edit (hexyl, cutter)
- Music Player (Music Search plug in)



## Package required summary
```
sudo yay -S rofi fzf kitty fish mpv yt-dlp jq unzip tar p7zip code perl-image-exiftool hexyl binwalk wl-clipboard xclip bat rz-cutter onlyoffice-bin 
```

------
## Dependency: 
- Rofi (configuration from adi1090x theme-6 style-6)
- fzf
- kitty (or other terminal)
- Black Arch repo (optional)

### Noctalia plugin 
- ``` Music Search ``` (https://noctalia.dev/plugins/music-search/) 
  - use with ``` rofi-music.sh ``` can search music using rofi
  - default using noctalia build in app launcher, use the script to change using rofi
  
  - ``` sudo pacman -S mpv yt-dlp jq ```

## File browser (extract, open files using vscode, only office (supported file only), check meta data, hex value and find hiden files)
<img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/a84cd7e4-ef3d-4f0b-8bdb-c18aac294473" />

- use with ``` rofi-browser.sh ```

- ``` sudo pacman -S unzip tar p7zip code ```

### File meta data display
- perl-image-exiftool
- bat

### File HEX value display
<img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/7e6d06bd-06f2-4aa8-992f-3bda4b267e46" />

- hexyl
- rz-cutter
- bat

### Hiden file extract
<img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/8fcd7be1-c610-4cd2-9000-4a8c8e2d79b0" />

- ``` yay -S binwalk wl-clipboard xclip ```
- will show the result then optional to copy the result/ extract all/ extract selected
