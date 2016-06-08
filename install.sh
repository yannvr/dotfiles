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

echo "dotfiles are linked!"
echo "Please review ~/.vimrc.bundles.local for extra packages that are not installed"
