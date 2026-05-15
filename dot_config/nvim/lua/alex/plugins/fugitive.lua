return {
	{
		"tpope/vim-fugitive",
		config = function()
			-- Keymaps for fugitive
			vim.keymap.set("n", "<leader>G", ":Git<CR>", { desc = "Git Status" })
			vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit<CR>", { desc = "Git Diff" })
			vim.keymap.set("n", "<leader>gl", ":Git log --oneline<CR>", { desc = "Git Log" })
			vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git Push" })
			vim.keymap.set("n", "<leader>gP", ":Git pull<CR>", { desc = "Git Pull" })
			vim.keymap.set("n", "<leader>ga", ":Git add %<CR>", { desc = "Git Add Current File" })
			vim.keymap.set("n", "<leader>gA", ":Git add .<CR>", { desc = "Git Add All" })
			vim.keymap.set("n", "<leader>gco", ":Git checkout ", { desc = "Git Checkout" })
			vim.keymap.set("n", "<leader>gcm", ":Git commit<CR>", { desc = "Git Commit" })
			vim.keymap.set("n", "<leader>gbl", ":Git blame<CR>", { desc = "Git Blame" })
		end
	}
}
