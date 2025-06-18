return {
    {
        "hrsh7th/nvim-cmp", -- The completion plugin
        lazy = false,
        priority = 100,
        dependencies = {
            -- cmp plugins
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",       -- buffer completions
            "hrsh7th/cmp-path",         -- path completions
            "hrsh7th/cmp-cmdline",      -- cmdline completions
            "saadparwaiz1/cmp_luasnip", -- snippet completions
            "hrsh7th/cmp-nvim-lua",
            -- snippets
            { "L3MON4D3/LuaSnip", build = "make install_jsregexp" }, --snippet engine
            "rafamadriz/friendly-snippets",                          -- a bunch of snippets to use
        },
        config = function()
            require("jareth.cmp")
        end
    }
}
