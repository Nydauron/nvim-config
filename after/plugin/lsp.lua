local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

require("jareth.lsp.mason")
require("jareth.lsp.handlers").setup()
require("jareth.lsp.null-ls")
