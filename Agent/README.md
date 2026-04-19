# Ollama
## Installation
```
curl -fsSL https://ollama.com/install.sh | sh
sudo pacman -S nvidia nvidia-utils cuda
```
## Model
| Usage | Model | Command |
| ------ | ------ | ------ |
| Create Notes based on pdf | Llama 4 (8b) | ``` ollama run llama3.1:8b ``` or ``` ollama run gemma4:e4b ``` |
| Create Notes based on slides | Qwen2.5-VL (7b or 32b) | ``` ollama run qwen2.5-vl ``` |
| Analyze code (Thinking model) | DeepSeek-V3.2-Exp (7b) | ``` ollama run deepseek-v3.2-exp ``` |
| CTF | DeepSeek-Coder-V2-Lite (16b) | ``` ollama run deepseek-coder-v2:lite ``` |
| CTF (pcap or pwntools stuff) | Llama 3.1 / 4 (8b) | ``` ollama run llama3.1:8b ``` |
| Forensic | Qwen2.5-Coder (7b) | ``` ollama run qwen2.5-coder:7b ``` |

# Goose
## Installation
```
curl -fsSL https://github.com/aaif-goose/goose/releases/download/stable/download_cli.sh | bash
```

## Update
```
goose update
```

## Uninstall
```
npm uninstall -g @block/goose
```

# iflow-cli
```
bash -c "$(curl -fsSL https://cloud.iflow.cn/iflow-cli/install.sh)"
```

