function rd
    set -l input $argv[1]
    
    # --- 1. INTERACTIVE PICKER (If no input provided) ---
    if test (count $argv) -eq 0
        set -l picked_file (fd -t f | fzf --ansi --height 20% --reverse \
                            --header "Select File (Right=Open / Left=Exit)" \
                            --bind "left:abort,right:accept")
        if test -n "$picked_file"
            rd "$picked_file"
        end
        return
    end
    
    # --- 2. FILE LOGIC (Priority Check) ---
    if test -e "$input"
        set -l mime (file --mime-type -b "$input")
        
        # Action Menu for Files
        set -l action (printf "Default (Auto-Detect)\nVS Code (Editor)\nHex View (bat)" | \
                            fzf --height 10% --reverse --header "Action for $input:" --bind "left:abort,right:accept")
        
        if test -z "$action"; return; end
        
        if test "$action" = "VS Code (Editor)"
            code "$input"
            return
        end
        
        if test "$action" = "Hex View (bat)"
            bat "$input"
            return
        end
        
        # --- SPECIAL DATABASE VIEWER (.sqlite / .db) ---
        if string match -q "*.sqlite" "$input"; or string match -q "*.db" "$input"
            echo (set_color cyan)"Database File: $input"(set_color normal)
            set -l db_action (printf "List Tables (Quick)\nBrowse Data (CLI)\nOpen in DB Browser (GUI)" | \
                                    fzf --height 12% --reverse --header "DB Actions (Right=Select / Left=Back)" --bind "left:abort,right:accept")
            
            if test -z "$db_action"; return; end
            
            switch "$db_action"
                case "List Tables (Quick)"
                    sqlite3 "$input" ".tables"
                case "Browse Data (CLI)"
                    set -l table (sqlite3 "$input" ".tables" | tr ' ' '\n' | fzf --header "Select Table to View")
                    if test -n "$table"
                        sqlite3 -header -column "$input" "SELECT * FROM $table LIMIT 20;" | bat
                    end
                case "Open in DB Browser (GUI)"
                    sqlitebrowser "$input" & disown
            end
            return
        end
        
        # --- DEFAULT AUTO-DETECT MIME TYPES ---
        if string match -q "text/*" "$mime"; or string match -q "*json" "$mime"; or string match -q "*javascript" "$mime"
            code "$input"
        else if string match -q "application/vnd.tcpdump.pcap" "$mime"; or string match -q "application/x-pcapng" "$mime"
            wireshark "$input" & disown
        else if string match -q "application/x-executable" "$mime"; or string match -q "application/octet-stream" "$mime"
            r2 -A -c "Vpp" "$input"
        else
            bat "$input"
        end
        return
    end
    
    # --- 3. TARGET LAUNCHER (URL/IP/Domain) ---
    if string match -qr '(^https?://)|(^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$)|([a-z0-9.-]+\.[a-z]{2,6}(:[0-9]+)?$)' "$input"
        while true
            set -l tool (printf "Nmap (Scan)\nSqlmap (Auto Exploit)\nSqlmap (Custom Scan)\nFfuf (Fuzz)\nOpen in VS Code\nWhois (Info)\nExit" | \
                                    fzf --height 20% --reverse \
                                    --header "Target: $input (Right=Select / Left=Exit)" \
                                    --bind "left:abort,right:accept")
            
            if test -z "$tool" -o "$tool" = "Exit"; break; end
            
            # Smart URL formatting
            set -l web_url "$input"
            if not string match -qr '^https?://' "$web_url"
                set web_url "http://$web_url"
            end
            
            switch "$tool"
                case "Nmap (Scan)"
                    set -l nmap_target (string replace -r '^https?://' '' "$input" | string replace -r '/.*$' '')
                    nmap -sV -sC "$nmap_target"

                case "Sqlmap (Auto Exploit)"
                    # --- IMPROVED SQLMAP LOGIC ---
                    if string match -q "*?*" "$web_url"
                        echo (set_color yellow)"[*] Parameters found. Running Level 3 scan..."(set_color normal)
                        sqlmap -u "$web_url" --batch --random-agent --level=3 --risk=2 --dbs
                    else
                        echo (set_color red)"[!] No URL parameters. Triggering Aggressive Form Scan (Lvl 5, Risk 3)..."(set_color normal)
                        # This handles login pages and password fields
                        sqlmap -u "$web_url" --forms --batch --random-agent --level=5 --risk=3 --dbs
                    end

                case "Sqlmap (Custom Scan)"
                    echo (set_color cyan)"Enter extra sqlmap flags (e.g., --data='user=a' --dump):"(set_color normal)
                    read -l custom_flags
                    sqlmap -u "$web_url" $custom_flags

                case "Ffuf (Fuzz)"
                    set -l wordlist (fd . /usr/share/seclists/ -e txt -e lst -e conf | \
                                                    fzf --height 25% --reverse \
                                                    --header "SecLists Picker (Right=Select / Left=Back)" \
                                                    --bind "left:abort,right:accept")
                    
                    if test -n "$wordlist"
                        ffuf -u "$web_url/FUZZ" -w "$wordlist"
                    else
                        continue
                    end

                case "Open in VS Code"
                    code --new-window "$input"

                case "Whois (Info)"
                    set -l domain (string replace -r '^https?://' '' "$input" | string replace -r '(:|/).*$' '')
                    whois "$domain" | bat
            end
            
            echo (set_color grey)"\n--- Task Done. Press Enter for menu ---"(set_color normal)
            read -l confirm
        end
    else
        echo (set_color red)"Error: '$input' not found and not a valid URL!"(set_color normal)
    end
end