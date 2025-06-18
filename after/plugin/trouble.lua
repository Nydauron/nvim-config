vim.keymap.set(
    "n",
    "<leader>xx",
    "<cmd>Trouble diagnostics toggle<cr>",
    { silent = true, noremap = true }
)
-- vim.keymap.set(
--     "n",
--     "<leader>xw",
--     "<cmd>TroubleToggle workspace_diagnostics<cr>",
--     { silent = true, noremap = true }
-- )
-- vim.keymap.set(
--     "n",
--     "<leader>xd",
--     "<cmd>TroubleToggle document_diagnostics<cr>",
--     { silent = true, noremap = true }
-- )
vim.keymap.set(
    "n",
    "<leader>cl",
    "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set(
    "n",
    "<leader>xl",
    "<cmd>Trouble loclist toggle<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set(
    "n",
    "<leader>xq",
    "<cmd>Trouble qflist toggle<cr>",
    { silent = true, noremap = true }
)
