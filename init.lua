-- ============================================================================
-- Neovim Configuration by bobo
-- ============================================================================
-- 安装说明：
-- 1. 安装 Nerd 字体：https://www.nerdfonts.com/font-downloads
-- 2. 安装 vim-plug：
--    wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O ~/.config/nvim/autoload/plug.vim
-- 3. 执行 :PlugInstall 安装插件
-- 4. 安装 COQ 依赖：:COQdeps
-- 5. 安装 LSP 服务器：:MasonInstall lua-language-server clangd
-- 6. 在 lua/lsp_config.lua 中配置 LSP
-- 7. Windows 下需要管理员模式安装 COQ：
--    git -c core.symlinks=true clone https://github.com/ms-jpq/coq_nvim.git
-- ============================================================================

-- ============================================================================
-- 基础设置
-- ============================================================================
local vim = vim
local Plug = vim.fn['plug#']

-- 禁用 netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader 键设置
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

-- 编辑器设置
vim.o.number = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.ignorecase = true
vim.o.encoding = 'utf-8'
vim.o.laststatus = 0
vim.o.matchpairs = "(:),{:},[:],<:>"

-- 自动读取外部修改的文件
vim.o.autoread = true
-- 当光标停止移动时检查文件变化
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "FocusGained", "BufEnter" }, {
	pattern = "*",
	command = "checktime",
})

-- 插件设置
vim.g.rainbow_active = 1

-- ============================================================================
-- 自定义快捷键映射
-- ============================================================================
local function keymap(lhs, rhs, mode, opts)
	local options = { noremap = true, silent = true }
	mode = mode or "n"
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- 基础快捷键
keymap("<C-d>", "<Esc>", {"i", "v", "c", "o", "n"})
keymap("<C-D>", "<Esc>", {"i", "v", "c", "o", "n"})
keymap("L", "gt")
keymap("H", "gT")
keymap("<leader>j", "10j")
keymap("<leader>k", "10k")
keymap("<leader>ww", "<C-w><C-w>")

-- 插件快捷键
keymap("<leader>t", ":NvimTreeFindFileToggle<cr>")
keymap("<leader>fs", ":TlistToggle<cr>")
keymap("<leader>cmd", ":ToggleTerm<cr>")
keymap("<Esc><Esc>", "<C-\\><C-n>:ToggleTerm<cr>", "t")  -- 在终端模式下按两次 Esc 隐藏终端
keymap("<C-`>", "<C-\\><C-n>:ToggleTerm<cr>", "t")  -- 终端模式下 Ctrl+` 切换终端
keymap("<C-`>", ":ToggleTerm<cr>")  -- Normal 模式下 Ctrl+` 切换终端
keymap("<leader>bg", ":BufferLinePick<CR>")
keymap("<leader>bc", ":BufferLinePickClose<CR>")
keymap("<leader>bb", "<cmd>b#<CR>")
keymap("S", ":OpenSession<CR>")

-- 高亮快捷键
vim.api.nvim_set_keymap('n', '<Space>', ':lua toggle_highlight(true)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader><Space>', ':lua toggle_highlight()<CR>', { noremap = true, silent = true })

-- ============================================================================
-- 自定义命令
-- ============================================================================
vim.api.nvim_create_user_command('T', function(s) vim.cmd("tabnew " .. s.args) end, { nargs = 1, complete = "file" })
vim.api.nvim_create_user_command('E', function(s) vim.cmd("tab drop " .. s.args) end, { nargs = 1, complete = "file" })
vim.api.nvim_create_user_command('Tabgo', function(s) vim.cmd("tab drop " .. s.args) end, { nargs = 1, complete = "file" })

-- ============================================================================
-- 自动命令
-- ============================================================================
-- 记住上次光标位置
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

-- 自动复制到系统剪贴板（通过 OSC52）
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
			require('osc52').copy_register('"')
		end
	end,
})

-- ============================================================================
-- 插件安装
-- ============================================================================
vim.call('plug#begin')

-- 实用工具
Plug('junegunn/vim-easy-align')
Plug('folke/which-key.nvim')
Plug('nvim-lua/plenary.nvim')
Plug('xolox/vim-misc')
Plug('xolox/vim-session')
Plug('terryma/vim-expand-region')
Plug('scrooloose/nerdcommenter')
Plug('MattesGroeger/vim-bookmarks')

-- UI 增强
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')
Plug('akinsho/bufferline.nvim')
Plug('luochen1990/rainbow')
Plug('yegappan/taglist')

-- LSP 和补全
Plug('neovim/nvim-lspconfig')
Plug('williamboman/mason.nvim')
Plug('glepnir/lspsaga.nvim')
Plug('ms-jpq/coq_nvim')
Plug('ms-jpq/coq.artifacts', {branch = 'artifacts'})
Plug('ms-jpq/coq.thirdparty', {branch = '3p'})
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/cmp-vsnip')
Plug('hrsh7th/vim-vsnip')

-- 语法高亮和解析
Plug('nvim-treesitter/nvim-treesitter')
Plug('dcharbon/vim-flatbuffers')

-- 终端和系统集成
Plug('akinsho/toggleterm.nvim', {tag = '*'})
Plug('ojroques/nvim-osc52')

-- 主题
Plug('tomasr/molokai')
Plug('navarasu/onedark.nvim')
Plug('morhetz/gruvbox')
Plug('altercation/vim-colors-solarized')
Plug('acarapetis/vim-colors-github')
Plug('folke/tokyonight.nvim')
Plug('rebelot/kanagawa.nvim')
Plug('sainnhe/gruvbox-material')
Plug('sainnhe/everforest')
Plug('sainnhe/edge')
Plug('sainnhe/sonokai')
Plug('Mofiqul/vscode.nvim')

vim.call('plug#end')

-- ============================================================================
-- 插件配置
-- ============================================================================

-- nvim-web-devicons
require('nvim-web-devicons').setup()

-- nvim-tree
local function nvim_tree_on_attach(bufnr)
	local api = require("nvim-tree.api")
	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	api.config.mappings.default_on_attach(bufnr)

	vim.keymap.set('n', 'r', api.tree.change_root_to_parent, opts('chroot'))
	vim.keymap.set('n', 'R', api.tree.change_root_to_node, opts('chroot'))
	vim.keymap.set('n', 'H', "gT", opts('tabprev'))
	vim.keymap.set('n', 'L', "gt", opts('tabnext'))
	vim.keymap.set('n', 't', api.node.open.tab_drop, opts('open'))
	vim.keymap.set('n', 'o', api.node.open.tab, opts('open'))
end

require("nvim-tree").setup({
	on_attach = nvim_tree_on_attach,
})

-- mason
require("mason").setup()

-- which-key
require("which-key").setup({})

-- nvim-treesitter
require('nvim-treesitter').setup({
	ensure_installed = {"vim", "lua", "cpp", "c", "cmake", "python"},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = '<CR>',
			node_incremental = '<CR>',
			node_decremental = '<BS>',
			scope_incremental = '<TAB>',
		}
	},
	indent = {
		enable = true
	}
})

-- lspsaga
require("lspsaga").setup({
	lightbulb = {
		enable = false
	},
	outline = {
		win_position = 'left'
	},
	finder = {
		keys = {
			Tabgo = 't',
		},
	},
	definition = {
		keys = {
			Tabgo = 't',
		},
	},
	callhierarchy = {
		keys = {
			tabe = nil,
			Tabgo = 't',
		}
	},
	typehierarchy = {
		keys = {
			Tabgo = 't',
			tabe = nil,
		}
	},
	floaterm = {
		width = 0.5,
		height = 1.0,
	},
})

-- toggleterm
require("toggleterm").setup({
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.4
		end
	end,
	direction = "float",
	open_mapping = [[<C-`>]],
	hide_numbers = true,
	shade_terminals = true,
	start_in_insert = true,
	insert_mappings = true,
	terminal_mappings = true,
	persist_size = true,
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		width = math.floor(vim.o.columns * 0.45),
		height = math.floor(vim.o.lines * 0.7),
		row = math.floor(vim.o.lines * 0.5),  -- 定位到底部
		col = vim.o.columns - math.floor(vim.o.columns * 0.4) - 2,  -- 定位到右侧
		winblend = 0,
	},
	on_open = function(term)
		-- 当打开终端时，收集所有打开的文件信息
		local env_file = vim.fn.expand('~/.vim_context')
		local file = io.open(env_file, 'w')
		if not file then return end
		
		-- 收集所有 buffer 中的文件
		local all_files = {}
		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(bufnr) then
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				-- 只收集实际文件，过滤掉特殊 buffer（如终端、nvim-tree 等）
				if bufname ~= '' and not bufname:match('^term://') and not bufname:match('NvimTree') then
					table.insert(all_files, bufname)
				end
			end
		end
		
		-- 写入所有打开的文件
		file:write(string.format('VIM_ALL_FILES=%s\n', table.concat(all_files, ':')))
		
		file:close()
	end,
})

-- osc52 (系统剪贴板集成)
require('osc52').setup({
	max_length = 0,
	silent = false,
	trim = false,
})

-- bufferline
require("bufferline").setup({
	options = {
		mode = "tabs",
		always_show_bufferline = false,
		show_close_icon = false,
		show_buffer_close_icons = false,
		max_name_length = 10,
		max_prefix_length = 5,
		truncate_names = false,
		tab_size = 10,
		pick = {
			alphabet = "abcdefghijklmopqrstuvwxyz1234567890",
		},
	},
	highlights = {
		fill = {
			fg = "#abb2bf",
			bg = "#282c34",
		},
		background = {
			fg = "#abb2bf",
			bg = "#3e4452",
		},
		buffer_selected = {
			fg = "#61afef",
			bg = "#1a1f36",
			bold = true,
			italic = false,
		},
		buffer_visible = {
			fg = "#98c379",
			bg = "#3e4452",
		},
		close_button = {
			fg = "#e06c75",
			bg = "#3e4452",
		},
		close_button_selected = {
			fg = "#ffffff",
			bg = "#61afef",
		},
		separator = {
			fg = "#3e4452",
			bg = "#282c34",
		},
		separator_selected = {
			fg = "#61afef",
			bg = "#282c34",
		},
		tab = {
			fg = "#abb2bf",
			bg = "#3e4452",
		},
		tab_selected = {
			fg = "#ffffff",
			bg = "#61afef",
		},
		modified = {
			fg = "#e5c07b",
			bg = "#3e4452",
		},
		modified_selected = {
			fg = "#e5c07b",
			bg = "#61afef",
		},
		duplicate = {
			fg = "#e5c07b",
			bg = "#3e4452",
			italic = true,
		},
		duplicate_selected = {
			fg = "#c678dd",
			bg = "#61afef",
			italic = true,
		},
	},
})

-- ============================================================================
-- 会话管理
-- ============================================================================
vim.g.session_autosave = 'yes'
vim.g.session_autoload = 'no'

-- ============================================================================
-- Taglist 配置
-- ============================================================================
vim.g.Tlist_GainFocus_On_ToggleOpen = 1
vim.g.Tlist_Show_One_File = 1

-- ============================================================================
-- COQ 配置
-- ============================================================================
vim.g.coq_settings = {
	auto_start = 'shut-up'
}

-- ============================================================================
-- 自定义功能函数
-- ============================================================================

-- 检查光标前是否为空白
function _G.check_back_space()
	local col = vim.fn.col('.') - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- 高亮当前光标下的单词
local function highlight_current_word(word)
	local current_word = vim.fn.escape(vim.fn.expand('<cword>'), "\\")
	if string.len(current_word) < 1 then
		return
	end
	local pattern
	if word then
		pattern = '\\c\\<' .. current_word .. '\\>'
	else
		pattern = '\\c' .. current_word
	end
	vim.fn.setreg('/', pattern)
	return vim.fn.matchadd('Search', pattern)
end

-- 取消高亮
local function clear_highlight(id)
	vim.fn.matchdelete(id)
end

-- 切换高亮状态
_G.toggle_highlight = function(word)
	_G.highlighted_id = _G.highlighted_id or {}
	local bufnr = vim.fn.bufnr()
	if _G.highlighted_id[bufnr] then
		clear_highlight(highlighted_id[bufnr])
		vim.fn.setreg('/', "")
		_G.highlighted_id[bufnr] = nil
	else
		_G.highlighted_id[bufnr] = highlight_current_word(word)
	end
end

-- ============================================================================
-- LSP 配置
-- ============================================================================
require("lsp_config")

-- ============================================================================
-- Vim 命令设置
-- ============================================================================
vim.cmd([[
set pumheight=10
set hidden
set updatetime=100
set shortmess+=c
set signcolumn=number
colorscheme gruvbox
]])

vim.api.nvim_set_hl(0, 'Comment', { italic = true })
vim.opt.termguicolors = true
