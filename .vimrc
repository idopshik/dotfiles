"Put this file in your home dir as .vimrc
"or as _vimrc if it's windows
" I think that for windows everyting here must be changed

 set runtimepath+=~/.vim_runtime

 source ~/.vim_runtime/vimrcs/filetypes.vim
 source ~/.vim_runtime/vimrcs/plugins_config.vim
 source ~/.vim_runtime/vimrcs/extended.vim
 source ~/.vim_runtime/vimrcs/basic.vim
 source ~/.vim_runtime/vimrcs/styling.vim
 source ~/.vim_runtime/vimrcs/keymap.vim
 source ~/.vim_runtime/vimrcs/pimo.vim
 source ~/.vim_runtime/vimrcs/quickmenu.vim
 source ~/.vim_runtime/vimrcs/autocommands.vim
 source ~/.vim_runtime/vimrcs/fold.vim

 try
 source ~/.vim_runtime/my_configs.vim
 catch
 endtry

