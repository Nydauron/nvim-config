return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                columns = { "icon" },
                keymaps = {
                    ["<C-h>"] = false,
                    ["<C-l>"] = false,
                    ["<C-r>"] = "actions.refresh",
                    ["<M-h>"] = "actions.select_split",
                },
                view_options = {
                    show_hidden = true,
                }
            })

            -- Override netrw :Ex keymapping
            vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end
    },
}
