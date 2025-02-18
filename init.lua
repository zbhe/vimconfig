--by bobo for neovim
--要安装nerd字体：https://www.nerdfonts.com/font-downloads
--先手动安装plug：
--wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim  -O ~/.config/nvim/autoload/plug.vim
--PlugInstall 安装完插件后需要执行：COQdeps
--执行 MasonInstall lua-language-server clangd 安装LSP服务器
--然后在 lua/lsp_config.lua中setup)
--:Mason 可以查看安装列表
--windows下需要用管理员模式手动安装coq https://github.com/ms-jpq/coq_nvim/issues/589:
--git -c core.symlinks=true clone https://github.com/ms-jpq/coq_nvim.git


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
vim.api.nvim_create_user_command('Tabgo', function(s)vim.cmd("tab drop " .. s.args) end, { nargs = 1, complete = "file" })

vim.call('plug#begin')

-- Shorthand notation for GitHub; translates to https://github.com/junegunn/vim-easy-align
Plug('junegunn/vim-easy-align')
Plug('folke/which-key.nvim')
Plug('nvim-lua/plenary.nvim')
Plug('luochen1990/rainbow')
Plug('neovim/nvim-lspconfig')
Plug('ms-jpq/coq_nvim')
Plug('dcharbon/vim-flatbuffers')
Plug('ms-jpq/coq.artifacts', {branch = 'artifacts'})
Plug('ms-jpq/coq.thirdparty', {branch = '3p'})
Plug('akinsho/toggleterm.nvim', {tag = '*'})
--Plug('vim-ctrlspace/vim-ctrlspace')
--Plug('hrsh7th/nvim-cmp')
Plug('xolox/vim-misc')
Plug('xolox/vim-session')
Plug('tomasr/molokai')
Plug('terryma/vim-expand-region')
Plug('akinsho/bufferline.nvim')
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
	vim.keymap.set('n', 't', api.node.open.tab_drop, opts('open'))
	vim.keymap.set('n', 'o', api.node.open.tab, opts('open'))
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

keymap("<space>", ":nohlsearch<cr>")
vim.g.Tlist_GainFocus_On_ToggleOpen = 1
vim.g.Tlist_Show_One_File = 1
keymap("<leader>fs", ":TlistToggle<cr>")
require("lspsaga").setup({
	lightbulb = {
		enable = false
	},
	outline = {
		win_position = 'left'
	},
})

require("toggleterm").setup({
size = 20,
direction = "float",
})
--keymap("<leader>cmd", ":ToggleTerm<cr>")
keymap("<leader>cmd", ":Lspsaga term_toggle<cr>")
--[[]]
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
vim.api.nvim_set_hl(0, 'Comment', { italic=true })
vim.opt.termguicolors = true
require("bufferline").setup({
	options = {
		mode = "tabs",
		always_show_bufferline = false,
		show_close_icon = false,
		show_buffer_close_icons = false,

		max_name_length = 10,
		max_prefix_length = 5, -- prefix used when a buffer is de-duplicated
		truncate_names = false, -- whether or not tab names should be truncated
		tab_size = 10,

		pick = {
			alphabet = "abcdefghijklmopqrstuvwxyz1234567890",
		},

	},
	highlights = {
        fill = {
            fg = "#abb2bf", -- 标签栏空白区域的前景色
            bg = "#282c34", -- 标签栏空白区域的背景色
        },
        background = {
            fg = "#abb2bf", -- 非活动 buffer 的前景色
            bg = "#3e4452", -- 非活动 buffer 的背景色
        },
        buffer_selected = {
            fg = "#61afef", -- 当前活动 buffer 的前景色
            bg = "#1a1f36", -- 当前活动 buffer 的背景色
            bold = true,    -- 使用加粗样式
            italic = false, -- 不使用斜体
        },
        buffer_visible = {
            fg = "#98c379", -- 可见但未选中 buffer 的前景色
            bg = "#3e4452", -- 可见但未选中 buffer 的背景色
        },
        close_button = {
            fg = "#e06c75", -- 关闭按钮的前景色
            bg = "#3e4452", -- 关闭按钮的背景色
        },
        close_button_selected = {
            fg = "#ffffff", -- 选中 buffer 的关闭按钮前景色
            bg = "#61afef", -- 选中 buffer 的关闭按钮背景色
        },
        separator = {
            fg = "#3e4452", -- 标签之间分隔符的颜色
            bg = "#282c34", -- 分隔符的背景色
        },
        separator_selected = {
            fg = "#61afef", -- 当前 buffer 分隔符的颜色
            bg = "#282c34", -- 分隔符背景色
        },
        tab = {
            fg = "#abb2bf", -- 未激活的标签页前景色
            bg = "#3e4452", -- 未激活的标签页背景色
        },
        tab_selected = {
            fg = "#ffffff", -- 选中标签页前景色
            bg = "#61afef", -- 选中标签页背景色
        },
        modified = {
            fg = "#e5c07b", -- 修改过的文件的提示色
            bg = "#3e4452",
        },
        modified_selected = {
            fg = "#e5c07b", -- 当前修改文件的提示色
            bg = "#61afef",
        },
        duplicate = {
            fg = "#e5c07b", -- 重复文件的前景色
            bg = "#3e4452",
            italic = true, -- 使用斜体标记
        },
        duplicate_selected = {
            fg = "#c678dd",
            bg = "#61afef",
            italic = true,
        },
    },
})
keymap("<leader>bg", ":BufferLinePick<CR>")
keymap("<leader>bc", ":BufferLinePickClose<CR>")
keymap("<leader>bb", "<cmd>b#<CR>")
