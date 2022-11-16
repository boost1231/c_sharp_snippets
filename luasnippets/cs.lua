local utility = require("c_sharp_snippets_utility")
local lsp_helper = require("lsp_helper")

local ls = require("luasnip")

-- It says these will be set by env so that I don't need to imprort.
-- I tried and it worked, but the lua warnings pop up showing that
-- everything is undefined
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local t = ls.text_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmta = require("luasnip.extras.fmt").fmta

ls.config.setup({
    enable_autosnippets = true,
})


return {
}, {
    s(
        {
            trig = "**",
            name = "expand params",
        }, {
            d(1, function()

                local signatures = lsp_helper.get_signatures();

                local foramt_string = "\t%s: default%s"

                local choice_node_option = {}

                for _, sig in ipairs(signatures) do

                    local param_lines = {}

                    table.insert(param_lines, "") -- To move first param to new line

                    for index, param in ipairs(sig.params) do

                        if index ~= #sig.params then
                            table.insert(param_lines, string.format(foramt_string, param, ","))
                        else
                            table.insert(param_lines, string.format(foramt_string, param, ""))
                        end
                    end

                    table.insert(choice_node_option, t(param_lines))
                end

                return sn(nil, {
                    c(1, choice_node_option)
                })

            end),
            t(");"), -- parenthesis to end the method signature
        }
    ),
    s(
        {
            trig = "newrec",
        },
        fmta([[
            namespace <>;

            public record <>(<>);
            ]],
            {
                f(utility.get_namespace),
                f(utility.get_filename),
                i(0),
            }
        )
    ),
    s(
        {
            trig = "newtype",
        },
        fmta([[
            namespace <>;

            <> <> <>
            {
                <>
            }
            ]],
            {
                f(utility.get_namespace),
                c(1, {t("public"), t("internal")}),
                c(2, {t("class"), t("record")}),
                f(utility.get_filename),
                i(0),
            }
        )
    )
}
