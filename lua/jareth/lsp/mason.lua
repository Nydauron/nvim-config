local cwd = vim.fn.stdpath("config")
local server_lua_file = cwd .. "/lua/jareth/lsp/servers.json"
print(cwd)
local status_ok, servers = pcall(function ()
    local file = assert(io.open(server_lua_file, "r"))
    local server_list_str = file:read()
    file:close()
    return vim.json.decode(server_list_str, { array = true })
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

local sync_server_list = function ()
    local new_server_list = {}
    for k, _ in pairs(all_servers_installed) do
        table.insert(new_server_list, k)
    end
    local file = assert(io.open(server_lua_file, "w"))
    file:write(vim.json.encode(new_server_list))
    local status_ok  = file:close()

    if status_ok then
        local cmd = ("Git --work-tree %q --git-dir %q commit -- %q"):format(cwd, cwd .. "/.git", server_lua_file)
        vim.cmd(cmd)
    else
        print(("An issue occurred when closing the file. Please see if the changes were written to %q"):format(server_lua_file))
    end
end

local recursive_prompt
recursive_prompt = function ()
    vim.ui.input({ prompt = "Would you like to sync and commit this updated server list? (Y/n) "}, function(response)
        if string.lower(response) == "y" or response == "" then
            sync_server_list()
            return
        elseif string.lower(response) == "n" then
            print("Oke :)")
            return
        end
        print(("%q was not a valid response."):format(response))
        recursive_prompt()
    end)
end

for k, _ in pairs(all_servers_installed) do
    if existing_servers[k] == true then
        goto server_check_continue
    end
    print("Some servers were not installed by the given config (e.g. installed thru Mason interface)")
    recursive_prompt()
    ::server_check_continue::
end

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
