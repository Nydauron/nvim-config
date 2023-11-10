local ts_context_ok, treesitter_context = pcall(require, "treesitter-context")
if not ts_context_ok then
    return
end

treesitter_context.setup({
    enable = true,
    max_lines = 8,
    min_window_height = 16,
    multiline_threshold = 1,
})
