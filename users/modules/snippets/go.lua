local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

return {

        s("fn", {
                t("func "),
                i(1, "name"),
                t("("),
                i(2),
                t(") "),
                i(3),
                t({ " {", "\t" }),
                i(0),
                t({ "", "}" }),
        }),

        s("ife", {
                t("if err != nil {"),
                t({ "", "\treturn err" }),
                t({ "", "}" }),
        }),

        s("ifel", {
                t("if "),
                i(1, "condition"),
                t({ " {", "\t" }),
                i(2),
                t({ "", "} else {", "\t" }),
                i(0),
                t({ "", "}" }),
        }),

        s("forr", {
                t("for "),
                i(1, "i := range xs"),
                t({ " {", "\t" }),
                i(0),
                t({ "", "}" }),
        }),

        s("main", {
                t({
                        "package main",
                        "",
                        "func main() {",
                        "\t",
                }),
                i(0),
                t({ "", "}" }),
        }),

        s("st", {
                t("type "),
                i(1, "Name"),
                t({ " struct {", "\t" }),
                i(0),
                t({ "", "}" }),
        }),

        s("meth", {
                t("func ("),
                i(1, "r"),
                t(" "),
                i(2, "Receiver"),
                t(") "),
                i(3, "Method"),
                t("("),
                i(4),
                t(") "),
                i(5),
                t({ " {", "\t" }),
                i(0),
                t({ "", "}" }),
        }),

        s("sw", {
                t("switch "),
                i(1),
                t({ " {", "case " }),
                i(2),
                t({ ":", "\t" }),
                i(3),
                t({ "", "default:", "\t" }),
                i(0),
                t({ "", "}" }),
        }),

        s("fmt", {
                c(1, {
                        t("fmt.Println"),
                        t("fmt.Printf"),
                        t("fmt.Errorf"),
                }),
                t("("),
                i(0),
                t(")"),
        }),
}
