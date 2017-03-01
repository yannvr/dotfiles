#!/usr/bin/env zsh

echo -e '\n\n\n\n\n\n\n\n\n\n'
cat banner.txt
echo -e '\n\n\n\n\n\n\n\n\n\n'

# unalias date just in case
unalias date 2&>1 > /dev/null

date=`date +%d_%m_%Y`
bkpDir="~/bkp/dotfiles-${date}"


mkdir -p ${bkpDir}
echo "Backing up overriden dotfiles in ${bkpDir}"

if [[ "$OSTYPE" == darwin* ]]; then
    listFilesCmd=`find .* -depth 0 -type f`
else
    #GNU (linux)
    listFilesCmd=`find .* -maxdepth 0 -type f`
fi

for i in $listFilesCmd; do
    mv ~/${i} ${bkpDir} 2&>1 > /dev/null
    cp ${i} ~/${i} 2&>1 > /dev/null
done

# Takes care of this big gotcha using neovim..
ln -s ~/.vim ~/.config/nvim 2&>1 > /dev/null
ln -s ~/.vimrc ~/.config/nvim/init.vim 2&>1 > /dev/null

if [ $? -ne 0  ]; then echo 'LINKING NVIM config to an existing config failed. Ignore '; fi

echo "\ndotfiles are linked!"

echo "Do you want to setup your environment? (y/n)"
read setup

if [ $setup != 'y' ]; then
    exit 0
fi

cd ~/dotfiles

echo "Do you want to author git commit with mail and name? (y/n)"
read gituser

if [ $gituser = 'y' ]; then

    echo "What is your name? (y/n)"
    read gitname

    echo "What is your email? (y/n)"
    read gitemail

    cat >> ~/.gitconfig << EOF
[user]
    name = ${gitname}
    email = ${gitemail}
EOF

fi

echo "Do you wish to install neobundle? (y/n)"
read neobundle

if [ $neobundle = 'y' ]; then
    curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > /tmp/install.sh;
    sh /tmp/install.sh
fi

echo "Install oh-my-zsh? (y/n)"
read ohmyzsh

if [ $ohmyzsh = 'y' ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi


if [[ "$OSTYPE" == darwin* ]]; then
    listFilesCmd=`find .* -depth 0 -type f`
    echo "Install brew dependencies? (y/n)"
    read brew

    if [ $brew = 'y' ]; then
        brew update
        brew install nvm
        brew install neovim
        brew install fzf
        brew install ag
    fi

    # TODO: Install brews and osx default setting

    # echo "Do you want to fix some annoying osx default settings (y/n)"
    # read osx

    # if [ $osx = 'y' ]; then
    #     echo "Installing minor osx default settings"
    #     git clone https://github.com/lifepillar/vim-solarized8.git/ /tmp/vim-solarized8
    #     mkdir ~/.vim/colors 2&>1 > /dev/null
    #     mv /tmp/vim-solarized8/colors/*.vim ~/.vim/colors
    # fi
fi

echo "You can install Vim/Neovim plugins now or next time you unleash the beast"
echo "Install vim/neovim plugins now? (y/n)"

read vimplugins

if [ $vimplugins = 'y' ]; then
    echo "Installing vim/neovim bundles.."
    vim -c :NeoBundleInstall
fi

echo "Install Solarized8 (true colors)? (y/n)"

read solarized8

if [ $solarized8 = 'y' ]; then
    echo "Installing solarized8"
    git clone https://github.com/lifepillar/vim-solarized8.git/ /tmp/vim-solarized8
    mkdir ~/.vim/colors 2&>1 > /dev/null
    mv /tmp/vim-solarized8/colors/*.vim ~/.vim/colors
fi

echo -e "\n\nIt's Jagertime!"
