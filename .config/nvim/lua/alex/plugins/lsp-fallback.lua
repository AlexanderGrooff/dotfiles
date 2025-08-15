-- Fallback LSP configuration for corporate environments
-- This sets up LSP servers that might be available system-wide
-- without requiring Mason installation

return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local cmp_lsp = require("cmp_nvim_lsp")
			
			-- Common capabilities
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				cmp_lsp.default_capabilities()
			)

			-- Function to check if command exists
			local function command_exists(cmd)
				local handle = io.popen("which " .. cmd .. " 2>/dev/null")
				if handle then
					local result = handle:read("*a")
					handle:close()
					return result ~= ""
				end
				return false
			end

			-- Setup Lua LSP if available
			if command_exists("lua-language-server") then
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim" } },
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							telemetry = { enable = false },
						},
					},
				})
			end

			-- Setup Python LSP if available
			if command_exists("pyright") then
				lspconfig.pyright.setup({ capabilities = capabilities })
			elseif command_exists("pylsp") then
				lspconfig.pylsp.setup({ capabilities = capabilities })
			end

			-- Setup Go LSP if available
			if command_exists("gopls") then
				lspconfig.gopls.setup({ capabilities = capabilities })
			end

			-- Setup TypeScript/JavaScript LSP if available
			if command_exists("typescript-language-server") then
				lspconfig.tsserver.setup({ capabilities = capabilities })
			end

			-- Setup Bash LSP if available
			if command_exists("bash-language-server") then
				lspconfig.bashls.setup({ capabilities = capabilities })
			end
		end,
	},
}
