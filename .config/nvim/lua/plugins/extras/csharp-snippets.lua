return {
    "L3MON4D3/LuaSnip",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        local ls = require("luasnip")
        
        -- C# specific snippets
        ls.add_snippets("cs", {
            ls.snippet("class", {
                ls.text_node("public class "),
                ls.insert_node(1, "ClassName"),
                ls.text_node({ " {", "\t" }),
                ls.insert_node(0),
                ls.text_node({ "", "}" })
            }),
            ls.snippet("ctor", {
                ls.text_node("public "),
                ls.insert_node(1, "ClassName"),
                ls.text_node("()"),
                ls.text_node({ " {", "\t" }),
                ls.insert_node(0),
                ls.text_node({ "", "}" })
            }),
            ls.snippet("prop", {
                ls.text_node("public "),
                ls.insert_node(1, "type"),
                ls.text_node(" "),
                ls.insert_node(2, "PropertyName"),
                ls.text_node(" { get; set; }")
            }),
            ls.snippet("method", {
                ls.text_node("public "),
                ls.insert_node(1, "void"),
                ls.text_node(" "),
                ls.insert_node(2, "MethodName"),
                ls.text_node("("),
                ls.insert_node(3),
                ls.text_node(")"),
                ls.text_node({ " {", "\t" }),
                ls.insert_node(0),
                ls.text_node({ "", "}" })
            })
        })
    end
}
