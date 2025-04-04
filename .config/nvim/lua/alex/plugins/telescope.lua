return {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		local t = require("telescope.builtin")
		vim.keymap.set("n", "<leader>fF", t.find_files, {})
		vim.keymap.set("n", "<leader>ff", t.git_files, {})
		vim.keymap.set("n", "<leader>t", t.buffers, {})
		vim.keymap.set("n", "<leader>fg", t.buffers, {})
		vim.keymap.set("n", "<C-t>", t.git_files, {})
	end
}
