-- Automatically install packer
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim",
            install_path,
        })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local PACKER_BOOTSTRAP = ensure_packer()

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    vim.notify("Could not import packer in packer.lua")
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})

-- Install your plugins here
return packer.startup(function(use)
    -- My plugins here
    use("wbthomason/packer.nvim") -- Have packer manage itself
    use("nvim-lua/popup.nvim")    -- An implementation of the Popup API from vim in Neovim
    use("nvim-lua/plenary.nvim")  -- Useful lua functions used ny lots of plugins

    use("lunarvim/colorschemes")
    use({
        "rose-pine/neovim",
        as = "rose-pine",
    })
    use("folke/tokyonight.nvim")
    use({
        "nvimdev/galaxyline.nvim",
        branch = "main",
        requires = { "nvim-tree/nvim-web-devicons" },
    })

    -- cmp plugins
    use("hrsh7th/nvim-cmp")         -- The completion plugin
    use("hrsh7th/cmp-buffer")       -- buffer completions
    use("hrsh7th/cmp-path")         -- path completions
    use("hrsh7th/cmp-cmdline")      -- cmdline completions
    use("saadparwaiz1/cmp_luasnip") -- snippet completions
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lua")

    -- snippets
    use("L3MON4D3/LuaSnip")             --snippet engine
    use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

    -- LSP
    use("williamboman/mason.nvim")           -- simple to use language server installer
    use("williamboman/mason-lspconfig.nvim") -- simple to use language server installer
    use("neovim/nvim-lspconfig")             -- enable LSP
    use({
        "nvimdev/guard.nvim",                -- Linters and foramatters (replaces null-ls)
        requires = {
            "nvimdev/guard-collection",
        },
    })
    use("WhoIsSethDaniel/mason-tool-installer.nvim")
    use({
        "Nydauron/mason-sync.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    })

    use({
        "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
        config = function()
            require("trouble").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
        end,
    })

    -- Go
    use("ray-x/go.nvim")
    use("ray-x/guihua.lua") -- recommanded if need floating window support

    -- Rust
    use({ "Ciel-MC/rust-tools.nvim", branch = "inline-inlay-hints" })

    -- MIPS
    use("cs233/vim-mips")

    use({
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        requires = { { "nvim-lua/plenary.nvim" } },
    })
    use("nvim-telescope/telescope-media-files.nvim")

    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use("nvim-treesitter/nvim-treesitter-context")
    use("nvim-treesitter/playground")
    use("mrjones2014/nvim-ts-rainbow")

    use({
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    })
    use({
        "numtostr/comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    })

    -- Git integration
    use("tpope/vim-fugitive")
    use("airblade/vim-gitgutter")

    -- Tmux integration
    use("christoomey/vim-tmux-navigator")

    -- Remote file access over SSH
    use({
        "chipsenkbeil/distant.nvim",
        branch = "v0.3",
        config = function()
            require("distant"):setup()
        end,
    })

    -- LaTeX
    use("lervag/vimtex")

    use("mbbill/undotree")

    use("editorconfig/editorconfig-vim")

    use("ThePrimeagen/harpoon")

    use({
        "j-hui/fidget.nvim",
        tag = "legacy",
    })

    use("ThePrimeagen/vim-be-good")

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
