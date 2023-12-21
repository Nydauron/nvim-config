local ft_ok, ft = pcall(require, "guard.filetype")
if not ft_ok then
    return
end

ft("lua"):fmt("lsp"):append("stylua"):lint("selene")
ft("c,cpp"):fmt({
    cmd = "clang-format",
    args = { "--style={BasedOnStyle: llvm, IndentWidth: 4}" },
    stdin = true,
})
ft("python"):fmt("black")
ft("typescript,javascript,typescriptreact"):fmt("prettier")
ft("rust"):fmt("rustfmt")

require("guard").setup({
    fmt_on_save = true,
    lsp_as_default_formatter = false,
})
