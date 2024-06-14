vim.bo.expandtab = true
vim.o.smarttab = true
vim.bo.softtabstop = 0
vim.bo.tabstop = 8 -- make it obvious if there's any tab funny business
vim.bo.shiftwidth = 2

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        nix = { "nixfmt" },
    },
    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
    },
})

require("conform").formatters.stylua = {
    prepend_args = { "--indent-type=Spaces" },
}
