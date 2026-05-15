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

		-- File pickers
		map("<leader>fF", builtin.find_files, { desc = "Find files" })
		map("<leader>ff", function() builtin.git_files({ show_untracked = true }) end, { desc = "Find git files" })
		map("<C-t>", function()
			local ok, _ = pcall(builtin.git_files, { show_untracked = true })
			if not ok then
				builtin.find_files()
			end
		end, { desc = "Find files (git aware)" })

		-- Search pickers
		map("<leader>fg", builtin.live_grep, { desc = "Live grep" })
		map("<leader>fw", builtin.grep_string, { desc = "Find word under cursor" })
		map("<leader>fb", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy find in current buffer" })

		-- Buffer pickers
		map("<leader>t", builtin.buffers, { desc = "Find buffers" })

		-- LSP pickers
		map("<leader>fr", builtin.lsp_references, { desc = "Find references" })
		map("<leader>fs", builtin.lsp_document_symbols, { desc = "Find document symbols" })
		map("<leader>fS", builtin.lsp_workspace_symbols, { desc = "Find workspace symbols" })
		map("<leader>fd", builtin.diagnostics, { desc = "Find diagnostics" })

		-- Git pickers
		map("<leader>gc", builtin.git_commits, { desc = "Git commits" })
		map("<leader>gb", builtin.git_branches, { desc = "Git branches" })
		map("<leader>gs", builtin.git_status, { desc = "Git status" })

		-- Vim pickers
		map("<leader>fh", builtin.help_tags, { desc = "Find help" })
		map("<leader>fm", builtin.marks, { desc = "Find marks" })
		map("<leader>fo", builtin.oldfiles, { desc = "Find recent files" })
		map("<leader>fc", builtin.commands, { desc = "Find commands" })
		map("<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
		map("<leader>fq", builtin.quickfix, { desc = "Find quickfix" })
		map("<leader>fl", builtin.loclist, { desc = "Find location list" })
	end
}
