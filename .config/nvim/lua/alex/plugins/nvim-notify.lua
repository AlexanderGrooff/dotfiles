return {
	{
		"rcarriga/nvim-notify",
		config = function()
			local notify = require("notify")
			
			-- Configure nvim-notify
			notify.setup({
				-- Animation style
				stages = "fade_in_slide_out",
				
				-- Render function
				render = "default",
				
				-- Default timeout for notifications
				timeout = 3000,
				
				-- Max number of columns for messages
				max_width = 60,
				
				-- Max number of lines for a message
				max_height = 5,
				
				-- Minimum width for notification windows
				minimum_width = 20,
				
				-- Icons for different log levels
				icons = {
					DEBUG = "",
					ERROR = "",
					INFO = "",
					TRACE = "✎",
					WARN = ""
				},
				
				-- Whether or not to position the notifications at the top or not
				top_down = true,
			})
			
			-- Set nvim-notify as the default notification handler
			vim.notify = notify
		end
	}
}
