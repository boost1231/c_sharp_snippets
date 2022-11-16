
local path_separator = "/"

if jit and jit.os == "Windows" then
    path_separator = "\\"
end

local M = {}

M.get_relative_file_path = function ()
    local full_path = vim.fn.expand('%:p:h')
    local cwd = vim.loop.cwd()
    local start_index, end_index = string.find(full_path, cwd)

    if start_index == nil or end_index == nil or start_index~=1 then
        print("The current working directory could not be found in the full path to the file")
        return
    end

    return string.sub(full_path, end_index + 2, -1)
end

M.get_namespace = function ()
    local relative_path = M.get_relative_file_path()

    if relative_path == nil then return end

    return string.gsub(relative_path, path_separator, ".")
end

M.get_filename = function ()
    return vim.fn.expand("%:t:r")
end

return M
