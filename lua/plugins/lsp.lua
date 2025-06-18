return {
    {
        "neovim/nvim-lspconfig",                 -- enable LSP
        dependencies = {
            "williamboman/mason.nvim",           -- simple to use language server installer
            "williamboman/mason-lspconfig.nvim", -- simple to use language server installer
            {
                "nvimdev/guard.nvim",            -- Linters and foramatters (replaces null-ls)
                dependencies = {
                    "nvimdev/guard-collection",
                },
            },
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            {
                "Nydauron/mason-sync.nvim",
                dependencies = { "nvim-lua/plenary.nvim" },
            },
        },
        config = function()
            require("jareth.lsp.mason")
            require("jareth.lsp.guard")
            require("jareth.lsp.handlers").setup()
        end
    }
}
