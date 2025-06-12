
local map = function(type, key, value)
	vim.api.nvim_buf_set_keymap(0,type,key,value,{noremap = true, silent = true});
end

local custom_attach = function(client)
	--print("LSP started.");
	--require'completion'.on_attach(client)
	map('n', '<leader>gf', '<cmd>Lspsaga finder def+imp<CR>')
	map('n', '<leader>gr', '<cmd>Lspsaga finder ref<CR>')
	map('n', '<leader>gp', '<cmd>Lspsaga peek_definition<CR>')
	map('n', '<leader>gd', '<cmd>Lspsaga goto_definition<CR>')
	map('n', '<leader>gt', '<cmd>Lspsaga goto_type_definition<CR>')
	map('n', '<leader>gh', '<cmd>Lspsaga hover_doc<CR>')
	--map('n', '<leader>cmd', '<cmd>Lspsaga term_toggle<CR>')
	map('n', '<leader>gl', '<cmd>Lspsaga outline<CR>')
	--map('n','<leader>gD','<cmd>tab split | lua vim.lsp.buf.declaration()<CR>')
	--map('n','<leader>gd','<cmd>tab split |lua vim.lsp.buf.definition()<CR>')
	--map('n','<leader>gr','<cmd>lua vim.lsp.buf.references()<CR>')
	--map('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>')
	--map('n','<leader>gi','<cmd>tab split | lua vim.lsp.buf.implementation()<CR>')
	--map('n','<leader>gt','<cmd>tab split | lua vim.lsp.buf.type_definition()<CR>')
	--map('n','<leader>gw','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
	--map('n','<leader>gs','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
	--map('n','<leader>gh','<cmd>lua vim.lsp.buf.hover()<CR>')
	--map('n','<leader>af','<cmd>lua vim.lsp.buf.code_action()<CR>')
	map('n','<leader>ge','<cmd>Lspsaga show_line_diagnostics<CR>')
	map('n','<leader>rn','<cmd>lua vim.lsp.buf.rename()<CR>')
	--map('n','<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
	--map('n','<leader>ai','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
	--map('n','<leader>ao','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
end


-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp = require("lspconfig")
lsp.clangd.setup{
	capabilities = capabilities,
	on_attach=custom_attach
}
lsp.lua_ls.setup{
	capabilities = capabilities,
	on_attach=custom_attach,
	settings = {
		Lua = {
			workspace = {
				preloadFileSize = 500,
				ignoreDir = {"autocode", "autocode_t", "common/autocode", "common/autocode_t"},
				maxPreload = 1000,
			},
			diagnostics = {
				globals = {"engine", "lcallout", "lbtable"},
			},
			runtime = {
				version = "Lua 5.2"
			}
		}
	}
}

local cmp = require'cmp'

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		end,
	},
	window = {
		 completion = cmp.config.window.bordered(),
		 documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<C-CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources(
		{
			{ name = 'nvim_lsp' },
			{ name = 'vsnip' }, -- For vsnip users.
		},
		{
			{ name = 'buffer' },
		})
})
-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
			{ name = 'cmdline' }
		}),
	matching = { disallow_symbol_nonprefix_matching = false }
})
