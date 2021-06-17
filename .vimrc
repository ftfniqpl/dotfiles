set nocompatible            "非兼容vi模式,去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限

"------------------------------基础设置 ------------------------------
let mapleader = ","         "修改leader键
let g:mapleader = ","       "修改leader键

syntax on                   "开启语法高亮

"------------------------------加载插件 ------------------------------
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'scrooloose/syntastic'
" syntastic {{{
    let g:syntastic_error_symbol='>>'
    let g:syntastic_warning_symbol='>'
    "打开文件的时候做检查
    let g:syntastic_check_on_open = 1
    "每次保存文件的时候做检查(0不检查)
    let g:syntasic_check_on_wq=1
    let g:syntastic_enable_highlighting = 1
    let g:syntastic_python_checkers=['pyflakes', 'pep8'] "python语法解析
    let g:syntastic_python_pep8_args='--ignore=E124,E225,E251,E261,E265,E302,E303,E305,E402,E501,E712,E722'

    "let g:syntastic_javascript_checkers = ['eslint']

    "每次自动调用:SyntasticSetLocList,将错误覆盖 quickfix
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_enable_signs = 1
    "自动拉起/关闭错误窗口,不需要手动调用:Errors
    let g:syntastic_auto_loc_list=0
    let g:syntastic_auto_jump=0
    let g:syntastic_loc_list_height=5

    function! ToggleErrors()
        let old_last_winnr = winnr('$')
        lclose
        if old_last_winnr == winnr('$')
            "Nothing was closed. open syntastic error location panel
            Errors
        endif
    endfunction
    nnoremap <leader>s :call ToggleErrors()<cr>

    "修改高亮的背景色,适应主题
    highlight SyntasticErrorSign guifg=white guibg=black
    let g:syntastic_python_python_exec = '/usr/bin/env python'
    "禁止插件检查java, see https://github.com/wklken/k-vim/issues/164
    let g:syntastic_mode_map = {'mode': 'active', 'active_filetypes': ['python'], 'passive_filetypes': ['go', 'java']}
" }}}

Bundle 'SirVer/ultisnips'
" ultisnips {{{
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
    "定义存放代码片段的文件夹,可以使用自定义的
    let g:UltiSnipsSnippetDirectories=['UltiSnips']
    let g:UltiSnipsSnippetsDir='~/.vim/bundle/ultisnips/UltiSnips'
    "进入对应filetype的snippets进行编辑
    map <leader>us :UltiSnipsEdit<CR>
    let g:UltiSnipsListSnippets="<c-e>" "不知道干啥的

    "crtl+j/k 进行选择
    func! g:JInYCM()
        if pumvisible()
            return "\<C-n>"
        else
            return "\<C-j>"
        endif
    endfunction

    func! g:KInYCM()
        if pumvisible()
            return "\<C-p>"
        else
            return "\<C-k>"
        endif
    endfunction
    inoremap <C-j> <C-r>=g:JInYCM()<cr>
    "au BufEnter,BufRead * exec "inoremap <silent> " . g:UltiSnipsJumpBackwordTrigger . " <C-R>=g:KInYCM()<cr>"
    "let g:UltiSnipsJumpBackwordTrigger = "<C-m>"
" }}}

Bundle 'Raimondi/delimitMate'
"自动补全单引号,双引号等
" delimitMate {{{
    au FileType python let b:delimitMate_nesting_quotes=['"']
    au FileType php let delimitMate_matchpairs="(:),[:],{:}"
" }}}

Bundle 'docunext/closetag.vim'
"自动补全html/xml标签
" closetag {{{
    let g:closetag_html_style=1
" }}}

Bundle 'scrooloose/nerdcommenter'
" 快速注释
" nerdcommenter {{{
    let g:NERDSpaceDelims=1
    let g:NERDAltDelims_python=1
    "n<leader>cc 注释n行
    "n<leader>cu 取消n行注释
" }}}

Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'tacahiroy/ctrlp-funky'
"文件搜索
" ctrlp.vim {{{
    let g:ctrlp_map = '<leader>p'
    let g:ctrlp_cmd = 'CtrlP'
    map <leader>f :CtrlPMRU<CR>
    let g:ctrlp_custom_ignore = {
        \ 'dir': '\v[\/]\.(git|hg|svn|rvm)$',
        \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc|class)$',
    \}
    let g:ctrlp_working_path_mode=0
    let g:ctrlp_match_window_bottom=1
    let g:ctrlp_max_height=15
    let g:ctrlp_match_window_reversed=0
    let g:ctrlp_mruf_max=500
    let g:ctrlp_follow_symlinks=1

    "ctrlp插件, 快速跳转
    nnoremap <leader>fu :CtrlPFunky<Cr>
    nnoremap <leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
    let g:ctrlp_funky_syntax_highlight=1

    let g:ctrlp_extensions = ['funky']
    "<leader>p......打开ctrlp搜索
    "<leader>m......显示最近打开的文件
" }}}

Bundle 'sjl/gundo.vim'
" 可以查看回到某个历史状态
" gundo.vim {{{
    nnoremap <leader><leader>h :GundoToggle<CR>
" }}}

Bundle 'vim-airline/vim-airline'
" 状态栏增强展示
" airline {{{
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    let g:airline_left_sep = '▶'
    let g:airline_left_alt_sep = '❯'
    let g:airline_right_sep = '◀'
    let g:airline_right_alt_sep = '❮'
    let g:airline_symbols.linenr = '¶'
    let g:airline_symbols.branch = '⎇'
    let g:airline#extensions#syntastic#enabled = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#buffer_nr_show = 1
" }}}

Bundle 'kien/rainbow_parentheses.vim'
" 括号显示增强
" rainbow_parentheses {{{
    let g:rbpt_colorpairs = [
        \ ['brown',       'RoyalBlue3'],
        \ ['Darkblue',    'SeaGreen3'],
        \ ['darkgray',    'DarkOrchid3'],
        \ ['darkgreen',   'firebrick3'],
        \ ['darkcyan',    'RoyalBlue3'],
        \ ['darkred',     'SeaGreen3'],
        \ ['darkmagenta', 'DarkOrchid3'],
        \ ['brown',       'firebrick3'],
        \ ['gray',        'RoyalBlue3'],
        \ ['darkmagenta', 'DarkOrchid3'],
        \ ['Darkblue',    'firebrick3'],
        \ ['darkgreen',   'RoyalBlue3'],
        \ ['darkcyan',    'SeaGreen3'],
        \ ['darkred' ,    'DarkOrchid3'],
        \ ['red',         'firebrick3'],
    \]
    let g:rbpt_max = 16
    let g:rbpt_loadcmd_toggle = 0
    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
" }}}

Bundle 'scrooloose/nerdtree'
" 显示目录树
" nerdtree {{{
    map <F2> :NERDTreeToggle<CR>
    let NERDTreeHighlightCursorline=1
    let NERDTreeIgnore=['\.pyc$', '\.pyo$', '\.class$', '\.obj$', '\.o$', '\.egg$', '^\.git$', '^\.svn$', '^\.hg$', '\.swp$']
    "关闭vim时将tree也关闭
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | end
    "s/v 分屏打开文件
    let g:NERDTreeMapOpenSplit = 's'
    let g:NERDTreeMapOpenVSplit = 'v'

    " nerdtree tabs
    " map <F6> <plug>NERDTreeTabsToggle<CR>
    "关闭同步
    let g:nerdtree_tabs_synchronize_view=0
    let g:nerdtree_tabs_synchronize_focus=0
    " 自动开启nerdtree
    let g:nerdtree_tabs_open_on_console_startup=0
    let g:nerdtree_tabs_open_on_gui_startup=0
    " 命令操作快捷键
    "x......收起当前目录树
    "R......刷新根目录树
    "r......刷新当前目录
    "P......跳转到根节点
    "p......跳转到当前节点
    "K......到同目录第一个节点
    "J......到同目录最后一个节点
    "o......展开文件,目录
    "v......上下分屏
    "s......左右分屏
    "Ctrl-w-hjkl......光标切换左下上右窗口
" }}}

Bundle 'majutsushi/tagbar'
" 标签导航
" tagbar {{{
    nmap <F3> :TagbarToggle<CR>
    let g:tagbar_autofocus = 1
" }}}

Bundle 'Yggdroot/indentLine'
" 缩进显示对齐线
" indentLine {{{
    let g:indentLine_noConcealCursor = 1
    let g:indentLine_color_term = 0
    let g:indentLine_char = '¦'
" }}}

Bundle 'plasticboy/vim-markdown'
" markdown语法
" vim-markdown {{{
    let g:vim_markdown_folding_disabled=1
    au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=mkd
" }}}

Bundle 'hdima/python-syntax'
" python语法
" python-syntax {{{
    let python_highlight_all = 1
" }}}

Bundle 'othree/yajs.vim'
Bundle 'othree/javascript-libraries-syntax.vim'
" javascript库补全
" {{{
    let g:used_javascript_libs = 'jquery,underscore,backbone,vue,angularjs,react'
" }}}

Bundle 'elzr/vim-json'
" {{{
    let g:vim_json_syntax_conceal = 0
" }}}

"Bundle 'tell-k/vim-autopep8'
" {{{ 绑定F8键进行python语法进行pep8规范格式化
    "autocmd FileType python noremap <buffer> <F8> :call Autopep8()<CR>
    "let g:autopep8_ignore="E501,W293"
    "let g:autopep8_on_save = 1
" }}}

Bundle 'chemzqm/wxapp.vim'
" 支持微信小程序开发插件

Bundle 'mattn/emmet-vim'
" html标签快速完成
" 详细使用 https://raw.githubusercontent.com/mattn/emmet-vim/master/TUTORIAL
" emmit-vim for wxapp.vim {{{
    let g:user_emmet_settings = {
        \'wxss': {
        \    'extends': 'css',
        \},
        \'wxml': {
        \    'extends': 'html',
        \    'aliases': {
        \        'div': 'view',
        \        'span': 'text',
        \    },
        \    'default_attributes': {
        \        'block': [{'wx:for-items': '{{list}}','wx:for-item': '{{item}}'}],
        \        'navigator': [{'url': '', 'redirect': 'false'}],
        \        'scroll-view': [{'bindscroll': ''}],
        \        'swiper': [{'autoplay': 'false', 'current': '0'}],
        \        'icon': [{'type': 'success', 'size': '23'}],
        \        'progress': [{'precent': '0'}],
        \        'button': [{'size': 'default'}],
        \        'checkbox-group': [{'bindchange': ''}],
        \        'checkbox': [{'value': '', 'checked': ''}],
        \        'form': [{'bindsubmit': ''}],
        \        'input': [{'type': 'text'}],
        \        'label': [{'for': ''}],
        \        'picker': [{'bindchange': ''}],
        \        'radio-group': [{'bindchange': ''}],
        \        'radio': [{'checked': ''}],
        \        'switch': [{'checked': ''}],
        \        'slider': [{'value': ''}],
        \        'action-sheet': [{'bindchange': ''}],
        \        'modal': [{'title': ''}],
        \        'loading': [{'bindchange': ''}],
        \        'toast': [{'duration': '1500'}],
        \        'audio': [{'src': ''}],
        \        'video': [{'src': ''}],
        \        'image': [{'src': '', 'mode': 'scaleToFill'}],
        \    }
        \},
    \}
" }}}


Bundle 'easymotion/vim-easymotion'
" 更高效的移动 [,, + w/fx/h/j/k/l]
" easymotion {{{
    let g:EasyMotion_smartcase = 1
    map <leader>h <Plug>(easymotion-linebackward)
    map <leader>j <Plug>(easymotion-j)
    map <leader>k <Plug>(easymotion-k)
    map <leader>l <Plug>(easymotion-lineforward)
    "重复上一次操作
    map <leader>. <Plug>(easymotion-repeat)
" }}}

Bundle 'terryma/vim-multiple-cursors'
" 多光标选中编辑
" vim-multiple-cursors {{{
    let g:multi_cursor_use_default_mapping=0
    let g:multi_cursor_next_key='<C-m>'
    let g:multi_cursor_prev_key='<C-p>'
    let g:multi_cursor_skip_key='<C-x>'
    let g:multi_cursor_quit_key='<Esc>'
" }}}

Bundle 'davidhalter/jedi-vim'
" python自动补全
" jedi-vim {{{
    let g:pymode_folding = 0
    let g:jedi#show_call_signatures=0
    let g:jedi#auto_vim_configuration=0

    "let g:jedi#popup_on_dot = 0  "关闭点的弹出
    let g:jedi#popup_select_first = 0 "关闭默认选择第一个

    let g:jedi#goto_command = "<leader>d" "跳转
    let g:jedi#goto_assignments_command = "<leader>m" "跳转
    let g:jedi#documentation_command = "K"
    let g:jedi#usages_command = "<leader><leader>n" "使用用例
    " let g:jedi#completions_command = "<TAB>"
    let g:jedi#rename_command = "<leader>r" "撤销变量
    "自动添加pdb调试
    map <leader>b Oimport pdb; pdb.set_trace() # BREAKPOINT<C-c>
" }}}

Bundle 'drn/zoomwin-vim'
" 最大/小化窗口
" zoomwin-vim {{{
    nnoremap <silent> <leader>tz :ZoomWin<CR>
" }}}

Bundle 'posva/vim-vue'
    autocmd FileType vue syntax sync fromstart
    autocmd BufRead, BufNewFile *.vue setlocal filetype=vue.html.javascript.css

set history=2000            "history存储长度

filetype on                 "检测文件类型
filetype plugin on          "允许插件
filetype indent on          "针对不同的文件类型采用不同的缩进方式
filetype plugin indent on   "启动自动补全

set autoread                "文件修改之后自动载入
set shortmess=atI           "启动时不显示乌干达儿童提示

set cursorcolumn            "突出显示当前鼠标所在列
set cursorline              "突出显示当前行

set title                   "修改终端的标题
set novisualbell            "去掉输入错误的提示声音
set noerrorbells            "去掉输入错误的提示声音
set t_vb=
set tm=500

set viminfo^=%              "文件关闭时记住上次修改的地方

set magic

set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set ruler                   "在状态栏显示当前行号
set showcmd                 "在状态栏显示正在输入的命令
set showmode                "在状态栏显示当前模式
"set scrolloff=5             "光标上下移动时,上方或下方至少保留显示的行数

set laststatus=2            "状态行颜色
" highlight StatusLine guifg=SlateBlue guibg=Yellow
set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P
set rulerformat=%20(%2*%<%f%=\ %m%r\ %3l\ %c\ %p%%%) "在状态行上显示光标所在位置的行号和列号

set number                  "显示绝对行号
set wrap                    "默认自动换行
"set textwidth=120           "设置达到指定长度时自动换行
"set fo+=m                   "自动换行时,防止中文出现问题
set showmatch               "括号配对情况,跳转并高亮一下匹配的括号
set matchtime=2

set hlsearch                "高亮搜索命中的文本
set incsearch               "随着键入即时搜索
set ignorecase              "搜索时忽略大小写
set smartcase               "有一个或以上大写字母时仍大小写敏感

set foldenable              " 代码折叠
" 折叠方法
" manual    手工折叠
" indent    使用缩进表示折叠
" expr      使用表达式定义折叠
" syntax    使用语法定义折叠
" diff      对没有更改的文本进行折叠
" marker    使用标记进行折叠, 默认标记是 {{{ 和 }}}
set foldmethod=indent
set foldlevel=99
"za 打开/关闭当前折叠
"zA 循环地打开/关闭当前折叠
"zo 打开当前折叠
"zc 关闭当前折叠
"zM 关闭所有折叠
"zR 打开所有折叠
"代码折叠自定义快捷键 <leader>zz
let g:FoldMethod = 0
map <leader><Space> :call ToggleFold()<cr>
fun! ToggleFold()
    if g:FoldMethod == 0
        exe "normal! zM"
        let g:FoldMethod = 1
    else
        exe "normal! zR"
        let g:FoldMethod = 0
    endif
endfun
""按space 折叠或展开代码
"nnoremap <Space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

set smartindent              "缩进配置
set autoindent               "打开自动缩进
" 防止在加入注释时自动跳到行首
set cindent
set cinkeys-=0#
set indentkeys-=0#


set tabstop=4               "设置tab键的宽度,等同于空格个数
set shiftwidth=4            "每一次缩进对应的空格数
set softtabstop=4           "按退格键时可以一次删掉的空格数
set smarttab
set expandtab               "将tab自动转化成空格
set shiftround              "缩进时,取整

autocmd FileType html,xml,js,css set ai
autocmd FileType html,xml,js,css set sw=2
autocmd FileType html,xml,js,css set ts=2
autocmd FileType html,xml,js,css set sts=2

set hidden                  "允许在未保存的修改时切换buffer
set wildmode=list:longest
set ttyfast

"修复ctrl+m多光标操作选择的bug,但是改变了ctrl+v进行字符选择时将包含光标下的字符
set selection=inclusive
set selectmode=mouse,key

"是否在退出vim后将内容显示在屏幕
"set t_ti= t_te=

"00x增减数字时使用十进制
set nrformats=

set relativenumber          "显示相对行号
au FocusLost * :set number
au FocusGained * :set relativenumber
autocmd InsertEnter * :set number "插入模式下用绝对行号
autocmd InsertLeave * :set relativenumber "普通模式下用相对行号
"方便复制,切换开启/关闭行号,缩进线显示
function! NumberToggle()
    if (&relativenumber == 1)
        set nonumber
        set norelativenumber
        :IndentLinesToggle
    else
        set number
        set relativenumber
        :IndentLinesToggle
    endif
endfunction
nnoremap <silent> <leader>n :call NumberToggle()<Cr>

"防止tmux下vim的背景色显示异常
if &term =~ '256color'
    set t_ut=
endif

" 自动载入被修改过的文件
au CursorHold,FocusGained,BufEnter * if getcmdtype() == '' | checktime | endif

"----------------------------文件编码,格式--------------------------------
set encoding=utf-8          "设置新文件的编码为utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,big5,cp936 "自动判断编码,以此尝试
set helplang=cn
set termencoding=utf-8      "只影响普通模式(非图形界面)下的vim
set ffs=unix,dos,mac        "使用unix下的文件类型
"set fileformat=unix

set formatoptions+=m        "如遇unicode值大于255的文本,不必等到空格再折行
set formatoptions+=B        "合并两行中文时,不在中间加空格

autocmd! bufwritepost .vimrc source % "vimrc文件修改之后自动加载

"自动补全,让vim的补全菜单与一般IDE一致
" set completeopt=longest,menu "menu只显示大于一条的,menuone显示包含一条记录
" set completeopt=menuone，longest，preview，noinsert
set completeopt=menuone,longest,noinsert

set wildmenu                "增强模式中的命令行自动完成操作
set wildignore=*.swp,*.bak,*.o,*~,*.pyc,*.class,.svn "忽略的编译文件
autocmd InsertLeave * if pumvisible() == 0|pclose|endif "离开插入模式后自动关闭预览窗口

autocmd BufEnter * lcd %:p:h "自动切换到打开的文件所在的目录
"路径补全
set autochdir
inoremap <C-f> <C-x><C-f>

"回车即选中当前项
inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"

"不清楚这个是干啥的
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
" s/v打开分屏窗口, ,gd/,jd 打开快速窗口
autocmd BufReadPost quickfix nnoremap <buffer> v <C-w><Enter><C-w>L
autocmd BufReadPost quickfix nnoremap <buffer> s <C-w><Enter><C-w>K

autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>

"退出时保存上次光标的位置,需要.viminfo有可写的权限
if has("autocmd")
    au BufReadPost * if line("'\"") >1 && line("'\"") <=line("$") | exec "normal! g'\"" | endif
endif

"将F1修改为Esc,防止调出vim的帮助
noremap <F1> <Esc>"

"换行开关
nnoremap <F4> :set wrap! wrap?<CR>

"插入模式下切换 paste
set pastetoggle=<F5>
"当离开插入模式时,禁用粘贴模式
au InsertLeave * set nopaste

"------------------------------按键映射 ------------------------------
"当文件需要使用sudo权限修改时
cmap ww w !sudo tee >/dev/null %

"删除空行
nnoremap <silent> <leader>dd :g/^$/d<CR>

"将tab换成space
nnoremap <silent> <leader><TAB> :%retab!<CR>

"去掉搜索高亮
noremap <silent><leader>/ :nohls<CR>

"全选
map <leader>sa ggVG
"选择块
nnoremap <leader>v V`}

"光标总在中间
"":se so=999
"禁止光标闪烁
set gcr=a:block-blinkon0

"在处理未保存或只读文件的时候,弹出确认
set confirm

"复制选中区到系统剪切板中
"vnoremap <leader>y "+y
"将系统剪贴板内容粘贴至vim
"nnoremap <leader>p "+p

"插入模式下跳到行首
inoremap <C-A> <Esc>^i
"插入模式下跳到行尾
inoremap <C-E> <Esc>$i
"插入模式下 左下上右 移动
inoremap <C-L> <Right>
inoremap <C-H> <Left>
inoremap <C-J> <Down>
inoremap <C-K> <Up>
"正常模式下跳转到行首
nnoremap H 0
"正常模式下跳转到行尾
nnoremap L $
"正常模式下跳转到行首(第一个字符前面)
nnoremap 0 ^

"删除多余的空格
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite * :call DeleteTrailingWS()

"进入搜索时自动替换规则
"nnoremap / /\v
"vnoremap / /\v

"换行之后,进入到每行
map j gj
map k gk
"------move------
"ctrl+f/b--向上下移动一屏
"z+/./-......把当前行移动到屏幕顶部/中间/尾部
"100z+/./-...把100行移动到屏幕顶部/中间/尾部
"ctrl+d/u..向上/下移动半屏
"ctrl+e/y..向上/下移动一行
"+/-.....下/上一行行首
"后一个单词词首/尾:W/E
"前一个单词词首:B
"fx......往右移动到x字符上
"Fx......往左移动到x字符上
"tx......往右移动到x字符前
"Tx......往左移动到x字符后
";......(分号)重复fx/Fx/tx/Tx的操作,往后查找
",......(逗号)重复fx/Fx/tx/Tx的操作,往反方向查找
"''......(两个单引号)光标移动到当前行上第一次所在位置的行的开始
"d/yi(.....删除/复制()中的内容,但不包含()
"d/ya(.....删除/复制()中的内容,但包含()
"------insert------
"a/i......在当前光标后/前插入
"A/I......在当前光标行尾/行首插入
"o/O......在当前光标行的下行/上行插入
"------copy------
":n,m co k......复制n到m行,粘贴到k行处(下一行开始)
":n,m m k......剪切n到m行,粘贴到k行处(从下一行开始)
":n,m d......删除n到m行
"在需要copy的开始行输入ma
"在需要copy的结束行输入mb
"在需要paste的行输入mc,然后按<leader>co就paste完成
" nmap <leader>co :'a,'b co 'c<CR>
"------delete-----
"nx/nX 删除光标开始之后/前n个字符
"dnW/B...删除光标开始n个以控股作为分割符的单词的结尾/开始
"------modify-----
"cnW/B...修改到某个以空格为分割符的单词的结尾/开始
"cc....修改当前行
"J...上下2行合并

au FileType * setl fo-=cro
" -r:按回车不会添加注释
" -o:按o不会添加注释
" -c:重新格式化长注释行不会添加注释


"快速编辑/重加载 vimrc文件
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>
nnoremap <silent> <leader>sv :so $MYVIMRC<CR>

set background=dark
set t_Co=256
"colorscheme monokai/molokai/solarized/desert/fisa/onedark/gruvbox
colorscheme Tomorrow-Night


"设置标记一列的背景颜色和数字一行颜色一致
hi! link SignColumn LineNr
hi! link ShowMarksHLl DiffAdd
hi! link ShowMarksHLu DiffChange
"防止错误整行标红 看不清
highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline

"为shell和python文件设置指定的header
map <silent> <leader>title :call SetTitle()<CR>
function! SetTitle()
    if &filetype == 'sh' "如果文件类型为.sh文件
        call setline(1,'#!/bin/bash')
    endif

    if &filetype == 'python' "如果文件类型为python
        call setline(1,'#!/usr/bin/env python')
        call append(1,'# -*-coding:utf-8 -*-')
        call append(2,'# ')
        call append(3,'# Author: tony - birdaccp at gmail.com')
        call append(4,'# Create by:'.strftime('%Y-%m-%d %H:%M:%S'))
        call append(5,'# Last modified:'.strftime('%Y-%m-%d %H:%M:%S'))
        call append(6,'# Filename:'.expand('%'))
        call append(7,'# Description:')
    endif
    normal G
    normal o
    normal o
endfunction
function! LastModified()
    let line = getline(6)
    if line =~'^# Last modified'
        exec '1,6 s/Last modified:.*/Last modified:'.strftime('%Y-%m-%d %H:%M:%S').'/e'
    endif
endfunction
autocmd BufNewFile *.{py,go,sh} call SetTitle()
autocmd BufWritePre,FileWritePre *.{py,go} ks|call LastModified()|'s


nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<CR>

"format html
"first join all the lines - ggVGgJ
"Now break tags to new lines - :%s/>\s*</leader>>\r</cr>g
"Now set filetype - :set ft=html (you can do this before too)
"Now Indent - ggVG=
":%!python -m json.tool

map <F4><Esc>:%!python -m json.tool<CR>


" :g/^$/d 删除空行
" :g/^\s*$/d 删除空行以及只有空格的行
" :g/^\s*#/d 删除以 # 开头或 空格# 或 tab#开头的行
" :g/^\s*;/d 对于 php.ini 配置文件，注释为 ; 开头
" :/bbs/d 使用正则表达式删除行如果当前行包含 bbs ，则删除当前行
" :2,/bbs/d 删除从第二行到包含 bbs 的区间行
" :/bbs/,$d 删除从包含 bbs 的行到最后一行区间的行
" :g/bbs/d 删除所有包含 bbs 的行
" :g/.bbs/d 删除匹配 bbs 且前面只有一个字符的行
" :g/^bbs/d 删除匹配 bbs 且以它开头的行
" :g/bbs$/d 删除匹配 bbs 且以它结尾的行
" :%s/\;.\+//g .ini 的注释是以 ; 开始的，如果注释不在行开头，那么删除 ; 及以后的字符
" %s/\#.*//g 删除 # 之后所有字符
