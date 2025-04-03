""" GENERAL SETTINGS
syntax on


""" PLUGINS
call plug#begin()

Plug 'tpope/vim-sensible'      " sensible defaults such as backspace in insert mode
Plug 'tpope/vim-sleuth'        " set indentation based on current file
Plug 'junegunn/fzf'            " Base library for FZF
Plug 'junegunn/fzf.vim'        " Adds :Files, :Buffers etc
Plug 'lewis6991/gitsigns.nvim' " Git in gutter

call plug#end()

" Load settings config from ~/.config/nvim/lua/plugins.lua
lua require('plugins')

""" KEYMAPPINGS
""" <Leader> is "\"
" vim config bindings
nnoremap <Leader>r :source ~/.config/nvim/init.vim<CR>
nnoremap <Leader><Leader>r :e ~/.config/nvim/init.vim<CR>

" FZF bindings
nnoremap <C-t> :Files<CR>
nnoremap <Leader>t :Buffers<CR>
