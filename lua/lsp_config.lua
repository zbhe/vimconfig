
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
	--map('n','<leader>ge','<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>')
	map('n','<leader>rn','<cmd>lua vim.lsp.buf.rename()<CR>')
	--map('n','<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
	--map('n','<leader>ai','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
	--map('n','<leader>ao','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
end

local lsp = require("lspconfig")
lsp.clangd.setup{on_attach=custom_attach}
lsp.lua_ls.setup{
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
