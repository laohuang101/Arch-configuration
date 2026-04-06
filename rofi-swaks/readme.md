# Simple File/ Package Manager/ Music player (Noctalia Plugin)
## Use for
- Folder extract
- File open (only office, vscode)
- Hidden file check and extract (binwalk)
- Hex value check and edit (hexyl, cutter)
- Music Player (Music Search plug in)
- Simple version of autopsy (can recover deleted files, check the mbac timeline and print out all the files in the selected partion)



## Package required summary
```
sudo yay -S rofi fzf kitty fish mpv yt-dlp jq unzip tar p7zip code perl-image-exiftool hexyl binwalk wl-clipboard xclip bat rz-cutter onlyoffice-bin wireshark-qt wireshark-cli sleuthkit scalpel testdisk less bzip2
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

### Disk forensic (autopsy not working)(support .gz and .bz2 extract and analyze)(support .img, .dd and .raw disk image)
<img width="1919" height="1080" alt="image" src="https://github.com/user-attachments/assets/bfee0076-03e9-42cb-a32e-a874d937f4ac" />


- Can use ``` testdisk ``` to see the deleted file
- build-in function using ``` TSK,  fls,  icat ``` to check the meta data of the partion (find the partion -> list down all the files -> select the file to recover) 
- In ``` rofi-browser.sh ``` have a build-in unzip then list all the folders in a text file function (``` Quick Extract & Analyze ```)
- Also a build-in generate Modify, Brith, Change, Access (mbca) function, auto open using ``` less ``` once generated
  - Inside can use ``` & ``` to filter
  - Auto using ``` -Si ``` (squeeze and ignore case) when the time stamp is generated and open


<img width="1919" height="1080" alt="image" src="https://github.com/user-attachments/assets/0c6a5004-3e98-4963-b51f-6860de5d27a8" />


the file with ``` * ``` is the deleted file can be recover
