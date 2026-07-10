# This file is managed by chezmoi. Do not edit directly.
-- luacheck: globals vim
---@diagnostic disable: undefined-global

return {
    {
        "williamboman/mason.nvim",
        dependencies = {
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local cmp = require('cmp')
            local cmp_lsp = require('cmp_nvim_lsp')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            -- Link cmp with lsp capabilities
            local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
            )

            require("mason").setup()
            vim.keymap.set("n", "<leader>pm", vim.cmd.Mason)

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<Up>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<Down>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = "copilot", group_index = 2 },
                    { name = 'nvim_lsp' },
                }, {
                    { name = 'buffer' },
                })
            })

            vim.diagnostic.config({
                -- update_in_insert = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })

            -- Native Neovim 0.11 LSP setup (no nvim-lspconfig)
            -- See also: :help lspconfig-nvim-0.11 and https://lugh.ch/switching-to-neovim-native-lsp.html

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

            -- Lua (lua-language-server)
            if command_exists('lua-language-server') then
                local lua_cfg = {
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
                }
                start_on_filetype({ 'lua' }, lua_cfg)
            end

            -- Python (pyright or pylsp)
            if command_exists('pyright-langserver') or command_exists('pyright') then
                local py_cfg = {
                    name = 'pyright',
                    cmd = { command_exists('pyright-langserver') and 'pyright-langserver' or 'pyright', '--stdio' },
                    root_patterns = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
                }
                start_on_filetype({ 'python' }, py_cfg)
            elseif command_exists('pylsp') then
                local pylsp_cfg = {
                    name = 'pylsp',
                    cmd = { 'pylsp' },
                    root_patterns = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
                }
                start_on_filetype({ 'python' }, pylsp_cfg)
            end

            -- Go (gopls)
            if command_exists('gopls') then
                local go_cfg = {
                    name = 'gopls',
                    cmd = { 'gopls' },
                    root_patterns = { 'go.work', 'go.mod', '.git' },
                }
                start_on_filetype({ 'go' }, go_cfg)
            end

            -- TypeScript/JavaScript (typescript-language-server)
            if command_exists('typescript-language-server') then
                local ts_cfg = {
                    name = 'tsserver',
                    cmd = { 'typescript-language-server', '--stdio' },
                    root_patterns = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
                }
                start_on_filetype({ 'typescript', 'typescriptreact', 'typescript.tsx', 'javascript', 'javascriptreact', 'javascript.jsx' }, ts_cfg)
            end

            -- Bash (bash-language-server)
            if command_exists('bash-language-server') then
                local bash_cfg = {
                    name = 'bashls',
                    cmd = { 'bash-language-server', 'start' },
                    root_patterns = { '.git' },
                }
                start_on_filetype({ 'sh', 'bash' }, bash_cfg)
            end
        end
    }
}
