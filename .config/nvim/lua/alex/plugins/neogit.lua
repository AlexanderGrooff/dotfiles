return {
	{
		"TimUntersberger/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim", -- optional - Diff integration
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = function()
			local neogit = require("neogit")
			
			neogit.setup({
				disable_signs = false,
				disable_hint = false,
				disable_context_highlighting = false,
				disable_commit_confirmation = false,
				auto_refresh = true,
				sort_branches = "-committerdate",
				disable_builtin_notifications = false,
				use_magit_keybindings = false,
				-- customize displayed signs
				signs = {
					-- { CLOSED, OPENED }
					section = { ">", "v" },
					item = { ">", "v" },
					hunk = { "", "" },
				},
				integrations = {
					diffview = true,
					telescope = true,
				},
				-- Setting any of these to `true` will disable the popup menu for certain commands
				disable_insert_on_commit = "auto",
				filewatcher = {
					interval = 1000,
					enabled = true,
				},
				git_services = {
					["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
					["bitbucket.org"] = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
					["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
				},
				telescope_sorter = function()
					return require("telescope").extensions.fzf.native_fzf_sorter()
				end,
				-- Persist the values of switches/options within and across sessions
				remember_settings = true,
				-- Scope persisted settings on a per-project basis
				use_per_project_settings = true,
				-- Array-like table of settings to never persist. Uses format "Filetype--cli-value"
				ignored_settings = {
					"NeogitPushPopup--force-with-lease",
					"NeogitPushPopup--force",
					"NeogitPullPopup--rebase",
					"NeogitCommitPopup--allow-empty",
					"NeogitRevertPopup--no-edit",
				},
				-- Change the default way of opening neogit
				kind = "tab",
				-- The time after which an output console is shown for slow running commands
				console_timeout = 2000,
				-- Automatically show console if a command takes more than console_timeout milliseconds
				auto_show_console = true,
			})

			-- Keymaps
			vim.keymap.set("n", "<leader>gg", neogit.open, { desc = "Open Neogit" })
			vim.keymap.set("n", "<leader>gc", function() neogit.open({"commit"}) end, { desc = "Open Neogit Commit" })
		end,
	},
}
