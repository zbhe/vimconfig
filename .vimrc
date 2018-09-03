" Configuration file for vim
" git clone https://github.com/VundleVim/Vundle.vim.git  ~/.vim/bundle/Vundle.vim
" VundleInstall
" vundle 环境设置
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
" vundle 管理的插件列表必须位于 vundle#begin() 和 vundle#end() 之间
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tomasr/molokai'
Plugin 'vim-scripts/phd'
Plugin 'Lokaltog/vim-powerline'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-session'
"Plugin 'nathanaelkane/vim-indent-guides'
"Plugin 'derekwyatt/vim-fswitch'
"Plugin 'kshenoy/vim-signature'
"Plugin 'vim-scripts/BOOKMARKS--Mark-and-Highlight-Full-Lines'
"Plugin 'majutsushi/tagbar'
"Plugin 'vim-scripts/indexer.tar.gz'
"Plugin 'vim-scripts/DfrankUtil'
"Plugin 'vim-scripts/vimprj'
"Plugin 'dyng/ctrlsf.vim'
"Plugin 'terryma/vim-multiple-cursors'
Plugin 'scrooloose/nerdcommenter'
"Plugin 'vim-scripts/DrawIt'
"Plugin 'SirVer/ultisnips'
Plugin 'Valloric/YouCompleteMe'
Plugin 'rdnetto/YCM-Generator'
"Plugin 'derekwyatt/vim-protodef'
Plugin 'scrooloose/nerdtree'
"Plugin 'fholgado/minibufexpl.vim'
Plugin 'gcmt/wildfire.vim'
"Plugin 'sjl/gundo.vim'
"Plugin 'Lokaltog/vim-easymotion'
"Plugin 'suan/vim-instant-markdown'
"Plugin 'lilydjwg/fcitx.vim'
" 插件列表结束
call vundle#end()
filetype plugin indent on
let mapleader=";"

" 让配置变更立即生效
"autocmd BufWritePost $MYVIMRC source $MYVIMRC
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
 autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py"
let g:ycm_confirm_extra_conf=0 "关闭加载.ycm_extra_conf.py提示
let g:ycm_seed_identifiers_with_syntax=1    " 语法关键字补全
let g:ycm_complete_in_comments = 1 "在注释输入中也能补全
let g:ycm_complete_in_strings = 1 "在字符串输入中也能补全
let g:ycm_goto_buffer_command = "split-or-existing-window" "GoTo 时分割窗口
let ycm_show_diagnostics_ui = 0
map <leader>o :tab YcmCompleter GoTo<CR>
map <leader>g :YcmCompleter GoTo<CR>

let g:auto_highlight_word_enabled = 0
let g:cur_highlight_word = ""
function HighlightWord(word)
	hi highlightWord term=bold ctermfg=blue ctermbg=yellow guifg=red guibg=#FFFF00
	let l:cmd = 'match highlightWord /\<\V' . a:word . '\>/' 
	execute l:cmd
	let @/ = a:word
endfunction
function AutoHighlight()
	let l:word = expand("<cword>")
	if l:word != "" && l:word != "/" && l:word != "\\"
		if l:word == g:cur_highlight_word
			return
		endif
		let g:cur_highlight_word = l:word
		call HighlightWord(g:cur_highlight_word)
	endif
endfunction
function AutoHighlight_Toggle()
	if g:auto_highlight_word_enabled == 0
		let g:auto_highlight_word_enabled = 1
		call AutoHighlight()
		" echo "Auto Highlight ON"
		echo ""
	else
		let g:auto_highlight_word_enabled = 0
		let g:cur_highlight_word = ""
		match none
		" echo "Auto Highlight OFF"
		echo ""
	endif
endfunction

map <space> :nohlsearch<cr>:call AutoHighlight_Toggle()<cr>
function FindFunction()
	let ext = expand("%:e")
	let selectword = expand("<cword>")
	echo ext
	if ext == "lua"
		if selectword != "" && selectword != "/" && selectword != "\\"
			let cmd = "/function.*\\<" . selectword . "\\>"
			execute cmd
		endif
	elseif ext == "c" || ext == "cpp" || ext == "h" || ext == "hpp"
		if selectword != "" && selectword != "/" && selectword != "\\"
			let cmd = "/.*\\<" . selectword . "\\> *(.*)"
			execute cmd
		endif
	endif
endfunction
map f :call FindFunction()<cr>
command Date r !date "+\%F \%T"
command -nargs=1 -complete=file T tabedit <args>
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
set modelines=0		" CVE-2007-2438
set matchpairs+=<:>
imap <C-d> <Esc>
vmap <C-d> <Esc>
nmap <C-d> :q<CR>
nmap <C-c> :q!<CR>

map <leader>j 5j
map <leader>k 5k
map <leader>t :NERDTreeToggle<CR>
"let NERDTreeMapOpenInTab='<ENTER>'
"nmap <C-x> :q!<CR>
nmap <C-a> 0
nmap <C-e> $
nmap L gt
nmap H gT
nmap S :OpenSession<CR>
let g:session_autosave = 'yes'
let g:session_autoload = 'no'
" 开启实时搜索功能
set incsearch
" 搜索时大小写不敏感
set ignorecase
" vim 自身命令行模式智能补全
set wildmenu
set encoding=utf-8
" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing
" 开启行号显示
set number
" 高亮显示当前行/列
set cursorline
"set cursorcolumn
" 高亮显示搜索结果
set hlsearch
" 折行
set wrap
" 开启语法高亮功能
syntax enable
" 允许用指定语法高亮配色方案替换默认方案
syntax on
" 配色方案
colorscheme molokai
" 自适应不同语言的智能缩进
filetype indent on
" 制表符扩展为空格
set noexpandtab
" 设置编辑时制表符占用空格数
set tabstop=8
" 设置格式化时制表符占用空格数
"set shiftwidth=8
" 让 vim 把连续数量的空格视为一个制表符
set softtabstop=8
" 基于缩进或语法进行代码折叠
set autoindent		" always set autoindenting on
"set foldmethod=indent
"set foldmethod=syntax
set foldmethod=manual
" 启动 vim 时关闭折叠代码
set nofoldenable

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup nobackup

let skip_defaults_vim=1
