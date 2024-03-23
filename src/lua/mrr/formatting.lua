vim.bo.expandtab = true
vim.o.smarttab = true
vim.bo.softtabstop = 0
vim.bo.tabstop = 8 -- make it obvious if there's any tab funny business
vim.bo.shiftwidth = 2

--[[
require('formatter').setup {
	logging = true,
	log_level = vim.log.levels.INFO,
	filetype = {
		nix = { require('formatter.filetypes.nix').nixfmt },
	}
}
--]]

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "nixfmt" }
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  }
})

vim.api.nvim_clear_autocmds({ group = format_group })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = format_group,
  command = ":FormatWrite"
})
