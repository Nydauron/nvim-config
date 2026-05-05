local M = {}

function M.getColors()
    local tokyo_night_palette = require("tokyonight.colors").setup({ setup = "night" })
    local colors = tokyo_night_palette
    colors.gray = tokyo_night_palette.dark3
    colors.darkblue = tokyo_night_palette.bg
    return colors
end

function M.getLualineTheme()
    local colors = M.getColors()
    return {
        normal = {
            a = { bg = colors.gray, fg = colors.black, gui = "bold" },
            b = { bg = colors.lightgray, fg = colors.white },
            c = { bg = colors.darkgray, fg = colors.gray },
        },
        insert = {
            a = { bg = colors.teal or colors.green, fg = colors.black, gui = "bold" },
            b = { bg = colors.lightgray, fg = colors.white },
            c = { bg = colors.lightgray, fg = colors.white },
        },
        visual = {
            a = { bg = colors.red, fg = colors.black, gui = "bold" },
            b = { bg = colors.lightgray, fg = colors.white },
            c = { bg = colors.inactivegray, fg = colors.black },
        },
        replace = {
            a = { bg = colors.purple, fg = colors.black, gui = "bold" },
            b = { bg = colors.lightgray, fg = colors.white },
            c = { bg = colors.black, fg = colors.white },
        },
        command = {
            a = { bg = colors.magenta, fg = colors.black, gui = "bold" },
            b = { bg = colors.lightgray, fg = colors.white },
            c = { bg = colors.inactivegray, fg = colors.black },
        },
        inactive = {
            a = { bg = colors.darkgray, fg = colors.gray, gui = "bold" },
            b = { bg = colors.darkgray, fg = colors.gray },
            c = { bg = colors.darkgray, fg = colors.gray },
        },
    }
end

function M.setHighlights()
    local theme = M.getColors()
    vim.api.nvim_set_hl(0, "LuaLineDiffAdd", { fg = theme.green })
    vim.api.nvim_set_hl(0, "LuaLineDiffChange", { fg = theme.orange })
    vim.api.nvim_set_hl(0, "LuaLineDiffDelete", { fg = theme.red })
end

return M
