-- Global nvim error handling: show ALL errors as toast notifications
-- instead of opening bottom windows

-- Override vim.schedule to catch callback errors
local original_schedule = vim.schedule
vim.schedule = function(fn)
    return original_schedule(function()
        local success, err = pcall(fn)
        if not success then
            vim.notify(tostring(err), vim.log.levels.ERROR, { title = "Nvim Error" })
        end
    end)
end

-- Override vim's main error display function
local original_vim_error = vim.api.nvim_err_writeln
vim.api.nvim_err_writeln = function(msg)
    if type(msg) == "string" and msg ~= "" then
        vim.notify(msg, vim.log.levels.ERROR, { title = "Nvim Error" })
        return
    end
    return original_vim_error(msg)
end

-- Override vim.notify_once for error-level notifications
local original_notify_once = vim.notify_once
vim.notify_once = function(msg, level, opts)
    if level == vim.log.levels.ERROR then
        vim.notify(msg, vim.log.levels.ERROR, { title = "Nvim Error" })
        return
    end
    return original_notify_once(msg, level, opts)
end

-- Override echoerr command
local original_echoerr = vim.api.nvim_command
vim.api.nvim_command = function(cmd)
    if type(cmd) == "string" and cmd:match("^echoerr") then
        local msg = cmd:match("^echoerr%s+(.+)")
        if msg then
            vim.notify(msg:gsub('"', ''), vim.log.levels.ERROR, { title = "Nvim Error" })
            return
        end
    end
    return original_echoerr(cmd)
end

-- Override print function to catch error messages printed to command line
local original_print = print
print = function(...)
    local args = {...}
    local msg = table.concat(vim.tbl_map(tostring, args), " ")
    if msg:match("Error") or msg:match("error") then
        vim.notify(msg, vim.log.levels.ERROR, { title = "Nvim Error" })
        return
    end
    return original_print(...)
end

local autocmd = vim.api.nvim_create_autocmd
autocmd('LspAttach', {
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})
