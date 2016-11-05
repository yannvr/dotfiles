#!/bin/zsh
#TODO: Input git author settings, don't hardcode it!

date=`date +%d_%m_%Y`
bkpDir="~/bkp/dotfiles-${date}"

mkdir -p ${bkpDir}
echo "Backing up overriden dotfiles in ${bkpDir}"

cd ~/dotfiles

echo "Do you wish to install neobundle?"
read neobundle

if [ $neobundle = 'y' ]; then
    curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > /tmp/install.sh;
    sh /tmp/install.sh
fi

echo "Install oh-my-zsh?"
read ohmyzsh

if [ $ohmyzsh = 'y' ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi


echo "Install brew dependencies?"
read brew

if [ $brew= 'y' ]; then
    brew update
    brew install nvm
    brew install neovim
    brew install fzf
    brew install ag
fi

for i in `find .* -depth 0 -type f`; do
    mv ~/${i} ${bkpDir}
    ln -s ~/dotfiles/${i} ~/${i}
done

# Takes care of this big gotcha using neovim..
`ln -s ~/.vim ~/.config/nvim`
`ln -s ~/.vimrc ~/.config/nvim/init.vim`
if [ $? -ne 0  ]; then echo 'LINKING NVIM config to an existing config failed. Ignore '; fi

echo "dotfiles are linked!"

echo "Installing vim/neovim bundles.."
vim -c :NeoBundleInstall
