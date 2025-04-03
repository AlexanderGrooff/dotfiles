call plug#begin()

Plug 'tpope/vim-sensible'      " sensible defaults such as backspace in insert mode
Plug 'tpope/vim-sleuth'        " set indentation based on current file
Plug 'junegunn/fzf'            "
Plug 'junegunn/fzf.vim'        " Adds :Files, :Buffers etc
Plug 'lewis6991/gitsigns.nvim' " Git in gutter

call plug#end()

" Keymappings; <Leader> is \
nnoremap <Leader>r :source ~/.config/nvim/init.vim<CR>
nnoremap <Leader><Leader>r :e ~/.config/nvim/init.vim<CR>
nnoremap <C-t> :Files<CR>
