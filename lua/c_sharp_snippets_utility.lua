local util = require 'lspconfig.util'

local M = {}

M.get_buffer_dir_relative_to_parent_dir_of_csproj_dir = function ()
    -- 'lspconfig.util' uses the "/" as the path seperator even on windows.
    -- nvim_buf_get_name actuall returns it with the "\" but we call "sanitize"
    -- so that the 'lspconfig.util' can deal with it.

    local bufname = util.path.sanitize(vim.api.nvim_buf_get_name(0))

    local csproj_dir =  util.root_pattern("*.csproj")(bufname)

    local buf_dir = vim.fn.fnamemodify(bufname, ':h')

    -- csproj_one_up_dir is the directory that containes the directory which
    -- houses the csproj file.
    local csproj_one_up_dir = vim.fn.fnamemodify(csproj_dir, ':h')

    local _, end_index = string.find(buf_dir, csproj_one_up_dir, 1, true)

    return string.sub(buf_dir, end_index + 2, -1)
end

M.get_namespace = function ()
    local relative_path = M.get_buffer_dir_relative_to_parent_dir_of_csproj_dir()

    if relative_path == nil then return end

    -- The path seperator in relative_path is "/" even on Windows.
    -- That seems to be what the 'lspconfig.util' uses.
    return string.gsub(relative_path, "/", ".")
end

M.get_filename = function ()
    return vim.fn.expand("%:t:r")
end

return M
