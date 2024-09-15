require("os")
require("mrr.cmp")
require("mrr.lsp")
require("mrr.telescope")
require("mrr.remap")
require("mrr.display")
require("mrr.formatting")

vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.scrolloff = 999

require("nvim-surround").setup({})
require("vim_sexp_mappings_for_regular_people").setup({})
require("conjure").setup({})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)
