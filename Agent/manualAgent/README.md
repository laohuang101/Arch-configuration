# ai
- fish command ``` ai <file (optional)> <prompt>```
- run using `ollama` can check out ollama free model here: https://ollama.com/search
- no need complex setup just copy the file to your fish configuraton folder
 
# Dependency
```
sudo pacman -S --needed tesseract tesseract-data-eng perl-image-exiftool binwalk ffmpeg poppler wireshark-cli pandoc binutils ollama
yay -S xlsx2csv catdoc
ollama pull qwen2.5-coder:7b
```
- The model can be change to any model you want

- By using this can upload img, files and pass the result to the model and let the AI to read your input

- Currently support:
  - jpg
  - jpeg
  - png
  - bmp
  - pcap
  - pcapng
  - nix
  - py
  - c
  - cpp
  - js
  - ts
  - rs
  - go
  - java
  - md
  - txt
  - csv
  - json 

# Dependency Usage
| Dependency | Usage |
| ------ | ------|
| tesseract |  |
| tesseract-data-eng |  |
| perl-image-exiftool |  |
| binwalk |  |
| ffmpeg |  |
| poppler |  |
| wireshark-cli | To analyze `.pcap` files |
| pandoc |  |
| binutils |  |
| ollama | pulling local model can use `llama.cpp` or others |
