local vim = vim
local Plug = vim.fn['plug#']
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = ";"
vim.g.maplocalleader =';'
vim.g.rainbow_active = 1
vim.o.matchpairs = "(:),{:},[:],<:>"
vim.o.number = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.ignorecase = true
vim.o.encoding = 'utf-8'
vim.o.laststatus = 0
vim.opt.shiftwidth = 4
vim.api.nvim_set_option("clipboard","unnamed")

local function keymap(lhs, rhs, mode, opts)
	local options = { noremap = true, silent = true }
	mode = mode or "n"

	if opts then
		options = vim.tbl_extend("force", options, opts)
	end

	vim.keymap.set(mode, lhs, rhs, options)
end

keymap("<C-d>", "<Esc>", {"i","v", "c", "o", "n"})
keymap("<C-D>", "<Esc>", {"i","v", "c", "o", "n"})
keymap("L", "gt")
keymap("H", "gT")
keymap("<leader>t", ":NvimTreeFindFileToggle<cr>")
keymap("<leader>j", "10j")
keymap("<leader>k", "10k")
keymap("<leader>ww", "<C-w><C-w>")
local lastplace = vim.api.nvim_create_augroup("LastPlace", {})
vim.api.nvim_clear_autocmds({ group = lastplace })
vim.api.nvim_create_autocmd("BufReadPost", {
	group = lastplace,
	pattern = { "*" },
	desc = "remember last cursor place",
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

vim.api.nvim_create_user_command('T', function(s)vim.cmd("tabnew " .. s.args) end, { nargs = 1, complete = "file" })
vim.api.nvim_create_user_command('E', function(s)vim.cmd("tab drop " .. s.args) end, { nargs = 1, complete = "file" })

vim.call('plug#begin')

-- Shorthand notation for GitHub; translates to https://github.com/junegunn/vim-easy-align
Plug('junegunn/vim-easy-align')
Plug('folke/which-key.nvim')
Plug('nvim-lua/plenary.nvim')
Plug('luochen1990/rainbow')
Plug('neovim/nvim-lspconfig')
Plug('ms-jpq/coq_nvim')
Plug('ms-jpq/coq.artifacts', {branch = 'artifacts'})
Plug('ms-jpq/coq.thirdparty', {branch = '3p'})
--Plug('hrsh7th/nvim-cmp')
Plug('xolox/vim-misc')
Plug('xolox/vim-session')
Plug('tomasr/molokai')
Plug('terryma/vim-expand-region')
--Plug('BurntSushi/ripgrep')
--Plug('sharkdp/fd')
--Plug('nvim-telescope/telescope.nvim')
-- Any valid git URL is allowed
Plug('nvim-tree/nvim-web-devicons')

-- Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
--Plug('fatih/vim-go', { ['tag'] = '*' })

-- Using a non-default branch
--Plug('neoclide/coc.nvim', { ['branch'] = 'release' })

-- Use 'dir' option to install plugin in a non-default directory
--Plug('junegunn/fzf', { ['dir'] = '~/.fzf' })

-- Post-update hook: run a shell command after installing or updating the plugin
--Plug('junegunn/fzf', { ['dir'] = '~/.fzf', ['do'] = './install --all' })

-- If the vim plugin is in a subdirectory, use 'rtp' option to specify its path
--Plug('nsf/gocode', { ['rtp'] = 'vim' })

-- On-demand loading: loaded when the specified command is executed
--Plug('preservim/nerdtree', { ['on'] = 'NERDTreeToggle' })
--Plug('scrooloose/nerdtree')
Plug('nvim-tree/nvim-tree.lua')
Plug('scrooloose/nerdcommenter')
Plug('MattesGroeger/vim-bookmarks')
Plug('nvim-treesitter/nvim-treesitter')
--Plug('vim-airline/vim-airline')
--Plug('vim-airline/vim-airline-themes')
Plug('navarasu/onedark.nvim')
Plug('morhetz/gruvbox')
Plug('altercation/vim-colors-solarized')
Plug('acarapetis/vim-colors-github')
Plug("folke/tokyonight.nvim")
Plug("rebelot/kanagawa.nvim")
Plug("sainnhe/gruvbox-material")
Plug("sainnhe/everforest")
Plug("sainnhe/edge")
Plug("sainnhe/sonokai")
Plug("Mofiqul/vscode.nvim")
Plug("yegappan/taglist")
Plug("williamboman/mason.nvim")
Plug("glepnir/lspsaga.nvim")

-- On-demand loading: loaded when a file with a specific file type is opened
--Plug('tpope/vim-fireplace', { ['for'] = 'clojure' })

-- Unmanaged plugin (manually installed and updated)
--Plug('~/my-prototype-plugin')
vim.call('plug#end')
require('nvim-web-devicons').setup()
local function nvim_tree_on_attach(bufnr)
	local api = require "nvim-tree.api"
	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	vim.keymap.set('n', 'r', api.tree.change_root_to_parent, opts('chroot'))
	vim.keymap.set('n', 'R', api.tree.change_root_to_node, opts('chroot'))
	vim.keymap.set('n', 'H', "gT", opts('tabprev'))
	vim.keymap.set('n', 'L', "gt", opts('tabnext'))
	vim.keymap.set('n', 't', api.node.open.tab, opts('open'))
end

-- pass to setup along with your other options
require("nvim-tree").setup {
	on_attach = nvim_tree_on_attach,
}
require("mason").setup()
require("which-key").setup { }
require'nvim-treesitter.configs'.setup {
	-- 安装 language parser
	-- :TSInstallInfo 命令查看支持的语言
	ensure_installed = {"vim", "lua", "cpp", "c", "cmake", "python"},
	-- 启用代码高亮功能
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false
	},
	-- 启用增量选择
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = '<CR>',
			node_incremental = '<CR>',
			node_decremental = '<BS>',
			scope_incremental = '<TAB>',
		}
	},
	-- 启用基于Treesitter的代码格式化(=) . NOTE: This is an experimental feature.
	indent = {
		enable = true
	}
}
---- 开启 Folding
--vim.wo.foldmethod = 'expr'
--vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
---- 默认不要折叠
---- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
--vim.wo.foldlevel = 99

vim.g.session_autosave='yes'
vim.g.session_autoload='no'
keymap("S", ":OpenSession<CR>")

function _G.check_back_space()
	local col = vim.fn.col('.') - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local keyset = vim.keymap.set
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
--keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
--keyset("i", "<TAB>", [[coc#pum#visible() ? coc#pum#next(1) :  "\<TAB>"]], opts)
--keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
--keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
--nmap <silent> <leader>gd <Plug>(coc-definition)
--keymap("<leader>gd", ":call CocAction('jumpDefinition', 'tab drop')<cr>")
keymap("<space>", ":nohlsearch<cr>")
vim.g.Tlist_GainFocus_On_ToggleOpen = 1
vim.g.Tlist_Show_One_File = 1
keymap("<leader>fs", ":TlistToggle<cr>")
require("lspsaga").setup({
	lightbulb = {
		enable = false
	}
})
keymap("<leader>cmd", ":Lspsaga term_toggle<cr>")
require("lsp_config")
vim.cmd([[
set pumheight=10
set hidden
set updatetime=100
set shortmess+=c
set signcolumn=number
colorscheme gruvbox
]])
vim.g.coq_settings = {
	auto_start = 'shut-up'
}
--autocmd CursorHold * silent call CocActionAsync('highlight')
--nmap <leader>rn <Plug>(coc-rename)
--nmap <silent> <leader>gy <Plug>(coc-type-definition)
--nmap <silent> <leader>gi <Plug>(coc-implementation)
--nmap <silent> <leader>gs <Plug>(coc-references)
vim.api.nvim_set_hl(0, 'Comment', { italic=true })
