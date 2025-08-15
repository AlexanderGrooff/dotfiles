return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require('lualine').setup({
				options = {
					icons_enabled = true,
					theme = 'tokyonight',
					component_separators = { left = '', right = '' },
					section_separators = { left = '', right = '' },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = true,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					}
				},
				sections = {
					lualine_a = {'mode'},
					lualine_b = {
						'branch',
						{
							'diff',
							symbols = { added = ' ', modified = ' ', removed = ' ' },
							diff_color = {
								added = { fg = '#98be65' },
								modified = { fg = '#ECBE7B' },
								removed = { fg = '#ec5f67' }
							}
						},
						{
							'diagnostics',
							sources = { 'nvim_diagnostic' },
							symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
							diagnostics_color = {
								error = { fg = '#ec5f67' },
								warn = { fg = '#ECBE7B' },
								info = { fg = '#008080' },
								hint = { fg = '#10B981' }
							}
						}
					},
					lualine_c = {
						{
							'filename',
							file_status = true,
							newfile_status = false,
							path = 1, -- 0: just filename, 1: relative path, 2: absolute path, 3: absolute path with ~ for home
							shorting_target = 40,
							symbols = {
								modified = '[+]',
								readonly = '[-]',
								unnamed = '[No Name]',
								newfile = '[New]',
							}
						}
					},
					lualine_x = {
						{
							'encoding',
							fmt = string.upper,
							cond = function()
								return vim.bo.fileencoding ~= 'utf-8'
							end
						},
						{
							'fileformat',
							icons_enabled = true,
							cond = function()
								return vim.bo.fileformat ~= 'unix'
							end
						},
						'filetype'
					},
					lualine_y = {'progress'},
					lualine_z = {'location'}
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {'filename'},
					lualine_x = {'location'},
					lualine_y = {},
					lualine_z = {}
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {'neo-tree', 'telescope', 'mason'}
			})
		end
	}
}
