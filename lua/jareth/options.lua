local options = {
    -- :help options
    backup = false,                                  -- creates a backup file
    clipboard = "unnamedplus",                       -- allows neovim to access the system clipboard
    cmdheight = 2,                                   -- more space in the neovim command line for displaying messages
    completeopt = { "menuone", "noselect" },         -- mostly just for cmp
    conceallevel = 0,                                -- so that `` is visible in markdown files
    fileencoding = "utf-8",                          -- the encoding written to a file
    guicursor = "n-v-c:block,i-ci-ve:block,o:hor50," -- blinking cursor on editing, normal mode is solid
        .. "a:blinkwait700-blinkoff400-blinkon250-Cursor/"
        .. "lCursor,n:blinkon0",
    hlsearch = false,          -- prevents highlights all matches on previous search pattern incsearch = true,                               -- highlights while searching current pattern
    incsearch = true,          -- allow for search results to show as you type
    ignorecase = true,         -- ignore case in search patterns
    mouse = "a",               -- allow the mouse to be used in neovim
    pumheight = 10,            -- pop up menu height
    showmode = false,          -- we don't need to see things like -- INSERT -- anymore
    showtabline = 2,           -- always show tabs
    smartcase = true,          -- smart case
    smartindent = true,        -- make indenting smarter again
    splitbelow = true,         -- force all horizontal splits to go below current window
    splitright = true,         -- force all vertical splits to go to the right of current window
    swapfile = false,          -- creates a swapfile
    termguicolors = true,      -- set term gui colors (most terminals support this)
    timeoutlen = 1000,         -- time to wait for a mapped sequence to complete (in milliseconds)
    undofile = true,           -- enable persistent undo
    undodir = os.getenv("HOME") .. "/.vim/undodir",
    updatetime = 50,           -- faster completion (4000ms default)
    writebackup = false,       -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    expandtab = true,          -- convert tabs to spaces
    shiftwidth = 4,            -- the number of spaces inserted for each indentation
    tabstop = 4,               -- insert 4 spaces for a tab
    softtabstop = 4,
    cursorline = true,         -- highlight the current line
    number = true,             -- set numbered lines
    relativenumber = true,     -- set relative numbered lines
    numberwidth = 4,           -- set number column width to 2 {default 4}
    signcolumn = "yes",        -- always show the sign column, otherwise it would shift the text each time
    wrap = false,              -- display lines as one long line
    scrolloff = 8,             -- is one of my fav
    sidescrolloff = 8,
    guifont = "monospace:h17", -- the font used in graphical neovim applications
    autochdir = false,         -- automatically changes to the current working directory of the file
    colorcolumn = "100",       -- visually shows vertical column at char 100
}

vim.opt.shortmess:append("c")

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]]) -- TODO: this doesn't seem to work

vim.cmd([[
    set listchars=eol:↵,tab:>.,trail:~,extends:>,precedes:<
    set list
]])

if vim.fn.filereadable("/proc/sys/fs/binfmt_misc/WSLInterop") == 1 then
    vim.cmd([[
        let g:clipboard = {
        \   'name': 'WslClipboard',
        \   'copy': {
        \      '+': 'clip.exe',
        \      '*': 'clip.exe',
        \    },
        \   'paste': {
        \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        \   },
        \   'cache_enabled': 0,
        \ }
    ]])
end
