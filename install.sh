#!/bin/zsh

date   = `date +%Y-%m-%d_%H-%M`
bkpDir = "~/bkp/dotfiles-${date}"

mkdir -p $bkpDir
echo "Backing up overriden dotfiles in ${bkpDir}"

cd ~/dotfiles

for i in `find .* -depth 0 -type f`; do
    mv ~/${i} ${bkpDir} > /dev/null 2>&1
    ln -s ~/dotfiles/${i} ~/${i}
done

# Takes care of this big gotcha using neovim..
`ln -s ~/.vim ~/.config/nvim || ln -s ~/.vimrc ~/.config/nvim/init.vim` > 2>/dev/null
if [ $? -ne 0 ]; then echo 'LINKING NVIM config to an existing config failed. Ignore '; fi


echo "dotfiles are linked!"
echo "Please review ~/.vimrc.bundles.local for extra packages that are not installed"
