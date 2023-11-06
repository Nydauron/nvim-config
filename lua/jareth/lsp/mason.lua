local JSON_ok = false
local cwd = vim.fn.stdpath("config")
local config_worktree = cwd
local config_git_dir = config_worktree .. "/.git"
local server_file = cwd .. "/lua/jareth/lsp/servers.json"

local settings = {
    ui = {
        border = "none",
        icons = {
            package_installed = "◍",
            package_pending = "◍",
            package_uninstalled = "◍",
        },
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
}

require("mason").setup(settings)

require('mason-sync').setup({
    file = "lua/jareth/lsp/servers.json",
    sync_on_mason_change = {
        on_install = true,
        on_uninstall = true,
    }
})

-- require("mason-null-ls").setup({
--     automatic_installation = false,
-- })

require("mason-lspconfig").setup({
    automatic_installation = false,
})

require("mason-tool-installer").setup({
    ensure_installed = require("mason-sync").ensure_installed_servers(),
    auto_update = true,
    run_on_start = true
})


local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    return
end

local opts = {}

local all_servers_installed = {}
local existing_servers = {}

for _, v in pairs(require("mason-sync").get_serverlist()) do
    all_servers_installed[v] = true
    existing_servers[v] = true
end

for _, v in pairs(require("mason-registry").get_installed_package_names()) do
    all_servers_installed[v] = true
end

local recursive_prompt
recursive_prompt = function (prompt, callback)
    vim.ui.input({ prompt = prompt }, function(response)
        if string.lower(response) == "y" or response == "" then
            callback()
            return
        elseif string.lower(response) == "n" then
            print("Oke :)")
            return
        end
        print(("%q was not a valid response."):format(response))
        recursive_prompt(callback)
    end)
end

local sync_server_list = function ()
    local new_server_list = {}
    for k, _ in pairs(all_servers_installed) do
        table.insert(new_server_list, k)
    end
    local file = assert(io.open(server_file, "w"))
    local json_encoded = JSON:encode(new_server_list, nil, {pretty = true, indent = "    ", array_newline = true})
    file:write(json_encoded)
    local status_ok  = file:close()

    if not status_ok then
        print(("An issue occurred when closing the file. Please see if the changes were written to %q"):format(server_file))
    end
    vim.ui.input({ prompt = "Please enter a commit message: "}, function (msg)
        vim.cmd(("Git --work-tree %q --git-dir %q commit -m %q -- %q"):format(config_worktree, config_git_dir, msg, server_file))
        recursive_prompt("Ready to push? (Y/n) ", function ()
            vim.cmd(("Git --work-tree %q --git-dir %q push origin master"):format(config_worktree, config_git_dir))
            vim.notify("LSP server list has been updated successfully")
        end)
    end)
end

for k, _ in pairs(all_servers_installed) do
    if existing_servers[k] == true then
        goto server_check_continue
    end
    print("Some servers were not installed by the given config (e.g. installed thru Mason interface)")
    recursive_prompt("Would you like to sync and commit this updated server list? (Y/n) ", sync_server_list)
    goto end_server_list_check
    ::server_check_continue::
end
::end_server_list_check::

local server_mappings = require("mason-lspconfig").get_mappings()

for server, _ in pairs(all_servers_installed) do
    local status_ok, server_package = pcall(require("mason-registry").get_package, server)
    if not status_ok or not vim.tbl_contains(server_package.spec.categories, "LSP") then
        goto continue_configure_lsps
    end

    server = server_mappings.mason_to_lspconfig[server]
    opts = {
        on_attach = require("jareth.lsp.handlers").on_attach,
        capabilities = require("jareth.lsp.handlers").capabilities,
    }

    server = vim.split(server, "@")[1]

    local require_ok, conf_opts = pcall(require, "jareth.lsp.settings." .. server)
    if require_ok then
        opts = vim.tbl_deep_extend("force", conf_opts, opts)
    end

    lspconfig[server].setup(opts)
    ::continue_configure_lsps::
end
