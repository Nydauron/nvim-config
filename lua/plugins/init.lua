return {
    -- My plugins here
    "nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
    "nvim-lua/plenary.nvim", -- Useful lua functions used ny lots of plugins

    "lunarvim/colorschemes",
    {
        "rose-pine/neovim",
        as = "rose-pine",
    },
    "folke/tokyonight.nvim",
    {
        "nvimdev/galaxyline.nvim",
        branch = "main",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- cmp plugins
    "hrsh7th/nvim-cmp", -- The completion plugin
    "hrsh7th/cmp-buffer", -- buffer completions
    "hrsh7th/cmp-path", -- path completions
    "hrsh7th/cmp-cmdline", -- cmdline completions
    "saadparwaiz1/cmp_luasnip", -- snippet completions
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",

    -- snippets
    "L3MON4D3/LuaSnip", --snippet engine
    "rafamadriz/friendly-snippets", -- a bunch of snippets to use

    -- LSP
    "williamboman/mason.nvim", -- simple to use language server installer
    "williamboman/mason-lspconfig.nvim", -- simple to use language server installer
    "neovim/nvim-lspconfig", -- enable LSP
    {
        "nvimdev/guard.nvim", -- Linters and foramatters (replaces null-ls)
        dependencies = {
            "nvimdev/guard-collection",
        },
    },
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    {
        "Nydauron/mason-sync.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("trouble").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
        end,
    },

    -- Go
    "ray-x/go.nvim",
    "ray-x/guihua.lua", -- recommanded if need floating window support

    -- Rust
    -- TODO: Configure rustaceanvim
    -- { "mrcjkb/rustaceanvim", tag = "*", ft = "rust" },

    -- MIPS
    "cs233/vim-mips",

    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { { "nvim-lua/plenary.nvim" } },
    },
    "nvim-telescope/telescope-media-files.nvim",

    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    "nvim-treesitter/nvim-treesitter-context",
    "nvim-treesitter/playground",
    "mrjones2014/nvim-ts-rainbow",

    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        setup = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    {
        "numtostr/comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },

    -- Git integration
    "tpope/vim-fugitive",
    "airblade/vim-gitgutter",

    -- Tmux integration
    "christoomey/vim-tmux-navigator",

    -- Remote file access over SSH
    {
        "chipsenkbeil/distant.nvim",
        branch = "v0.3",
        config = function()
            require("distant"):setup()
        end,
    },

    -- LaTeX
    "lervag/vimtex",

    "mbbill/undotree",

    "editorconfig/editorconfig-vim",

    "ThePrimeagen/harpoon",

    {
        "j-hui/fidget.nvim",
        tag = "legacy",
    },

    "andweeb/presence.nvim",

    "ThePrimeagen/vim-be-good",
}
