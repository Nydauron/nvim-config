vim.opt.rust_reccommended_style = true
vim.opt.rustfmt_autosave = true


return {
    cargo = {
        buildScripts = {
            enable = true,
        },
    },
    procMacro = {
        enable = true,
    }
}
