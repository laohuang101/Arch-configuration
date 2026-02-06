function wpin
    read -p 'echo "Enter Website URL (e.g., https://youtube.com): "' url
    if test -z "$url"
        echo "URL cannot be empty."
        return
    end
    # This launches the URL in 'app' mode which creates a standalone window
    # To 'install' it permanently to your menu, we use the --app flag
    google-chrome --app=$url &
    echo "Launched $url in App Mode. Use the browser menu to 'Save as App' for a menu entry."
end
