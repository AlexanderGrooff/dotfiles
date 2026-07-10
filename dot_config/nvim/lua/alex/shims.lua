# This file is managed by chezmoi. Do not edit directly.
-- Compatibility shims for deprecated APIs
-- luacheck: globals vim
---@diagnostic disable: undefined-global

-- Replace deprecated vim.tbl_flatten with iter-based version
if type(vim.tbl_flatten) == 'function' then
    local ok, iter = pcall(require, 'vim.iter')
    if ok and type(iter) == 'table' and type(iter.flatten) == 'function' then
        vim.tbl_flatten = function(list)
            return iter(list):flatten():totable()
        end
    else
        -- Fallback simple flatten (1-level) if vim.iter not available
        vim.tbl_flatten = function(list)
            local result = {}
            for _, v in ipairs(list) do
                if type(v) == 'table' then
                    for _, vv in ipairs(v) do
                        table.insert(result, vv)
                    end
                else
                    table.insert(result, v)
                end
            end
            return result
        end
    end
end


