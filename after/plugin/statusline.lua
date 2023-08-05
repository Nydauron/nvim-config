-- Access colors via galaxyline's recommended naming
-- E.g. `highlights.blue`, `highlights.yellow`
local status_ok, highlights = pcall(require, 'rose-pine.plugins.galaxyline')
if not status_ok then
    return
end

local gl = require('galaxyline')
local gls = gl.section
gl.short_line_list = {'LuaTree','vista','dbui'}

-- rose-pine
-- local rose_pine_palette = require('rose-pine.palette')

-- local colors = {
--     bg = rose_pine_palette.surface,
--     fg = rose_pine_palette.text,
--     fg_alt = rose_pine_palette.subtle,
--     yellow = rose_pine_palette.gold,
--     cyan = rose_pine_palette.rose,
--     green = rose_pine_palette.pine,
--     orange = rose_pine_palette.muted,
--     magenta = rose_pine_palette.iris,
--     purple = rose_pine_palette.iris,
--     blue = rose_pine_palette.foam,
--     red = rose_pine_palette.love,
-- }

local tokyo_night_palette = require("tokyonight.colors")
local colors = tokyo_night_palette.default
colors.bg = tokyo_night_palette.night.bg
colors.bg_dark = tokyo_night_palette.night.bg_dark
colors.gray = tokyo_night_palette.default.dark3
colors.darkblue = tokyo_night_palette.night.bg

local buffer_not_empty = function ()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

local is_git_repo = function ()
    local path = vim.uv.cwd() .. "/.git"
    local ok, err = vim.uv.fs_stat(path)
    -- if not ok then
    --     print(err)
    -- end
    return ok
end

local checkwidth = function()
    local squeeze_width  = vim.fn.winwidth(0) / 2
    if squeeze_width > 40 then
        return true
    end
    return false
end

local mode_color = {
    c  = {"COMMAND", colors.magenta},
    ce = {"NORMAL EX", colors.magenta},
    cv = {"EX", colors.purple},
    i  = {"INSERT", colors.teal or colors.green},
    ic = {"INSERT COMPLETION", colors.yellow},
    ix = {"INSERT CTRL-X",colors.yellow},
    n  = {"NORMAL",colors.blue},
    no = {"OPERATOR PENDING", colors.blue},
    nov = {"OPERATOR PENDING", colors.blue},
    noV = {"OPERATOR PENDING",colors.blue},
    r  = {"HIT-ENTER", colors.cyan},
    ['r?'] = {":CONFIRM", colors.cyan},
    rm = {"MORE", colors.cyan},
    R  = {"REPLACE", colors.purple},
    Rv = {"VIRTUAL",colors.purple},
    s  = {"SELECT", colors.orange},
    S  = {"SELECT", colors.orange},
    [''] = {"SELECT BLOCK", colors.orange},
    ['t']  = {"TERMINAL", colors.purple},
    v  = {"VISUAL", colors.red},
    V  = {"VISUAL LINE", colors.red},
    [''] = {"VISUAL BLOCK", colors.red},
    ['!'] = {"SHELL", colors.red},
}

vim.api.nvim_command(('hi GalaxyDiagError guifg=%s guibg=%s'):format(colors.red, colors.bg_dark or colors.bg))
vim.api.nvim_command(('hi GalaxyDiagWarning guifg=%s guibg=%s'):format(colors.yellow, colors.bg_dark or colors.bg))

gls.left = {
    {
        FirstElement = {
            provider = function()
                local color = (mode_color[vim.fn.mode(true)] or mode_color[vim.fn.mode(false)])[2]
                vim.api.nvim_command('hi GalaxyFirstElement guibg='..color)
                return ' ' end,
            highlight = {colors.blue,colors.red}
        },
    },
    {
        ViMode = {
            provider = function()
                local mode = mode_color[vim.fn.mode(true)] or mode_color[vim.fn.mode(false)]
                vim.api.nvim_command('hi GalaxyViMode guibg='..mode[2])
                return mode[1]
            end,
            highlight = {colors.bg_dark or colors.bg,colors.red,'bold'},
        },
    },
    {
        ViModeSeparator = {
            provider = function ()
                local color = (mode_color[vim.fn.mode(true)] or mode_color[vim.fn.mode(false)])[2]
                vim.api.nvim_command('hi GalaxyViModeSeparator guifg='..color)
                return ' '
            end,
            highlight = {colors.red,colors.darkblue,'bold'},
        }
    },
    {
        FileIcon = {
            provider = 'FileIcon',
            condition = buffer_not_empty,
            highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.darkblue},
        },
    },
    {
        FileName = {
            provider = {'FileName','FileSize'},
            condition = buffer_not_empty,
            -- separator = '',
            highlight = {colors.magenta,colors.darkblue}
        }
    },
    {
        GitPrefixSeparator = {
            provider = function ()
                return ''
            end,
            condition = function ()
                return buffer_not_empty() and is_git_repo()
            end,
            highlight = {colors.red,colors.darkblue},
        }
    },
    {
        GitIcon = {
            provider = function() return '󰊢 ' end,
            condition = function ()
                return buffer_not_empty() and is_git_repo()
            end,
            highlight = {colors.bg_dark or colors.bg,colors.red},
        }
    },
    {
        GitBranch = {
            provider = 'GitBranch',
            condition = function ()
                return buffer_not_empty() and is_git_repo()
            end,
            separator = ' ',
            separator_highlight = {colors.red,colors.bg_dark or colors.bg},
            highlight = {colors.bg_dark or colors.bg, colors.red},
        }
    },
    {
        DiffAdd = {
            provider = 'DiffAdd',
            condition = checkwidth,
            icon = ' ',
            highlight = {colors.teal or colors.green,colors.bg_dark or colors.bg},
        }
    },
    {
        DiffModified = {
            provider = 'DiffModified',
            condition = checkwidth,
            icon = ' ',
            highlight = {colors.orange,colors.bg_dark or colors.bg},
        }
    },
    {
        DiffRemove = {
            provider = 'DiffRemove',
            condition = checkwidth,
            icon = ' ',
            highlight = {colors.red,colors.bg_dark or colors.bg},
        }
    },
    -- {
    --     DiagLeft = {
    --         provider = function()
    --             vim.api.nvim_command('hi GalaxyCustomDiagLeft guibg='..colors.purple)
    --             return ''
    --         end,
    --         condition = is_git_repo,
    --         highlight = {colors.grey,colors.bg_dark or colors.bg}
    --     }
    -- },
    -- {
    --     DiagLeftNoGit = {
    --         provider = function()
    --             vim.api.nvim_command('hi GalaxyiCustomDiagLeft guibg='..colors.darkblue)
    --             return ''
    --         end,
    --         condition = function () return not is_git_repo() end,
    --         highlight = {colors.grey,colors.bg_dark or colors.bg}
    --     }
    -- },
    {
        DiagnosticError = {
            provider = 'DiagnosticError',
            icon = '  ',
            highlight = "GalaxyDiagError"
        }
    },
    {
        DiagnosticWarn = {
            provider = 'DiagnosticWarn',
            icon = '  ',
            highlight = "GalaxyDiagWarning",
        }
    },
    -- {
    --     DiagRightSeparator = {
    --         provider = function() return '' end,
    --         highlight = {colors.grey,colors.bg_dark or colors.bg}
    --     }
    -- },
}


gls.right[1]= {
    FileFormat = {
        provider = 'FileFormat',
        separator = '█',
        separator_highlight = {colors.bg_highlight, colors.bg_dark or colors.bg},
        highlight = {colors.fg, colors.bg_highlight},
    }
}
gls.right[2] = {
    LineInfo = {
        provider = 'LineColumn',
        separator = ' | ',
        separator_highlight = {colors.bg_dark,colors.bg_highlight},
        highlight = {colors.fg,colors.bg_highlight},
    },
}
gls.right[3] = {
    PerCent = {
        provider = 'LinePercent',
        separator = '',
        separator_highlight = {colors.bg_highlight,colors.bg_dark or colors.bg},
        highlight = {colors.fg,colors.bg_dark or colors.bg},
    }
}
gls.right[4] = {
    ScrollBar = {
        provider = 'ScrollBar',
        highlight = {colors.teal,colors.terminal_black or colors.bg},
    }
}

gls.short_line_left[1] = {
    BufferType = {
        provider = 'FileTypeName',
        separator = '',
        separator_highlight = {colors.terminal_black or colors.bg,colors.bg_dark or colors.bg},
        highlight = {colors.grey,colors.terminal_black or colors.bg},
    }
}
