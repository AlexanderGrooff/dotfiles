-- Fallback LSP configuration for corporate environments
-- This sets up LSP servers that might be available system-wide
-- without requiring Mason installation

-- Native LSP fallback that starts servers if they are available on PATH
-- No dependency on nvim-lspconfig
-- luacheck: globals vim
---@diagnostic disable: undefined-global


return {
	{
		-- Provide cmp capability integration only; server startup is native
		"hrsh7th/cmp-nvim-lsp",
		config = function()
			local cmp_lsp = require("cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				cmp_lsp.default_capabilities()
			)

			local function command_exists(cmd)
				local handle = io.popen("which " .. cmd .. " 2>/dev/null")
				if handle == nil then return false end
				local result = handle:read("*a")
				handle:close()
				return result ~= ""
			end

			local function find_root(patterns, startpath)
				local path = startpath
				if not path or path == "" then
					local bufname = vim.api.nvim_buf_get_name(0)
					path = (bufname ~= "" and vim.fs.dirname(bufname)) or vim.uv.cwd()
				end
				local found = vim.fs.find(patterns, { path = path, upward = true })[1]
				return found and vim.fs.dirname(found) or path
			end

			local function start_on_filetype(filetypes, cfg)
				vim.api.nvim_create_autocmd('FileType', {
					pattern = filetypes,
					callback = function(args)
						local buf = args.buf
						local bufname = vim.api.nvim_buf_get_name(buf)
						local startpath = (bufname ~= '' and vim.fs.dirname(bufname)) or vim.uv.cwd()
						local config = vim.tbl_deep_extend('force', cfg, {
							root_dir = cfg.root_dir or find_root(cfg.root_patterns or { '.git' }, startpath),
							capabilities = capabilities,
						})
						vim.lsp.start(config)
					end,
				})
			end

			-- Lua
			if command_exists('lua-language-server') then
				start_on_filetype({ 'lua' }, {
					name = 'lua_ls',
					cmd = { 'lua-language-server' },
					root_patterns = { '.luarc.json', '.luarc.jsonc', '.stylua.toml', '.git' },
					settings = {
						Lua = {
							runtime = { version = 'LuaJIT' },
							diagnostics = { globals = { 'vim' } },
							workspace = {
								library = vim.api.nvim_get_runtime_file('', true),
								checkThirdParty = false,
							},
							telemetry = { enable = false },
						},
					},
				})
			end

			-- Python
			if command_exists('pyright-langserver') or command_exists('pyright') then
				start_on_filetype({ 'python' }, {
					name = 'pyright',
					cmd = { command_exists('pyright-langserver') and 'pyright-langserver' or 'pyright', '--stdio' },
					root_patterns = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
				})
			elseif command_exists('pylsp') then
				start_on_filetype({ 'python' }, {
					name = 'pylsp',
					cmd = { 'pylsp' },
					root_patterns = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
				})
			end

			-- Go
			if command_exists('gopls') then
				start_on_filetype({ 'go' }, {
					name = 'gopls',
					cmd = { 'gopls' },
					root_patterns = { 'go.work', 'go.mod', '.git' },
				})
			end

			-- TypeScript/JavaScript
			if command_exists('typescript-language-server') then
				start_on_filetype({ 'typescript', 'typescriptreact', 'typescript.tsx', 'javascript', 'javascriptreact', 'javascript.jsx' }, {
					name = 'tsserver',
					cmd = { 'typescript-language-server', '--stdio' },
					root_patterns = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
				})
			end

			-- Bash
			if command_exists('bash-language-server') then
				start_on_filetype({ 'sh', 'bash' }, {
					name = 'bashls',
					cmd = { 'bash-language-server', 'start' },
					root_patterns = { '.git' },
				})
			end
		end,
	},
}
