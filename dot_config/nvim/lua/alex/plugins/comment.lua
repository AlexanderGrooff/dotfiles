return {
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup({
				padding = true,
				toggler = {
					line = "<leader>/",
					block = "<leader>\"",
				},
				-- Add comment string support for more languages
				pre_hook = function(ctx)
					-- Only calculate commentstring for tsx filetypes
					if vim.bo.filetype == 'typescriptreact' then
						local U = require('Comment.utils')
						return require('ts_context_commentstring.utils').calculate_commentstring({
							key = ctx.ctype == U.ctype.line and '__default' or '__multiline'
						})
					end
				end,
			})
		end
	}
}
-- 