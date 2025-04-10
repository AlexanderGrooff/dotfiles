-- Basics before loading plugins. All plugin-related remaps should go in after
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>r", function()
	vim.cmd("source $MYVIMRC")
	vim.notify("Reloaded init.lua", vim.log.levels.INFO)
end, { desc = "Reload Neovim config" })

vim.keymap.set("n", "<C-q>", function()
	local ok = pcall(vim.cmd.x)
	if not ok then
		vim.cmd.q({ bang = true })  -- equivalent to :q!
	end
end, { desc = "Save and quit, force quit if save fails" })

-- Keep cursor in middle of screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Delete without overriding registry
vim.keymap.set("x", "<leader>p", [["_dP]])
-- Copy to system buffer
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
