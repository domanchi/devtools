if [[ ! `which brew` ]]; then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL "\
        "https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
