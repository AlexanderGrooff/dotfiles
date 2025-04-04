-- Basics before loading plugins. All plugin-related remaps should go in after
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>r", function()
  vim.cmd("source $MYVIMRC")
  vim.notify("Reloaded init.lua", vim.log.levels.INFO)
end, { desc = "Reload Neovim config" })
--""" PLUGINS
--call plug#begin()
--
--Plug 'nvim-lua/plenary.nvim'   " basic library functions
--Plug 'tpope/vim-sensible'      " sensible defaults such as backspace in insert mode
--Plug 'tpope/vim-sleuth'        " set indentation based on current file
--Plug 'nvim-telescope/telescope.nvim' " Search with FZF
--Plug 'lewis6991/gitsigns.nvim' " Git in gutter
--Plug 'rose-pine/neovim'        " colorscheme
--
--call plug#end()
--
--" Load settings config from ~/.config/nvim/lua/plugins.lua
--lua require('plugins')
--
--""" GENERAL SETTINGS
--syntax on
--colorscheme rose-pine
--
--
--""" KEYMAPPINGS
--""" <Leader> is "\"
--" vim config bindings
--nnoremap <Leader>r :source ~/.config/nvim/init.vim<CR>
--nnoremap <Leader><Leader>r :e ~/.config/nvim<CR>
--
--" FZF bindings
--nnoremap <C-t> <cmd>:Telescope find_files<CR>
--nnoremap <Leader>t <cmd>:Telescope buffers<CR>
--
--" Personal keybinds
--nnoremap <C-q> :x<CR>
