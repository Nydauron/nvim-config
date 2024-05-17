local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("jareth.leader")

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup lazy_user_config
    autocmd!
    autocmd BufWritePost packer.lua source <afile> | Lazy
  augroup end
]])

-- Use a protected call so we don't error out on first use
-- local status_ok, packer = pcall(require, "packer")
-- if not status_ok then
--     vim.notify("Could not import packer in packer.lua")
--     return
-- end
-- Have packer use a popup window

-- Install your plugins here
require("lazy").setup("plugins")
