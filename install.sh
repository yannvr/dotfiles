#!/bin/zsh

date=`date +%Y-%m-%d_%H-%M`
bkpDir="~/bkp/dotfiles-${date}"
mkdir -p $bkpDir
echo "Backing up overriden dotfiles in ${bkpDir}"

cd ~/dotfiles

for i in `find .* -depth 0 -type f`; do
    mv ~/${i} ${bkpDir}
    ln -s ~/dotfiles/${i} ~/${i}
done
