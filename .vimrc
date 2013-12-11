" Modeline and Notes {{{
" vim: sw=4 ts=4 sts=4 et tw=80 foldmarker={{{,}}} foldlevel=0 foldmethod=marker
"
"   This is the personal .vimrc file of Dewdrops (v_v_4474@126.com). some code are
"   stolen from spf13-vim (https://github.com/spf13/spf13-vim).
" }}}

" Environment {{{

    set nocompatible        " Must be first line

    " Windows Compatible {{{
    " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
    " across (heterogeneous) systems easier
    if has('win32') || has('win64')
        set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after

        if has("multi_byte")
            " Windows cmd.exe still uses cp850. If Windows ever moved to
            " Powershell as the primary terminal, this would be utf-8
            set termencoding=cp850
            " Let Vim use utf-8 internally, because many scripts require this
            set encoding=utf-8
            setglobal fileencoding=utf-8
            set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
        endif
    endif
    " }}}

    " Setup NeoBundle Support {{{
        set rtp+=~/.vim/bundle/neobundle.vim
        call neobundle#rc(expand('~/.vim/bundle/'))
        NeoBundleFetch 'Shougo/neobundle.vim'
    " }}}

" }}}

" General {{{

    set background=dark         " Assume a dark background
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has ('x') && has ('gui') " On Linux use + register for copy-paste
        set clipboard=unnamedplus
    elseif has ('gui')          " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif

    " automatically switch to the current file directory when a new buffer is opened
    au BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

    set autowrite                       " Automatically write a file when leaving a modified buffer
    set autoread                        " reload automatically when file is changed outside
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set hidden                          " Allow buffer switching without saving
    set ttimeoutlen=50                  " dimish the pause when leaving insert mode

    " spell check when writing commit logs
    au filetype svn,*commit* setlocal spell

    " ignore compiled files
    set wildignore=*.o,*.obj,*.pyc,*.elc,*~
    if has("win16") || has("win32")
        set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
    else
        set wildignore+=.git\*,.hg\*,.svn\*
    endif

    " Autosave & Load Views.
    autocmd BufWritePost,WinLeave,BufWinLeave ?* if MakeViewCheck() | mkview | endif
    autocmd BufWinEnter ?* if MakeViewCheck() | silent! loadview | endif

    " Setting up the directories
    set backup                      " Backups are nice ...
    if has('persistent_undo')
        set undofile                " So is persistent undo ...
        set undolevels=1000         " Maximum number of changes that can be undone
        set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
    endif

" }}}

" Vim UI {{{

    " This is set in bundle.colorscheme section now, for it may depend on bundles
    " colo desert

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set lazyredraw                  " Don't redraw while executing macros

    highlight clear SignColumn      " SignColumn should match background for
                                    " things like vim-gitgutter

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current directory
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start     " Backspace for dummies
    set linespace=0                    " No extra spaces between rows
    set nu                             " Line numbers on
    if v:version >= 703
        au BufEnter * set relativenumber   " relative line number for fast motion
    endif
    set showmatch                      " Show matching brackets/parenthesis
    set incsearch                      " Find as you type search
    set hlsearch                       " Highlight search terms
    set cursorline                     " Highlight current line
    set winminheight=0                 " Windows can be 0 line high
    set ignorecase                     " Case insensitive search
    set smartcase                      " Case sensitive when uc present
    set wildmenu                       " Show list instead of just completing
    set wildmode=list:longest,full     " Command <Tab> completion, list matches, then longest common part, then all
    set whichwrap=b,s,h,l,<,>,[,]      " Backspace and cursor keys wrap too
    set scrolljump=1                   " Lines to scroll when cursor leaves screen
    set scrolloff=3                    " Minimum lines to keep above and below cursor
    set foldenable                     " Auto fold code
    set list
    set switchbuf=useopen,usetab
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" }}}

" Formatting {{{

    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent

    set smartindent                 " smart autoindent for C programs
    set cindent
    set cinoptions={0,t0,p2s,(03s,>1s,=1s,:1s

    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)

    set foldlevel=99

    " Remove trailing whitespaces and ^M chars
    au FileType c,cpp,java,go,php,javascript,python,twig,xml,yml au BufWritePre <buffer> call StripTrailingWhitespace()
    au FileType go au BufWritePre <buffer> Fmt
    au FileType python setlocal fdm=indent
    au FileType org setlocal fdm=expr
    au BufNewFile,BufRead *.html.twig set filetype=html.twig

" }}}

" Key (re)Mappings {{{

    let mapleader = ','

    " Easier moving in tabs and windows
    map <C-J> <C-W>j
    map <C-K> <C-W>k
    map <C-L> <C-W>l
    map <C-H> <C-W>h

    " Wrapped lines goes down/up to next row, rather than next line in file
    nnoremap j gj
    nnoremap k gk
    nnoremap gj j
    nnoremap gk k

    "map <S-H> gT
    "map <S-L> gt

    "use q as an unified way to exit various visual mode
    vnoremap q <esc>

    " Stupid shift key fixes
    command! -bang -nargs=* -complete=file E e<bang> <args>
    command! -bang -nargs=* -complete=file W w<bang> <args>
    command! -bang -nargs=* -complete=file Wq wq<bang> <args>
    command! -bang -nargs=* -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>

    cmap Tabe tabe

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " swap 0 and ^ in normal mode
    noremap 0 ^
    noremap ^ 0

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<cr>
    nmap <leader>f1 :set foldlevel=1<cr>
    nmap <leader>f2 :set foldlevel=2<cr>
    nmap <leader>f3 :set foldlevel=3<cr>
    nmap <leader>f4 :set foldlevel=4<cr>
    nmap <leader>f5 :set foldlevel=5<cr>
    nmap <leader>f6 :set foldlevel=6<cr>
    nmap <leader>f7 :set foldlevel=7<cr>
    nmap <leader>f8 :set foldlevel=8<cr>
    nmap <leader>f9 :set foldlevel=9<cr>

    nmap <leader>sw :call StripTrailingWhitespace()<cr>

    " Toggle search highlighting
    nmap <silent> <leader>/ :nohlsearch<cr>

    "Remove the Windows ^M
    noremap <leader>tr :%s//r//g<CR>

    " Shortcuts in command line
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=expand('%:p:h').'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=
    map <Leader>x0 <C-w>c
    map <Leader>x1 <C-w>o

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<cr>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " show foldlevel in fold commands
    nnoremap zr zr:echo &foldlevel<cr>
    nnoremap zm zm:echo &foldlevel<cr>
    nnoremap zR zR:echo &foldlevel<cr>
    nnoremap zM zM:echo &foldlevel<cr>
    nnoremap za za:echo &foldlevel<cr>

    " use gy and gp to work with system's clipboard
    nnoremap gy "+y
    nnoremap gp "+p
    vnoremap gy "+y
    vnoremap gp "+p

    " Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
    nmap <M-j> mz:m+<cr>`z
    nmap <M-k> mz:m-2<cr>`z
    vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
    vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

    " emacs-like motion command in insert mode
    inoremap <c-f> <right>
    inoremap <c-b> <left>
    inoremap <c-d> <del>

    nnoremap <leader>q :q<cr>
    nnoremap <leader>wq :wq<cr>
    nnoremap <leader>wr :w<cr>
    nnoremap <leader>xa :xa<cr>
    nnoremap <leader>bp :bp<cr>
    nnoremap <leader>bn :bn<cr>
    nnoremap <leader>zd :set fdm=diff<cr>
    nnoremap <leader>za :set fdm=manual<cr>
    nnoremap <leader>zs :set fdm=syntax<cr>
    nnoremap <leader>zm :set fdm=marker<cr>
    nnoremap <leader>zi :set fdm=indent<cr>
    nnoremap <leader>ze :set fdm=expr<cr>
    nnoremap <leader>lv :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr>
    nnoremap <leader>mk :make<cr>
    nnoremap <leader>sp :sp<cr>
    nnoremap <leader>vs :vs<cr>
    nnoremap <leader>st :setlocal spell!<cr>
    nnoremap <leader>; mMA;<esc>`M
    nnoremap <f5> :%TOhtml<cr>

" }}}

" Bundles {{{

    " Bundle group configuration {{{
        if !exists('g:dewdrops_bundle_groups')
            let g:dewdrops_bundle_groups = [
                        \     'general',
                        \     'theme',
                        \     'ycm',
                        \     'git',
                        \     'programming',
                        \     'perl',
                        \     'python',
                        \     'ruby',
                        \     'misc'
                        \ ]
        endif
    " }}}

    " Color Themes {{{
        if count(g:dewdrops_bundle_groups, 'theme')
            " NeoBundle 'jnurmine/Zenburn'
            " NeoBundle 'spf13/vim-colors'
            " NeoBundle 'flazz/vim-colorschemes'
            " NeoBundle 'godlygeek/csapprox'

            NeoBundle 'Dewdrops/vim-tomorrow-theme'
            colo Tomorrow-Night-Eighties
        endif
    "}}}

    " General {{{
        if count(g:dewdrops_bundle_groups, 'general')
            NeoBundle 'MarcWeber/vim-addon-mw-utils'
            NeoBundle 'tomtom/tlib_vim'

            " Startify {{{
                NeoBundle 'mhinz/vim-startify'
                let g:startify_custom_header = [
                            \ '         ____                   _                     ',
                            \ '        |  _ \  _____      ____| |_ __ ___  _ __  ___ ',
                            \ '        | | | |/ _ \ \ /\ / / _` | ''__/ _ \| ''_ \/ __|',
                            \ '        | |_| |  __/\ V  V / (_| | | | (_) | |_) \__ \',
                            \ '        |____/ \___| \_/\_/ \__,_|_|  \___/| .__/|___/',
                            \ '                                           |_|        ',
                            \ '                                                      ',
                            \ '                                                      '
                            \ ]
            " }}}

            " CtrlP {{{
                NeoBundle 'kien/ctrlp.vim'
                let g:ctrlp_custom_ignore       = {
                    \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                    \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc|\.elc$'
                    \ }

                let g:ctrlp_user_command        = {
                    \ 'types': {
                        \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                    \ },
                    \ 'fallback': 'find %s -type f'
                \ }

                let g:ctrlp_cmd                 = 'CtrlPMixed'
                let g:ctrlp_working_path_mode   = 'rc'
                let g:ctrlp_clear_cache_on_exit = 1
                let g:ctrlp_max_height          = 40
                let g:ctrlp_follow_symlinks     = 1
                let g:ctrlp_max_files           = 20000
                let g:ctrlp_mruf_max            = 20
                let g:ctrlp_cache_dir           = '~/.vim/.cache/ctrlp'
                let g:ctrlp_reuse_window        = 'startify'
                let g:ctrlp_extensions          = ['funky']

                nmap \ [ctrlp]
                nnoremap [ctrlp] <nop>
                nnoremap [ctrlp]t :CtrlPBufTag<cr>
                nnoremap [ctrlp]T :CtrlPTag<cr>
                nnoremap [ctrlp]l :CtrlPLine<cr>
                nnoremap [ctrlp]o :CtrlPFunky<cr>
                nnoremap [ctrlp]b :CtrlPBuffer<cr>

                NeoBundle 'tacahiroy/ctrlp-funky'
            " }}}

            " NerdTree {{{
                NeoBundleLazy 'scrooloose/nerdtree',
                            \ {'autoload': {'commands': ['NERDTreeToggle', 'NERDTreeFind']}}
                map <Leader>nt :NERDTreeToggle<cr>:NERDTreeMirror<cr>
                map <leader>nf :NERDTreeFind<cr>

                let NERDTreeShowBookmarks               = 1
                let NERDTreeIgnore                      = ['\.pyc', '\.elc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
                let NERDTreeChDirMode                   = 0
                let NERDTreeQuitOnOpen                  = 1
                let NERDTreeMouseMode                   = 2
                let NERDTreeShowHidden                  = 1
                let NERDTreeKeepTreeInNewTab            = 1
                let g:nerdtree_tabs_open_on_gui_startup = 0

                NeoBundleLazy 'jistr/vim-nerdtree-tabs',
                            \ {'depends': ['scrooloose/nerdtree'],
                            \ 'autoload': {'commands': ['NERDTreeToggle', 'NERDTreeFind']}}
            " }}}

            " Bufexplorer {{{
                NeoBundle 'bufexplorer.zip'
                let g:bufExplorerDefaultHelp      = 0            " Do not show default help.
                let g:bufExplorerShowRelativePath = 1            " Show relative paths.
                let g:bufExplorerSortBy           = 'mru'        " Sort by most recently used.
                let g:bufExplorerSplitRight       = 0            " Split left.
                let g:bufExplorerSplitVertical    = 1            " Split vertically.
                let g:bufExplorerSplitVertSize    = 30           " Split width
                let g:bufExplorerUseCurrentWindow = 1            " Open in new window
                au BufWinEnter \[Buf\ List\] setlocal nonumber
            " }}}

            " Edit {{{
                NeoBundle 'jiangmiao/auto-pairs'
                NeoBundle 'tpope/vim-surround'
                NeoBundle 'terryma/vim-multiple-cursors'
                NeoBundle 'tpope/vim-speeddating'
                NeoBundle 'tpope/vim-repeat'
                NeoBundle 'tpope/vim-abolish.git'
                NeoBundle 'chrisbra/NrrwRgn'
                NeoBundle 'tommcdo/vim-lion'
                NeoBundle 'tommcdo/vim-exchange'

                NeoBundle 'Dewdrops/vim-unimpaired'
                nmap <c-up> [e
                nmap <c-down> ]e
                vmap <c-up> [e
                vmap <c-down> ]e

                NeoBundle 'osyo-manga/vim-over'
                nnoremap <leader>ov :OverCommandLine<cr>:%s/
            " }}}

            " Motion {{{
                NeoBundle 'thinca/vim-visualstar'
                NeoBundle 'bruno-/vim-vertical-move'
                NeoBundle 'terryma/vim-expand-region'
                NeoBundle 'kana/vim-textobj-user'
                NeoBundle 'kana/vim-textobj-indent'
                NeoBundle 'thinca/vim-textobj-between'

                NeoBundle 'dahu/vim-fanfingtastic'
                map <unique><silent> <leader><leader> <Plug>fanfingtastic_,

                NeoBundle 'Lokaltog/vim-easymotion'
                let EasyMotion_leader_key  = '<leader>em'
                let g:EasyMotion_mapping_f = '<space>'
                let g:EasyMotion_mapping_F = 'g<space>'
            " }}}

            " Misc {{{
                NeoBundle 'vim-scripts/DrawIt'
                NeoBundle 'szw/vim-maximizer'
                NeoBundle 'goldfeld/ctrlr.vim'

                NeoBundleLazy 'vim-scripts/EasyGrep',
                            \ {'autoload': {'commands': 'GrepOptions'}}

                NeoBundleLazy 'mattn/calendar-vim',
                            \ {'autoload': {'commands': ['Calendar', 'CalendarH']}}
                nnoremap <leader>cal :Calendar<cr>
                nnoremap <leader>caL :CalendarH<cr>

                NeoBundle 'vim-scripts/sessionman.vim'
                set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
                nmap <leader>sl :SessionList<cr>
                nmap <leader>ss :SessionSave<cr>

                NeoBundleLazy 'rbgrouleff/bclose.vim',
                            \ {'autoload': {'commands': ['Bclose']}}
                nnoremap <leader>bd :Bclose<cr>

                NeoBundleLazy 'arecarn/crunch',
                            \ {'autoload': {'commands': ['Crunch', 'CrunchBlock', 'CrunchLine']}}
                nnoremap <leader>cr :Crunch<space>

                NeoBundle 'bling/vim-airline'
                if !has("gui_running")
                    " let g:airline_powerline_fonts = 1
                endif
                let g:airline#extensions#hunks#non_zero_only = 1

                NeoBundle 'bling/vim-bufferline'
                let g:bufferline_echo = 0

                NeoBundle 'tyru/open-browser.vim'
                nmap <Leader>fu <Plug>(openbrowser-open)
                vmap <Leader>fu <Plug>(openbrowser-open)
                nnoremap <Leader>fs :<C-u>OpenBrowserSearch<Space><C-r><C-w><Enter>

                NeoBundleLazy 'sjl/gundo.vim',
                            \ {'autoload': {'commands': 'GundoToggle'}}
                nnoremap <Leader>ut :GundoToggle<cr>
            " }}}

        endif
    " }}}

    " General Programming {{{
        if count(g:dewdrops_bundle_groups, 'programming')
            NeoBundle 'scrooloose/syntastic'
            NeoBundle 'tpope/vim-endwise'
            NeoBundle 'tpope/vim-dispatch'
            NeoBundle 'mutewinter/swap-parameters'

            NeoBundleLazy 'a.vim',
                        \ {'autoload': {'commands': ['A']}}
            nnoremap <leader>ac :A<cr>

            NeoBundleLazy 'thinca/vim-quickrun',
                        \ {'autoload': {'commands': ['QuickRun']}}
            nnoremap <leader>kr :QuickRun -outputter/buffer/into 1<cr>

            NeoBundle 'mattboehm/vim-unstack'
            let g:unstack_mapkey='<leader>us'

            NeoBundle 'AndrewRadev/splitjoin.vim'
            let g:splitjoin_split_mapping = 'cS'
            let g:splitjoin_join_mapping  = 'cJ'

            NeoBundle 'matchit.zip'
            let b:match_ignorecase = 1

            " tcomment {{{
                NeoBundle 'tomtom/tcomment_vim'
                nmap <silent><leader>ci gcc
                vmap <silent><leader>ci gc
                nmap <silent><leader>cc yygccP
                vmap <silent><leader>cc ygvgcP
                nmap <silent><leader>cy yygcc
                vmap <silent><leader>cy ygvgc
            " }}}

            " indent guides {{{
                NeoBundle 'nathanaelkane/vim-indent-guides'
                let g:indent_guides_start_level           = 2
                let g:indent_guides_guide_size            = 1
                let g:indent_guides_enable_on_vim_startup = 1
                " not enable indent guide in special buffers
                let g:indent_guides_exclude_filetypes     = ['help', 'nerdtree', 'startify', 'vundle']

                if !has('gui_running')
                    let g:indent_guides_auto_colors = 0
                    hi IndentGuidesOdd  ctermbg=black
                    hi IndentGuidesEven ctermbg=darkgrey
                endif
            " }}}

            " EasyAlign {{{
                NeoBundle 'junegunn/vim-easy-align'
                let g:easy_align_delimiters = {
                            \ '>': { 'pattern': '>>\|=>\|>' },
                            \ '"': { 'pattern': '"', 'ignore_groups': [] },
                            \ '/': { 'pattern': '//\+\|/\*\|\*/', 'ignore_groups': ['String'] },
                            \ '#': { 'pattern': '#\+', 'ignore_groups': ['String'], 'delimiter_align': 'l' },
                            \ ']': {
                            \     'pattern':       '[[\]]',
                            \     'left_margin':   0,
                            \     'right_margin':  0,
                            \     'stick_to_left': 0
                            \   },
                            \ ')': {
                            \     'pattern':       '[()]',
                            \     'left_margin':   0,
                            \     'right_margin':  0,
                            \     'stick_to_left': 0
                            \   },
                            \ 'd': {
                            \     'pattern': ' \(\S\+\s*[;=]\)\@=',
                            \     'left_margin': 0,
                            \     'right_margin': 0
                            \   }
                            \ }

                vnoremap <silent> <Enter> :EasyAlign<cr>
                nmap <Leader>a, :EasyAlign <space><cr>
                vmap <Leader>a, :EasyAlign <space><cr>
                nmap <Leader>a= :EasyAlign =<cr>
                vmap <Leader>a= :EasyAlign =<cr>
                nmap <Leader>a: :EasyAlign :<cr>
                vmap <Leader>a: :EasyAlign :<cr>
                nmap <Leader>a, :EasyAlign ,<cr>
                vmap <Leader>a, :EasyAlign ,<cr>
                nmap <Leader>a, :EasyAlign .<cr>
                vmap <Leader>a, :EasyAlign .<cr>
                nmap <Leader>a<Bar> :EasyAlign <Bar><cr>
                vmap <Leader>a<Bar> :EasyAlign <Bar><cr>
            " }}}

            " Ack {{{
                if executable('ack-grep')
                    let g:ackprg="ack-grep -H --nocolor --nogroup --column"
                    NeoBundle 'mileszs/ack.vim'
                elseif executable('ack')
                    NeoBundle 'mileszs/ack.vim'
                elseif executable('ag')
                    let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
                    NeoBundle 'mileszs/ack.vim'
                endif
                nnoremap <leader>ak :Ack<space>
            " }}}

            " ctags {{{
                if executable('ctags')
                    " NeoBundle 'xolox/vim-easytags'
                    NeoBundleLazy 'majutsushi/tagbar',
                                \ {'autoload': {'commands': 'TagbarToggle'}}

                    set tags=./tags;/,~/.vimtags;../tags;.../tags

                    nnoremap <silent><leader>tt :TagbarToggle<cr>
                    nnoremap <silent><f8> :TagbarToggle<cr>
                    inoremap <silent><f8> <esc>:TagbarToggle<cr>a

                    " If using go please install the gotags program using the following
                    " go install github.com/jstemmer/gotags
                    " And make sure gotags is in your path
                    let g:tagbar_type_go = {
                        \ 'ctagstype' : 'go',
                        \ 'kinds'     : [  'p:package', 'i:imports:1', 'c:constants', 'v:variables',
                            \ 't:types',  'n:interfaces', 'w:fields', 'e:embedded', 'm:methods',
                            \ 'r:constructor', 'f:functions' ],
                        \ 'sro' : '.',
                        \ 'kind2scope' : { 't' : 'ctype', 'n' : 'ntype' },
                        \ 'scope2kind' : { 'ctype' : 't', 'ntype' : 'n' },
                        \ 'ctagsbin'  : 'gotags',
                        \ 'ctagsargs' : '-sort -silent'
                        \ }
                endif
            " }}}

        endif
    " }}}

    " Git {{{
        if count(g:dewdrops_bundle_groups, 'git')
            NeoBundle 'mhinz/vim-signify'

            NeoBundleLazy 'rhysd/git-messenger.vim',
                        \ {'autoload': {'commands': 'GitMessengerToggle'}}
            nnoremap <leader>gm :Gstatus<cr>

            NeoBundle 'tpope/vim-fugitive'
            nnoremap <leader>gs :Gstatus<cr>
            nnoremap <leader>gd :Gdiff<cr>
            nnoremap <leader>gc :Gcommit<cr>
            nnoremap <leader>gb :Gblame<cr>
            nnoremap <leader>gl :Glog<cr>
            nnoremap <leader>gp :Git push https://github.com/Dewdrops/
            " add :w to trigger gitgutter
            nnoremap <leader>gr :Gwrite<cr>:w<cr>
            autocmd FileType gitcommit nmap <buffer> U :Git checkout -- <C-r><C-g><CR>
            autocmd BufReadPost fugitive://* set bufhidden=delete

            NeoBundleLazy 'gregsexton/gitv',
                        \ {'depends': ['tpope/vim-fugitive'], 'autoload': {'commands': 'Gitv'}}
            nnoremap <leader>gv :Gitv<cr>
        endif
    " }}}

    " Snippets & AutoComplete {{{

        if count(g:dewdrops_bundle_groups, 'snipmate')
            NeoBundle 'garbas/vim-snipmate'
            NeoBundle 'honza/vim-snippets'
            " Source support_function.vim to support vim-snippets
            if filereadable(expand("~/.vim/bundle/vim-snippets/snippets/support_functions.vim"))
                source ~/.vim/bundle/vim-snippets/snippets/support_functions.vim
            endif
        elseif count(g:dewdrops_bundle_groups, 'neocomplete')
            if has('lua') && (v:version > 703 || v:version == 703 && has('patch885'))
                NeoBundle 'Shougo/unite.vim'
                NeoBundle 'Shougo/neocomplete'
            else
                NeoBundle 'Shougo/neocomplcache'
            endif
            NeoBundle 'Shougo/neosnippet'
            NeoBundle 'honza/vim-snippets'
        elseif count(g:dewdrops_bundle_groups, 'ycm')
            NeoBundle 'Valloric/YouCompleteMe'
            " NeoBundle 'SirVer/ultisnips'
        endif

        " OmniComplete {{{
            if has("autocmd") && exists("+omnifunc")
                au Filetype *
                            \if &omnifunc == "" |
                            \setlocal omnifunc=syntaxcomplete#Complete |
                            \endif
            endif

            hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
            hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
            hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

            " Automatically open and close the popup menu / preview window
            au CursorMovedI,InsertLeave * if pumvisible() == 0 | silent! pclose | endif
            set completeopt=menu,preview,longest
        " }}}

        " neocomplcache and neocomplete {{{
            if count(g:dewdrops_bundle_groups, 'neocomplete')
                let g:acp_enableAtStartup = 0

                if !( has('lua') && (v:version > 703 || v:version == 703 && has('patch885')) )
                    let g:neocomplcache_enable_at_startup            = 1
                    let g:neocomplcache_enable_camel_case_completion = 1
                    let g:neocomplcache_enable_smart_case            = 1
                    let g:neocomplcache_enable_underbar_completion   = 1
                    let g:neocomplcache_enable_auto_delimiter        = 1
                    let g:neocomplcache_max_list                     = 15
                    let g:neocomplcache_force_overwrite_completefunc = 1

                    " Define dictionary.
                    let g:neocomplcache_dictionary_filetype_lists = {
                                \ 'default' : '',
                                \ }

                    " Define keyword.
                    if !exists('g:neocomplcache_keyword_patterns')
                        let g:neocomplcache_keyword_patterns = {}
                    endif
                    let g:neocomplcache_keyword_patterns._ = '\h\w*'

                    inoremap <expr><C-g> neocomplcache#undo_completion()
                    inoremap <expr><C-l> neocomplcache#complete_common_string()
                    inoremap <expr><cr> neocomplcache#complete_common_string()

                    " <C-h>, <BS>: close popup and delete backword char.
                    inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
                    inoremap <expr><C-y> neocomplcache#close_popup()

                    " Enable heavy omni completion.
                    if !exists('g:neocomplcache_omni_patterns')
                        let g:neocomplcache_omni_patterns = {}
                    endif
                    let g:neocomplcache_omni_patterns.php  = '[^. \t]->\h\w*\|\h\w*::'
                    let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
                    let g:neocomplcache_omni_patterns.c    = '[^.[:digit:] *\t]\%(\.\|->\)'
                    let g:neocomplcache_omni_patterns.cpp  = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
                    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
                else
                    let g:neocomplete#enable_at_startup            = 1
                    let g:neocomplete#enable_camel_case_completion = 1
                    let g:neocomplete#enable_smart_case            = 1
                    let g:neocomplete#enable_underbar_completion   = 1
                    let g:neocomplete#enable_auto_delimiter        = 1
                    let g:neocomplete#max_list                     = 15
                    let g:neocomplete#force_overwrite_completefunc = 1

                    " Define dictionary.
                    let g:neocomplete#sources#dictionary#dictionaries = {
                                \ 'default' : '',
                                \ }

                    " Define keyword.
                    if !exists('g:neocomplete_keyword_patterns')
                        let g:neocomplete#keyword_patterns = {}
                    endif
                    let g:neocomplete#keyword_patterns._ = '\h\w*'

                    inoremap <expr><c-g> neocomplete#undo_completion()
                    inoremap <expr><c-l> neocomplete#complete_common_string()
                    inoremap <expr><cr> neocomplete#complete_common_string()

                    " <C-h>, <BS>: close popup and delete backword char.
                    inoremap <expr><bs> neocomplete#smart_close_popup()."\<C-h>"
                    inoremap <expr><c-y> neocomplete#close_popup()

                    " Enable heavy omni completion.
                    if !exists('g:neocomplete#sources#omni#input_patterns')
                        let g:neocomplete#sources#omni#input_patterns = {}
                    endif
                    let g:neocomplete#sources#omni#input_patterns.php  = '[^. \t]->\h\w*\|\h\w*::'
                    let g:neocomplete#sources#omni#input_patterns.c    = '[^.[:digit:] *\t]\%(\.\|->\)'
                    let g:neocomplete#sources#omni#input_patterns.cpp  = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
                    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
                    let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
                endif

                imap <C-k> <Plug>(neosnippet_expand_or_jump)
                smap <C-k> <Plug>(neosnippet_expand_or_jump)
                xmap <C-k> <Plug>(neosnippet_expand_target)

                " <TAB>: expand snippets or navigate in list
                imap <expr><tab> pumvisible() ? "\<C-n>" :
                            \ neosnippet#expandable_or_jumpable() ?
                            \ "\<Plug>(neosnippet_expand_or_jump)" : "\<tab>"
                imap <expr><s-tab> pumvisible() ? "\<C-p>" :
                            \ neosnippet#expandable_or_jumpable() ?
                            \ "\<Plug>(neosnippet_expand_or_jump)" : "\<s-tab>"

                " Enable omni completion.
                au FileType css setlocal omnifunc=csscomplete#CompleteCSS
                au FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
                au FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
                au FileType python setlocal omnifunc=pythoncomplete#Complete
                au FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
                au FileType ruby,eruby setlocal omnifunc=rubycomplete#Complete

                " Use honza's snippets.
                let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

                " Enable neosnippet snipmate compatibility mode
                let g:neosnippet#enable_snipmate_compatibility = 1

                " For snippet_complete marker.
                if has('conceal')
                    set conceallevel=2 concealcursor=i
                endif

                " Disable the neosnippet preview candidate window
                " when enabled, or there can be too much visual noise
                " especially when splits are used
                set completeopt-=preview
            endif
        " }}}

        " SnipMate {{{
            " Setting the author var
            let g:snips_author = 'Dewdrops <v_v_4474@126.com>'
        " }}}

        " YouCompleteMe {{{
            let g:ycm_complete_in_comments_and_strings = 1
            let g:ycm_key_list_select_completion       = ['<tab>', '<C-n>', '<Down>']
            let g:ycm_key_list_previous_completion     = ['<s-tab>', '<C-p>', '<Up>']
            let g:ycm_filetype_blacklist               = {'unite': 1}
            let g:ycm_register_as_syntastic_checker    = 0
            let g:ycm_global_ycm_extra_conf            = '~/.ycm_extra_conf.py'
            let g:ycm_confirm_extra_conf               = 0

            " configuration of UltiSnips
            let g:UltiSnipsExpandTrigger               = "<c-k>"
            let g:UltiSnipsJumpForwardTrigger          = "<c-k>"
            let g:UltiSnipsJumpBackwardTrigger         = "<c-j>"
            let g:UltiSnipsSnippetsDir                 = '~/.vim/snippets'

            nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<cr>
        "}}}

    " }}}

    " PHP {{{
        if count(g:dewdrops_bundle_groups, 'php')
            NeoBundle 'spf13/PIV'
            let g:DisableAutoPHPFolding = 0
            "let g:PIVAutoClose = 0

            NeoBundle 'arnaud-lb/vim-php-namespace'
            NeoBundle 'shawncplus/phpcomplete.vim'
            NeoBundle 'beyondwords/vim-twig'
        endif
    " }}}

    " Python {{{
        if count(g:dewdrops_bundle_groups, 'python')
            NeoBundle 'hdima/python-syntax'
            NeoBundle 'python_match.vim'

            NeoBundle 'klen/python-mode'
            " Disable if python support not present
            if !has('python')
                let g:pymode = 1
            endif
            let g:pymode_lint_checker      = "pyflakes"
            let g:pymode_utils_whitespaces = 0
            let g:pymode_options           = 0
        endif
    " }}}

    " Javascript {{{
        if count(g:dewdrops_bundle_groups, 'javascript')
            NeoBundle 'pangloss/vim-javascript'
            NeoBundle 'briancollins/vim-jst'
            NeoBundle 'kchmck/vim-coffee-script'

            NeoBundle 'elzr/vim-json'
            nmap <leader>jt <Esc>:%!python -m json.tool<cr><Esc>:set filetype=json<cr>
        endif
    " }}}

    " Scala {{{
        if count(g:dewdrops_bundle_groups, 'scala')
            NeoBundle 'derekwyatt/vim-scala'
            NeoBundle 'derekwyatt/vim-sbt'
        endif
    " }}}

    " Haskell {{{
        if count(g:dewdrops_bundle_groups, 'haskell')
            NeoBundle 'travitch/hasksyn'
            NeoBundle 'dag/vim2hs'

            NeoBundle 'lukerandall/haskellmode-vim'
            let g:haddock_browser = "/usr/bin/opera"
        endif
    " }}}

    " HTML {{{
        if count(g:dewdrops_bundle_groups, 'html')
            NeoBundle 'hail2u/vim-css3-syntax'
            NeoBundle 'cakebaker/scss-syntax.vim'
            NeoBundle 'groenewege/vim-less'
            NeoBundle 'tpope/vim-haml'

            NeoBundle 'amirh/HTML-AutoCloseTag'
            " Make it so AutoCloseTag works for xhtml files as well
            au FileType xhtml ru ftplugin/html/autoclosetag.vim

            NeoBundle 'mattn/emmet-vim'
            let g:user_emmet_leader_key = '<c-g>'            " use C-g instead
            let g:user_emmet_mode       = 'i'
        endif
    " }}}

    " Ruby {{{
        if count(g:dewdrops_bundle_groups, 'ruby')
            NeoBundle 'vim-ruby/vim-ruby'
            NeoBundle 'tpope/vim-rails'

            autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading    = 1
            autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
            autocmd FileType ruby,eruby let g:rubycomplete_rails             = 1
        endif
    " }}}

    " Perl {{{
        if count(g:dewdrops_bundle_groups, 'perl')
            NeoBundle 'vim-perl/vim-perl'
        endif
    " }}}

    " CSharp {{{
        if count(g:dewdrops_bundle_groups, 'csharp')
            NeoBundle 'nosami/Omnisharp'
        endif
    " }}}

    " Lua {{{
        if count(g:dewdrops_bundle_groups, 'lua')
            NeoBundle 'xolox/vim-misc'
            NeoBundle 'xolox/vim-lua-ftplugin'
        endif
    " }}}

    " Go Lang {{{
        if count(g:dewdrops_bundle_groups, 'go')
            NeoBundle 'jnwhiteh/vim-golang'
            NeoBundle 'spf13/vim-gocode'
        endif
    " }}}

    " Cucumber {{{
        if count(g:dewdrops_bundle_groups, 'cucumber')
            NeoBundle 'tpope/vim-cucumber'
            NeoBundle 'quentindecock/vim-cucumber-align-pipes'
        endif
    " }}}

    " Puppet {{{
        if count(g:dewdrops_bundle_groups, 'puppet')
            NeoBundle 'Puppet-Syntax-Highlighting'
        endif
    " }}}

    " Misc {{{
        if count(g:dewdrops_bundle_groups, 'misc')
            NeoBundle 'tpope/vim-markdown',
            NeoBundle 'chrisbra/csv.vim'
            NeoBundle 'xml.vim'
            NeoBundle 'jceb/vim-orgmode'

            NeoBundle 'LaTeX-Box-Team/LaTeX-Box'
            let g:LatexBox_Folding = 1
        endif
    " }}}

" }}}

" GUI Settings {{{

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        set guioptions-=m           " Remove the menubar
        set guioptions-=r           " Remove the scrollbar
        set lines=40                " 40 lines of text instead of 24
        if has("gui_gtk2")
            set guifont=Andale\ Mono\ Regular\ 16,Menlo\ Regular\ 15,Consolas\ Regular\ 16,Courier\ New\ Regular\ 18
        elseif has("gui_mac")
            set guifont=Andale\ Mono\ Regular:h16,Menlo\ Regular:h15,Consolas\ Regular:h16,Courier\ New\ Regular:h18
        elseif has("gui_win32")
            set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
        endif
        if has('gui_macvim')
            set transparency=5      " Make the window slightly transparent
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
    endif

" }}}

" Functions {{{

    " Initialize directories {{{
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        " Specify the directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories
        let common_dir = parent . '/.' . prefix

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    " }}}

    " Initialize NERDTree as needed {{{
    function! NERDTreeInitAsNeeded()
        redir => bufoutput
        buffers!
        redir END
        let idx = stridx(bufoutput, "NERD_tree")
        if idx > -1
            NERDTreeMirror
            NERDTreeFind
            wincmd l
        endif
    endfunction
    " }}}

    " Strip whitespace {{{
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s = @/
        let l  = line(".")
        let c  = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/ = _s
        call cursor(l, c)
    endfunction
    " }}}

    " Check whether to load/restore view {{{
    function! MakeViewCheck()
        if has('quickfix') && &buftype =~ 'nofile' | return 0 | endif
        if expand('%') =~ '\[.*\]' | return 0 | endif
        if empty(glob(expand('%:p'))) | return 0 | endif
        if &modifiable == 0 | return 0 | endif
        if len($TEMP) && expand('%:p:h') == $TEMP | return 0 | endif
        if len($TMP) && expand('%:p:h') == $TMP | return 0 | endif
        return 1
    endfunction
    " }}}

" }}}

" Finish initializations {{{
    call InitializeDirectories()

    filetype plugin indent on
    syntax enable
    NeoBundleCheck
" }}}
