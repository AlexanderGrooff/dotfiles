return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			
			wk.setup({
				plugins = {
					marks = true,
					registers = true,
					spelling = {
						enabled = true,
						suggestions = 20,
					},
					presets = {
						operators = false,
						motions = true,
						text_objects = true,
						windows = true,
						nav = true,
						z = true,
						g = true,
					},
				},
				operators = { gc = "Comments" },
				key_labels = {
					["<space>"] = "SPC",
					["<cr>"] = "RET",
					["<tab>"] = "TAB",
				},
				motions = {
					count = true,
				},
				icons = {
					breadcrumb = "»",
					separator = "➜",
					group = "+",
				},
				popup_mappings = {
					scroll_down = "<c-d>",
					scroll_up = "<c-u>",
				},
				window = {
					border = "rounded",
					position = "bottom",
					margin = { 1, 0, 1, 0 },
					padding = { 1, 2, 1, 2 },
					winblend = 0,
					zindex = 1000,
				},
				layout = {
					height = { min = 4, max = 25 },
					width = { min = 20, max = 50 },
					spacing = 3,
					align = "left",
				},
				ignore_missing = true,
				hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " },
				show_help = true,
				show_keys = true,
				triggers = "auto",
				triggers_nowait = {
					"`",
					"'",
					"g`",
					"g'",
					'"',
					"<c-r>",
					"z=",
				},
				triggers_blacklist = {
					i = { "j", "k" },
					v = { "j", "k" },
				},
				disable = {
					buftypes = {},
					filetypes = {},
				},
			})

			-- Register key groups and descriptions
			wk.register({
				["<leader>f"] = { name = "Find/Search" },
				["<leader>g"] = { name = "Git" },
				["<leader>s"] = { name = "Search/Replace" },
				["<leader>v"] = { name = "LSP" },
				["<leader>w"] = { name = "Workspace" },
				["<leader>c"] = { name = "Code" },
				["<leader>d"] = { name = "Debug" },
				["<leader>t"] = { name = "Terminal/Tabs" },
				["<leader>p"] = { name = "Plugin/Project" },
				["<leader>e"] = "File Explorer",
				["<leader>E"] = "Focus Explorer",
				["<leader>r"] = "Reload Config",
				["<leader>/"] = "Comment Line",
				["<leader>\""] = "Comment Block",
				["<leader>y"] = "Copy to System",
				["<leader>Y"] = "Copy Line to System",
			})

			-- File/Search mappings
			wk.register({
				["<leader>f"] = {
					name = "Find/Search",
					f = "Git Files",
					F = "All Files", 
					g = "Live Grep",
					w = "Find Word",
					b = "Buffer Search",
					r = "References",
					s = "Document Symbols",
					S = "Workspace Symbols",
					d = "Diagnostics",
					h = "Help Tags",
					m = "Marks",
					o = "Recent Files",
					c = "Commands",
					k = "Keymaps",
					q = "Quickfix",
					l = "Location List",
				}
			})

			-- Git mappings  
			wk.register({
				["<leader>g"] = {
					name = "Git",
					-- Telescope git pickers
					c = "Commits (Telescope)",
					b = "Branches (Telescope)", 
					s = "Status (Telescope)",
					-- Fugitive commands
					G = "Git Status (Fugitive)",
					d = "Git Diff",
					l = "Git Log",
					p = "Git Push",
					P = "Git Pull",
					a = "Git Add Current File",
					A = "Git Add All",
					co = "Git Checkout",
					cm = "Git Commit",
					bl = "Git Blame",
					-- Diffview commands
					D = "Open Diffview",
					H = "File History (All)",
					h = "Current File History",
					R = "Refresh Diffview",
					X = "Close Diffview",
					-- Neogit commands
					g = "Open Neogit",
				}
			})

			-- LSP mappings (from your autocmd.lua)
			wk.register({
				["<leader>v"] = {
					name = "LSP",
					d = "Diagnostics Float",
					ws = "Workspace Symbol",
					ca = "Code Action",
					rr = "References", 
					rn = "Rename",
				}
			})

			-- Search/Replace mappings
			wk.register({
				["<leader>S"] = "Toggle Spectre",
				["<leader>s"] = {
					name = "Search/Replace",
					w = "Search Word",
					p = "Search in File",
				}
			})

			-- Plugin mappings
			wk.register({
				["<leader>p"] = {
					name = "Plugin/Project",
					m = "Mason",
					v = "File Manager",
				}
			})

			-- Buffer navigation
			wk.register({
				["<leader>t"] = "Find Buffers",
			})

			-- Common vim mappings with descriptions
			wk.register({
				g = {
					name = "Go to",
					d = "Definition",
				},
				["["] = {
					name = "Previous",
					d = "Diagnostic",
				},
				["]"] = {
					name = "Next", 
					d = "Diagnostic",
				},
				K = "Hover Documentation",
			})
		end,
	},
}
