require "os"
vim.g.mapleader = " "

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.cmd [[colorscheme rose-pine]]
vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.scrolloff = 999
vim.bo.expandtab = true
vim.o.smarttab = true
vim.bo.softtabstop = 0
vim.bo.tabstop = 8 -- make it obvious if there's any tab funny business
-- TODO: tab characters matter for Makefiles. Should automatically set buffer for Makefiles to let me use tabs normally
vim.bo.shiftwidth = 2

-- CMP
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = cmp.setup({
	mapping = cmp.mapping.preset.insert({
		['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
		['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
		['<C-y>'] = cmp.mapping.confirm({ select = true }),
		['<C-Space>'] = cmp.mapping.complete()
	})
});

-- fix transparent background
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- lsp config from: https://github.com/neovim/nvim-lspconfig/tree/ede4114e1fd41acb121c70a27e1b026ac68c42d6

-- Setup language servers.
local lspconfig = require('lspconfig')
local format_group = vim.api.nvim_create_augroup("__formatter__", {})
local on_attach = function(client, bufnr)
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = format_group,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format()
			end,
		})
	end
end
lspconfig.pyright.setup {
	on_attach = on_attach,
}
lspconfig.lua_ls.setup {
	on_attach = on_attach,
}
lspconfig.tsserver.setup {
	on_attach = on_attach,
}
lspconfig.nil_ls.setup {
	on_attach = on_attach,
}
lspconfig.hls.setup {
	filetypes = { 'haskell', 'lhaskell', 'cabal' },
	on_attach = on_attach,
}
lspconfig.elixirls.setup {
	on_attach = on_attach,
	cmd = { NVIM_CONFIG_ELIXIR_LS_PATH },
}

-- Formatters when it's not available with the LSP
-- re-use the lsp format group so formatters aren't fighting with each other
require('formatter').setup = {
	logging = true,
	log_level = vim.log.levels.INFO,
	filetype = {
		nix = { require('formatter.filetypes.nix').nixfmt },
	}
}

vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = format_group,
	command = ":FormatWrite"
})


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)

		-- lin diagnostics in hover window
		vim.api.nvim_create_autocmd("CursorHold", {
			buffer = bufnr,
			callback = function()
				local opts = {
					focusable = false,
					close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
					border = 'rounded',
					source = 'always',
					prefix = ' ',
					scope = 'cursor',
				}
				vim.diagnostic.open_float(nil, opts)
			end
		})
	end,
})
