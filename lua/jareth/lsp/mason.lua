JSON = require("JSON")
local cwd = vim.fn.stdpath("config")
local config_worktree = vim.fs.normalize("~")
local config_git_dir = config_worktree .. "/.cfg"
local server_lua_file = cwd .. "/lua/jareth/lsp/servers.json"
local status_ok, servers = pcall(function ()
    local file = assert(io.open(server_lua_file, "r"))
    local server_list_str = file:read("a")
    file:close()
    local decoded_json = JSON:decode(server_list_str)
    return type(decoded_json) == "table" and decoded_json or {}
end)
if not status_ok then
    servers = {}
end

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
require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    return
end

local opts = {}

local all_servers_installed = {}
local existing_servers = {}

for _, v in ipairs(servers) do
    all_servers_installed[v] = true
    existing_servers[v] = true
end

for _, v in ipairs(require("mason-lspconfig").get_installed_servers()) do
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
    local file = assert(io.open(server_lua_file, "w"))
    local json_encoded = JSON:encode(new_server_list, nil, {pretty = true, indent = "    ", array_newline = true})
    file:write(json_encoded)
    local status_ok  = file:close()

    if not status_ok then
        print(("An issue occurred when closing the file. Please see if the changes were written to %q"):format(server_lua_file))
    end
    vim.ui.input({ prompt = "Please enter a commit message: "}, function (msg)
        vim.cmd(("Git --work-tree %q --git-dir %q commit -m %q -- %q"):format(config_worktree, config_git_dir, msg, server_lua_file))
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

for server, _ in pairs(all_servers_installed) do
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
end
