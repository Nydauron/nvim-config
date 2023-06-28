local cwd = vim.fn.stdpath("config")
local server_lua_file = cwd .. "/lua/jareth/lsp/servers.json"
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

local recursive_prompt
recursive_prompt = function (prompt, callback)
    vim.ui.input({ prompt = prompt }, function(response)
        if string.lower(response) == "y" or response == "" then
            callback()
            return
        elseif string.lower(response) == "n" then
            print("")
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
    file:write(vim.json.encode(new_server_list))
    local status_ok  = file:close()

    if not status_ok then
        print(("An issue occurred when closing the file. Please see if the changes were written to %q"):format(server_lua_file))
    end
    vim.ui.input({ prompt = "Please enter a commit message: "}, function (msg)
        vim.cmd(("Git --work-tree %q --git-dir %q commit -m %q -- %q"):format(cwd, cwd .. "/.git", msg, server_lua_file))
        recursive_prompt("Ready to push? (Y/n) ", function ()
            vim.cmd(("Git --work-tree %q --git-dir %q push origin master"):format(cwd, cwd .. "/.git"))
            vim.notify("LSP server list has been updated successfully")
        end)
    end)

    -- vim.api.nvim_buf_attach(buf_num, false, {
    --     on_detach = function (detach, handle)
    --         vim.notify("detached")
    --         vim.cmd("Git commit --amend --no-edit")
    --         vim.schedule(function ()
    --         end)
    --     end
    -- })
end

for k, _ in pairs(all_servers_installed) do
    if existing_servers[k] == true then
        goto server_check_continue
    end
    print("Some servers were not installed by the given config (e.g. installed thru Mason interface)")
    recursive_prompt("Would you like to sync and commit this updated server list? (Y/n) ", sync_server_list)
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
