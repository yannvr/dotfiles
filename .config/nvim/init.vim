set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Load Lua configuration
lua require('init')

" Python provider setup
let g:python3_host_prog = '/usr/bin/python3'

" Only load essential settings, not the plugin file
" source ~/.vimrc.filetypes
" source ~/.vimrc.conf.base
" source ~/.vimrc.completion
" source ~/.vimrc.conf
" source ~/.vimrc.maps
