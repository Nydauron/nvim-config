local status_ok, rt = pcall(require, 'rust-tools')
if not status_ok then
    return
end

rt.setup({
    tools = {
        inlay_hints = {
            auto = true,
            only_current_line = false,
            show_parameter_hints = true,
            highlight = "LspInlayHint",
        }
    }
})
