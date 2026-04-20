function ai
    set config_dir ~/.config/fish/ai_data
    mkdir -p $config_dir
    set model_file $config_dir/model_pref
    set history_file $config_dir/history.log

    if test "$argv[1]" = "/model"
        ollama list; read -P "Set default model: " selected
        if test -n "$selected"; echo "$selected" > $model_file; end
        return 0
    else if test "$argv[1]" = "/clear"
        echo "" > $history_file; echo "🧹 History cleared."; return 0
    end

    if test -f $model_file; set model_name (cat $model_file); else; set model_name "qwen2.5-coder:7b"; end

    set target $argv[1]
    set extracted_data ""
    set task ""

    set recent_history ""
    if test -f $history_file
        set recent_history (tail -n 20 $history_file)
    end

    if test -e "$target"
        set task $argv[2..-1]
        if test -z "$task"; set task "Analyze and format this data"; end

        function _internal_extract
            set f $argv[1]
            set ext (string lower (string split -r -m1 . $f)[2])
            echo "--- SOURCE: $f ---"
            switch $ext
                case jpg jpeg png bmp
                    exiftool $f | head -n 10; tesseract $f stdout 2>/dev/null
                case pcap pcapng
                    tshark -r $f -T fields -e frame.number -e _ws.col.Protocol -e _ws.col.Info -c 50
                case nix py c cpp js ts rs go java md txt csv json
                    cat $f
                case '*'
                    if string match -q "text/*" (file --mime-type -b $f); cat $f; else; strings -n 10 $f | head -n 30; end
            end
            echo ""
        end

        if test -d $target
            for file in (find $target -type f -not -path '*/.*' | head -n 10)
                set extracted_data "$extracted_data"(_internal_extract $file)
            end
        else
            set extracted_data (_internal_extract $target)
        end
    else
        set task $argv[1..-1]
    end

    set system_prompt "You are a Markdown expert and technical analyzer. 
    RULE: Output RAW MARKDOWN content ONLY. 
    RULE: NO conversational filler. NO introductory phrases."

    set full_prompt "SYSTEM: $system_prompt
    RECENT_CONVERSATION: $recent_history
    DATA_CONTEXT: $extracted_data
    TASK: $task"

    set response (echo "$full_prompt" | ollama run $model_name | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")
    
    printf "%s\n" "$response"

    echo "User: $task" >> $history_file
    echo "Assistant: $response" >> $history_file
end