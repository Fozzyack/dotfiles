local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key
ls.add_snippets("all", {
    s({
        trig = "rafce",
        name = "React Arrow Function Component",
        wordTrig = true,
    }, fmt([[
        -!
        import React from 'react';

        const -! = () => {
            return (
                <div>
                    -!
                </div>
            );
        };

        export default -!;
    ]], {
        c(1, {  t"", t"'use client';", t"'use strict';", t"'use server';", }),
        i(2, "Component Name"),
        i(3, "Content"),
        rep(2)
    }, {
        delimiters = "-!"
    })),
    s({
        trig = 'nrh',
        name = 'Next route handler',
        desc = 'Next JS route handler for the app router',
        wordTrig = true,
    }, fmt([[
    export const -! = async (req: Request) => {
        try {
            -!
        } catch (error: any) {
            console.log(error.message)
            return Response.json(error.message, {status: 500})
        }
    }
    ]], {
        c(1, { t"GET", t"POST", t"PUT", t"DELETE" }),
        i(3, "Code ...")
    }, {
        delimiters = "-!"
    })),
    s({
        trig = "dtable",
        name = "Default SQL Table",
        wordTrig = true,
    }, fmt([[
        CREATE TABLE -! 
        (
            id SERIAL,
            -!,

            PRIMARY KEY (id)
        );
    ]], {
        i(1, "Table Name"),
        i(2, "Column Name")
    }, {
        delimiters = "-!"
    })),
    s({
        trig = "trycatch",
        name = "Try Catch Block",
    }, fmt([[
        try {
            -!
        } catch(error: any) {
            console.error(error.message)
        }
    ]], {
        i(1, "code")
    }, {
        delimiters =  '-!'
    })),
})

