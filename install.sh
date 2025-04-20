#!/usr/bin/env zsh

echo -e '\n\n\n\n\n\n\n\n\n\n'
if [ -f banner.txt ]; then
    cat banner.txt
else
    echo "========== DOTFILES INSTALLER =========="
fi
echo -e '\n\n\n\n\n\n\n\n\n\n'

# unalias date just in case
unalias date 2>/dev/null || true

date=$(date +%d_%m_%Y)
mkdir -p bkp
bkpDir="bkp/dotfiles-${date}"

cd "$HOME" || { echo "Failed to change to home directory"; exit 1; }

mkdir -p "${bkpDir}"
echo "Backing up overridden dotfiles in ${bkpDir}"

# The find command can hang when searching for hidden files
# Using a more targeted approach
echo "Finding files to backup..."

if [[ "$OSTYPE" == darwin* ]]; then
    # macOS - use a safer approach
    dotfiles=(.zshrc .vimrc .bashrc .bash_profile .gitconfig .tmux.conf .ideavimrc)
    for file in "${dotfiles[@]}"; do
        if [ -f "$HOME/$file" ]; then
            echo "Backing up $file"
            mv "$HOME/$file" "${bkpDir}/" 2>/dev/null || true
        fi
    done
else
    # GNU (Linux) - use a safer approach
    dotfiles=(.zshrc .vimrc .bashrc .bash_profile .gitconfig .tmux.conf .ideavimrc)
    for file in "${dotfiles[@]}"; do
        if [ -f "$HOME/$file" ]; then
            echo "Backing up $file"
            mv "$HOME/$file" "${bkpDir}/" 2>/dev/null || true
        fi
    done
fi

# Configure Neovim
mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/.vim ~/.config/nvim
ln -sf ~/dotfiles/.vimrc ~/.config/nvim/init.vim

if [ $? -ne 0 ]; then
    echo 'LINKING NVIM config to an existing config failed. Ignored.'
fi

# Symlink all dotfiles
ln -sf dotfiles/.vimrc dotfiles/.vimrc.completion dotfiles/.vimrc.conf dotfiles/.vimrc.conf.base dotfiles/.vimrc.filetypes dotfiles/.vimrc.maps dotfiles/.vimrc.plugin dotfiles/.vimrc.plugin.extended .
ln -sf dotfiles/.vimrc.maps .ideavimrc
ln -sf dotfiles/.zshenv dotfiles/.zshrc dotfiles/.zshrc-e dotfiles/.zshrc.alias dotfiles/.zshrc.local .

echo "\ndotfiles are linked!"

echo "Do you want to setup your environment? (y/n)"
read -r setup

if [[ "$setup" != "y" ]]; then
    exit 0
fi

cd ~/dotfiles || { echo "Failed to change to dotfiles directory"; exit 1; }

echo "Do you want to configure git user and email? (y/n)"
read -r gituser

if [[ "$gituser" = "y" ]]; then
    echo "What is your name?"
    read -r gitname

    echo "What is your email?"
    read -r gitemail

    cat >> ~/.gitconfig << EOF
[user]
    name = ${gitname}
    email = ${gitemail}
EOF
    echo "Git user configured."
fi

echo "Do you wish to install neobundle? (y/n)"
read -r neobundle

if [[ "$neobundle" = "y" ]]; then
    echo "Installing neobundle..."
    curl -fsSL https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > /tmp/install.sh
    sh /tmp/install.sh
fi

echo "Install oh-my-zsh? (y/n)"
read -r ohmyzsh

if [[ "$ohmyzsh" = "y" ]]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash)"
fi

if [[ "$OSTYPE" == darwin* ]]; then
    echo "Checking if Homebrew is installed..."
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash)"
    else
        echo "Homebrew already installed."
    fi

    echo "Install brew dependencies? (y/n)"
    read -r brew

    if [[ "$brew" = "y" ]]; then
        echo "Updating Homebrew and installing dependencies..."
        brew update
        brew install nvm neovim fzf the_silver_searcher thefuck
    fi
fi

echo "You can install Vim/Neovim plugins now or next time you start the editor"
echo "Install vim/neovim plugins now? (y/n)"

read -r vimplugins

if [[ "$vimplugins" = "y" ]]; then
    echo "Installing vim/neovim bundles..."
    vim -c ":NeoBundleInstall" -c ":q" -c ":q"
fi

echo "Install Solarized8 color scheme? (y/n)"
read -r solarized8

if [[ "$solarized8" = "y" ]]; then
    echo "Installing solarized8..."
    git clone https://github.com/lifepillar/vim-solarized8.git /tmp/vim-solarized8
    mkdir -p ~/.vim/colors 2>/dev/null
    cp /tmp/vim-solarized8/colors/*.vim ~/.vim/colors/
    rm -rf /tmp/vim-solarized8
fi

echo "Download FiraCode font? (y/n)"
read -r firacode

if [[ "$firacode" = "y" ]]; then
    echo "Downloading FiraCode font. Don't forget to install the version you like"
    curl -L https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip --output FiraCode.zip

    if [[ "$OSTYPE" == darwin* ]]; then
        echo "To install on macOS, unzip and double-click each font file"
    else
        echo "To install on Linux, unzip and copy to ~/.local/share/fonts/, then run fc-cache -f -v"
    fi
fi

echo -e "\n\nSetup complete! Restart your terminal to apply changes."
