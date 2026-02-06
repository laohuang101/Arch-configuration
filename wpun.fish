function wpun
    # 1. Search all local desktop files for the word "chromium" in the Exec line
    # 2. Extract the file path and the Name of the app
    # 3. Format it so FZF shows the Name but knows the Path
    set -l selection (grep -l "Exec=.*chromium" ~/.local/share/applications/*.desktop | xargs grep -m 1 "^Name=" | string replace "Name=" "" | fzf --layout=reverse --header="Select Web App to Remove" --delimiter=":" --with-nth=2)
    
    if test -n "$selection"
        # Split the path from the name
        set -l file_to_delete (echo $selection | cut -d':' -f1)
        set -l app_name (echo $selection | cut -d':' -f2)
        
        # Remove the file
        rm "$file_to_delete"
        echo "Successfully removed: $app_name"
        sleep 1
    else
        echo "No Chromium web apps found in ~/.local/share/applications/"
    end
end
