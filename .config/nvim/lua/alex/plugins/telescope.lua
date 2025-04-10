return {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		-- Setup telescope first
		telescope.setup({
			defaults = {
				path_display = { "truncate" },
			},
		})

		-- Then set up keymaps
		local function map(key, fn, opts)
			if fn then
				vim.keymap.set("n", key, fn, opts or {})
			end
		end

		map("<leader>fF", builtin.find_files)
		map("<leader>ff", function() builtin.git_files({ show_untracked = true }) end)
		map("<leader>t", builtin.buffers)
		map("<leader>fg", builtin.live_grep)
		map("<C-t>", function()
			local ok, _ = pcall(builtin.git_files, { show_untracked = true })
			if not ok then
				builtin.find_files()
			end
		end)
	end
}
