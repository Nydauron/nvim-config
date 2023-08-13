local status_ok, rt = pcall(require, 'rust-tools')
if not status_ok then
    return
end

local opts = {
    on_attach = require("jareth.lsp.handlers").on_attach,
    capabilities = require("jareth.lsp.handlers").capabilities,
}
local server = "rust_analyzer"
local require_ok, conf_opts = pcall(require, "jareth.lsp.settings" .. server)
if require_ok then
    opts = vim.tbl_deep_extend("force", conf_opts, opts)
end

rt.setup({
    tools = {
        inlay_hints = {
            auto = true,
            only_current_line = false,
            show_parameter_hints = true,
            highlight = "LspInlayHint",
        }
    },
    server = opts,
})
