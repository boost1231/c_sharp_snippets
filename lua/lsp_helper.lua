-- This is an lsp helper file for the C# snippets

M = {}

--[[
--]]
-- The following is the lsp reponse to get a signature
--[[{
      result = {
            activeParameter = 1,
            activeSignature = 0,
            signatures = { {
        documentation = "",
        label = "int MartinTheWarrior.GetSomething(int x, decimal money, DateTime currentTime)",
            parameters = { {
            documentation = "",
            label = "int x"
                  }, {
            documentation = "",
            label = "decimal money"
                      }, {
            documentation = "",
            label = "DateTime currentTime"
                      } }
      }, {
        documentation = "",
        label = "int MartinTheWarrior.GetSomething(string word)",
            parameters = { {
            documentation = "",
            label = "string word"
                  } }
      } }
  }
}
--]]
M.get_signatures = function()

    local current_bufnr = vim.api.nvim_get_current_buf()

    local active_clients = vim.lsp.get_clients({bufnr = current_bufnr})

    local current_client = nil

    for _, client in ipairs(active_clients) do
        current_client = client
    end

    local request = vim.lsp.util.make_position_params(0, current_client.offset_encoding)

    request.context = {
        triggerKind = 1,
    }

    local response = current_client.request_sync('textDocument/signatureHelp', request, 50)
    -- Below this is for testing

    if response == nil then
        print("Error getting signature")
        return -- how to make an error?
    end

    local signatures = {}

    for _, signature in ipairs(response.result.signatures) do

        local params = {}

        for _, parameter in ipairs(signature.parameters) do
            local components = vim.split(parameter.label, " ")
            table.insert(params, components[#components])
        end

        local sig = {
            params = params
        }

        table.insert(signatures, sig)

    end

    return signatures

end

return M
