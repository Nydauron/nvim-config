return {
    -- My plugins here
    "nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
    "nvim-lua/plenary.nvim", -- Useful lua functions used ny lots of plugins

    "lunarvim/colorschemes",
    {
        "rose-pine/neovim",
        as = "rose-pine",
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 999,
        config = function()
            require("jareth.themes.tokyonight")
        end,
    },
    -- {
    --     "nvimdev/galaxyline.nvim",
    --     branch = "main",
    --     dependencies = { "nvim-tree/nvim-web-devicons" },
    -- },
    {
        "nvim-lualine/lualine.nvim",
        branch = "master",
        priority = 990,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
        opts = function()
            local theme = require("jareth.themes.statusline").getLualineTheme()
            return {
                options = {
                    globalstatus = false,
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    theme = theme,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        "branch",
                        {
                            "diff",
                            colored = true, -- Displays a colored diff status if set to true
                            diff_color = {
                                -- Same color values as the general color option can be used here.
                                added = "LuaLineDiffAdd", -- Changes the diff's added color
                                modified = "LuaLineDiffChange", -- Changes the diff's modified color
                                removed = "LuaLineDiffDelete", -- Changes the diff's removed color you
                            },
                            symbols = { added = " ", modified = " ", removed = " " }, -- Changes the symbols used by the diff.
                            source = nil, -- A function that works as a data source for diff.
                            -- It must return a table as such:
                            --   { added = add_count, modified = modified_count, removed = removed_count }
                            -- or nil on failure. count <= 0 won't be displayed.
                        },
                        {
                            "diagnostics",

                            -- Table of diagnostic sources, available sources are:
                            --   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
                            -- or a function that returns a table as such:
                            --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
                            sources = { "nvim_diagnostic" },

                            -- Displays diagnostics for the defined severity types
                            sections = { "error", "warn", "info", "hint" },

                            diagnostics_color = {
                                -- Same values as the general color option can be used here.
                                error = "DiagnosticError", -- Changes diagnostics' error color.
                                warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
                                info = "DiagnosticInfo", -- Changes diagnostics' info color.
                                hint = "DiagnosticHint", -- Changes diagnostics' hint color.
                            },
                            symbols = {
                                error = " ",
                                warn = " ",
                                info = " ",
                                hint = "󰌵 ",
                            },
                            colored = true, -- Displays diagnostics status in color if set to true.
                            update_in_insert = true, -- Update diagnostics in insert mode.
                            always_visible = false, -- Show diagnostics even if there are none.
                        },
                        "searchcount",
                    },
                    lualine_c = {
                        "hostname",
                        {
                            "filename",
                            file_status = true, -- Displays file status (readonly status, modified status)
                            newfile_status = false, -- Display new file status (new file means no write after created)
                            path = 4, -- 0: Just the filename
                            -- 1: Relative path
                            -- 2: Absolute path
                            -- 3: Absolute path, with tilde as the home directory
                            -- 4: Filename and parent dir, with tilde as the home directory

                            shorting_target = 40, -- Shortens path to leave 40 spaces in the window
                            -- for other components. (terrible name, any suggestions?)
                            -- It can also be a function that returns
                            -- the value of `shorting_target` dynamically.
                            symbols = {
                                modified = "", -- Text to show when the file is modified.
                                readonly = "", -- Text to show when the file is non-modifiable or readonly.
                                unnamed = "[No Name]", -- Text to show for unnamed buffers.
                                newfile = "[New]", -- Text to show for newly created file before first write
                            },
                        },
                    },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                extensions = { "oil", "fugitive", "fzf" },
            }
        end,
        config = function(lazy, opts)
            require("jareth.themes.statusline").setHighlights()
            require("lualine").setup(opts)
        end,
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

    { "nvim-treesitter/nvim-treesitter", lazy = false, branch = "main", build = ":TSUpdate" },
    "hiphish/rainbow-delimiters.nvim",

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
    {
        "lervag/vimtex",
        lazy = false,
        init = function()
            -- Need latexmk and zathura
            vim.g.vimtex_view_method = "zathura"
        end,
    },

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
