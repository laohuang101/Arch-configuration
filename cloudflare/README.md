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
curl -L ipconfig.me
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

- Checking WARP connection endpoint
```
curl -s https://www.cloudflare.com/cdn-cgi/trace | grep colo
```

- Check endpoint delay and package loss
```
wget -N https://gitlab.com/Misaka-blog/warp-script/-/raw/main/files/warp-yxip/warp-yxip.sh
chmod +x warp-yxip.sh
./warp-yxip.sh
```

-Changing EndPoint
```
warp-cli disconnect
warp-cli set-custom-endpoint <ip>:<port>
warp-cli connect
```
exp: ```warp-cli set-custom-endpoint 188.114.96.183:5279```
