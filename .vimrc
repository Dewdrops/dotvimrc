" Modeline and Notes {{{
" vim: sw=4 ts=4 sts=4 et tw=80 foldmarker={{{,}}} foldlevel=0 foldmethod=marker
"
"   This is the personal .vimrc file of Dewdrops (v_v_4474@126.com). some code are
"   stolen from spf13-vim (https://github.com/spf13/spf13-vim).
" }}}

" Environment {{{

    " Load basic configuration
    source ~/.vimrc_tiny

    " Set up plugin manager
    call plug#begin('~/.vim/plugged')

" }}}

" Bundles {{{

    " Bundle group configuration {{{
        if !exists('g:dewdrops_bundle_groups')
            let g:dewdrops_bundle_groups = [
                        \     'general',
                        \     'programming',
                        \     'js',
                        \     'git',
                        \     'ycm',
                        \ ]
        endif
    " }}}

    " General {{{
        if count(g:dewdrops_bundle_groups, 'general')

            " Tree File Manager {{{
                Plug 'scrooloose/nerdtree'
                let NERDTreeShowBookmarks               = 1
                let NERDTreeIgnore                      = ['\.pyc', '\.elc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
                let NERDTreeChDirMode                   = 0
                let NERDTreeQuitOnOpen                  = 1
                let NERDTreeMouseMode                   = 2
                let NERDTreeShowHidden                  = 1
                let NERDTreeKeepTreeInNewTab            = 1
                let g:nerdtree_tabs_open_on_gui_startup = 0

                Plug 'jistr/vim-nerdtree-tabs'
                map <Leader>nt <plug>NERDTreeTabsToggle<cr>
                map <Leader>nf <plug>NERDTreeTabsFind<cr>

                Plug 'troydm/easytree.vim', {'on': 'EasyTreeToggle'}
                map <Leader>et :EasyTreeToggle<cr>

                Plug 'justinmk/vim-dirvish', {'on': 'Dirvish'}
                Plug 'francoiscabrol/ranger.vim', {'on': 'Ranger'}
            " }}}

            " Grep {{{
                Plug 'mhinz/vim-grepper'
                let g:grepper = {
                            \ 'tools': ['ag', 'ack', 'git', 'grep'],
                            \ 'open':  1,
                            \ 'jump':  1,
                            \ }
                nmap gs <plug>(GrepperOperator)
                xmap gs <plug>(GrepperOperator)

                if executable('ack') || executable('ag')
                    Plug 'dyng/ctrlsf.vim', {'on': 'CtrlSF'}
                endif
                nnoremap <leader>ak :CtrlSF<space>
            " }}}

            " CtrlP {{{
                Plug 'ctrlpvim/ctrlp.vim'
                let g:ctrlp_custom_ignore = {
                            \ 'dir': '\.git$\|\.hg$\|\.svn$',
                            \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc|\.elc$'
                            \ }
                let g:ctrlp_user_command = {
                            \ 'types': {
                            \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                            \ },
                            \ 'fallback': 'find %s -type f'
                            \ }

                let g:ctrlp_cmd = 'CtrlPMixed'
                let g:ctrlp_working_path_mode = 'rc'
                let g:ctrlp_clear_cache_on_exit = 1
                let g:ctrlp_max_height = 40
                let g:ctrlp_follow_symlinks = 1
                let g:ctrlp_max_files = 10000
                let g:ctrlp_mruf_max = 20
                let g:ctrlp_cache_dir = '~/.vim/.cache/ctrlp'
                let g:ctrlp_reuse_window = 'startify'
                let g:ctrlp_extensions = ['funky']

                nnoremap \ <nop>
                nnoremap \t :CtrlPBufTag<cr>
                nnoremap \T :CtrlPTag<cr>
                nnoremap \l :CtrlPLine<cr>
                nnoremap \o :CtrlPFunky<cr>
                nnoremap \b :CtrlPBuffer<cr>

                Plug 'tacahiroy/ctrlp-funky'
            " }}}

            " Startify {{{
                Plug 'mhinz/vim-startify'

                if executable('fortune') && executable('cowsay')
                    let g:startify_custom_header =
                                \ map(split(system('fortune | cowsay'), '\n'), '"   ". v:val') + ['','']
                else
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
                endif
            " }}}

            " vim-swoop {{{
                Plug 'pelodelfuego/vim-swoop'

                let g:swoopUseDefaultKeyMap = 0
                nmap <leader>ms :call Swoop()<cr>
                vmap <leader>ms :call SwoopSelection()<cr>
                nmap <leader>ml :call SwoopMulti()<cr>
                vmap <leader>ml :call SwoopMultiSelection()<cr>

                function! Multiple_cursors_before()
                    if exists('*SwoopFreezeContext') != 0
                        call SwoopFreezeContext()
                    endif
                endfunction
                function! Multiple_cursors_after()
                    if exists('*SwoopUnFreezeContext') != 0
                        call SwoopUnFreezeContext()
                    endif
                endfunction
            " }}}

            " Edit {{{
                Plug 'tpope/vim-speeddating'
                Plug 'jiangmiao/auto-pairs'
                Plug 'tpope/vim-surround'
                Plug 'terryma/vim-multiple-cursors'
                Plug 'tpope/vim-repeat'
                Plug 'chrisbra/NrrwRgn'
                Plug 'vim-scripts/ReplaceWithRegister'
                Plug 'junegunn/vim-peekaboo'
                Plug 'Shougo/vinarise.vim', {'on_cmd': 'Vinarise'}
                Plug 'tpope/vim-abolish'
                Plug 'dhruvasagar/vim-table-mode'

                Plug 'tommcdo/vim-lion', {'on':
                            \['<Plug>LionRight', '<Plug>VLionRight', '<Plug>LionLeft', '<Plug>VLionLeft']}
                let g:lion_create_maps = 0
                nmap <silent> gl <Plug>LionRight
                vmap <silent> gl <Plug>VLionRight
                nmap <silent> gL <Plug>LionLeft
                vmap <silent> gL <Plug>VLionLeft

                Plug 'Dewdrops/vim-unimpaired'
                nmap <c-up> [e
                nmap <c-down> ]e
                vmap <c-up> [e
                vmap <c-down> ]e

                Plug 'vim-scripts/DrawIt'
                nmap <unique> <Leader>di <Plug>DrawItStart

                Plug 'vim-scripts/sketch.vim'
                nmap <leader>sk :call ToggleSketch()<cr>

                Plug 'osyo-manga/vim-over'
                noremap <leader>ov :OverCommandLine<cr>:%s/

                Plug 'tommcdo/vim-exchange'
                let g:exchange_no_mappings = 1
                nmap gx <Plug>(Exchange)
                vmap gx <Plug>(Exchange)
                nmap gxc <Plug>(ExchangeClear)
                nmap gxx <Plug>(ExchangeLine)

                Plug 'mbbill/undotree'
                nnoremap <Leader>ut :UndotreeToggle<cr>
            " }}}

            " Motion {{{
                Plug 'wellle/targets.vim'
                Plug 'jeetsukumaran/vim-indentwise'
                Plug 'kana/vim-textobj-user'
                Plug 'kana/vim-textobj-indent'
                Plug 'thinca/vim-textobj-between'
                Plug 'bruno-/vim-vertical-move'
                Plug 'unblevable/quick-scope'
                Plug 'brooth/far.vim'

                Plug 'junegunn/vim-after-object'
                autocmd VimEnter * call after_object#enable('=', ':', '-', '#', ' ')

                Plug 'haya14busa/incsearch.vim'
                map /  <Plug>(incsearch-forward)
                map ?  <Plug>(incsearch-backward)
                map g/ <Plug>(incsearch-stay)

                Plug 'haya14busa/incsearch-fuzzy.vim'
                map z/ <Plug>(incsearch-fuzzy-/)
                map z? <Plug>(incsearch-fuzzy-?)
                map zg/ <Plug>(incsearch-fuzzy-stay)

                Plug 'dahu/vim-fanfingtastic'
                map <unique><silent> <leader><leader> <Plug>fanfingtastic_,

                Plug 'takac/vim-easymotion'
                nmap <space> <Plug>(easymotion-f)
                nmap g<space> <Plug>(easymotion-F)
                let EasyMotion_leader_key  = '<leader>em'
                let g:EasyMotion_mapping_f = '<space>'
                let g:EasyMotion_mapping_F = '<space><space>'
            " }}}

            " UI {{{
                Plug 'yonchu/accelerated-smooth-scroll'
                Plug 'szw/vim-maximizer'
                Plug 'junegunn/goyo.vim'
                Plug 'Dewdrops/vim-tomorrow-theme'
                Plug 'w0ng/vim-hybrid'
                Plug 'jpo/vim-railscasts-theme'
                Plug 'sickill/vim-monokai'

                Plug 'bling/vim-airline'
                let g:airline#extensions#hunks#non_zero_only     = 1
                let g:airline_exclude_preview                    = 1
                let g:airline#extensions#tabline#enabled         = 1
                let g:airline#extensions#tabline#buffer_idx_mode = 1
                nmap <leader>1 <Plug>AirlineSelectTab1
                nmap <leader>2 <Plug>AirlineSelectTab2
                nmap <leader>3 <Plug>AirlineSelectTab3
                nmap <leader>4 <Plug>AirlineSelectTab4
                nmap <leader>5 <Plug>AirlineSelectTab5
                nmap <leader>6 <Plug>AirlineSelectTab6
                nmap <leader>7 <Plug>AirlineSelectTab7
                nmap <leader>8 <Plug>AirlineSelectTab8
                nmap <leader>9 <Plug>AirlineSelectTab9

                Plug 'junegunn/limelight.vim'
                let g:limelight_conceal_ctermfg = 'gray'
                let g:limelight_conceal_guifg   = 'DarkGray'
                function! GoyoBefore()
                    Limelight
                endfunction
                function! GoyoAfter()
                    Limelight!
                endfunction
                let g:goyo_callbacks = [function('GoyoBefore'), function('GoyoAfter')]
            " }}}

            " Misc {{{
                Plug 'ConradIrwin/vim-bracketed-paste'
                Plug 'vim-scripts/LargeFile'
                " Plug 'mtth/scratch.vim'
                Plug 'justinmk/vim-gtfo'
                Plug 'chrisbra/vim-diff-enhanced'
                Plug 'tpope/vim-eunuch'
                Plug 'exvim/ex-visincr'
                Plug 'chrisbra/Recover.vim'
                Plug 'AndrewRadev/linediff.vim'
                Plug 'tpope/vim-characterize'
                Plug 'thinca/vim-prettyprint'
                Plug 'Konfekt/FastFold'
                " Plug 'MattesGroeger/vim-bookmarks'
                Plug 'mbbill/fencview'
                Plug 'mattn/calendar-vim'
                Plug 'arecarn/crunch'
                Plug 'wellle/visual-split.vim'
                Plug 'ryanss/vim-hackernews'
                Plug 'Shougo/junkfile.vim'
                Plug 'skywind3000/asyncrun.vim'
                Plug 'vim-scripts/renamer.vim', {'on': 'Renamer'}

                Plug 'troydm/easybuffer.vim'
                nmap <leader>bs :EasyBuffer<cr>

                " Plug 'kshenoy/vim-signature'
                " nnoremap <leader>sg :SignatureToggle<cr>

                Plug 'dahu/vim-lotr'
                nmap <leader>lr <plug>LOTRToggle

                Plug 'Dewdrops/vim-interestingwords'
                let g:interestingWordsDefaultMappings = 0
                nnoremap <silent> <leader>hl :call InterestingWords() \| nohls<cr>
                nnoremap <silent> <leader>/ :call UncolorAllWords() \| nohls<cr>
                nnoremap <silent> n :call WordNavigation(1)<cr>zz
                nnoremap <silent> N :call WordNavigation(0)<cr>zz

                Plug 'vim-scripts/sessionman.vim'
                let sessionman_save_on_exit = 0
                nmap <leader>sl :SessionList<cr>
                nmap <leader>ss :SessionSave<cr>

                Plug 'tyru/open-browser.vim'
                nmap <leader>fu <Plug>(openbrowser-open)
                vmap <leader>fu <Plug>(openbrowser-open)
                nnoremap <leader>fs :<C-u>OpenBrowserSearch<Space><C-r><C-w><Enter>
            " }}}

        endif
    " }}}

    " General Programming {{{
        if count(g:dewdrops_bundle_groups, 'programming')
            Plug 'tpope/vim-endwise'
            Plug 'octol/vim-cpp-enhanced-highlight'
            Plug 'justinmk/vim-syntax-extra'
            Plug 'tpope/vim-dispatch'
            Plug 'bruno-/vim-man'
            Plug 'metakirby5/codi.vim'
            Plug 'sbdchd/neoformat'
            Plug 'jaxbot/semantic-highlight.vim', {'on': 'SemanticHighlight'}
            Plug 'AndrewRadev/switch.vim', {'on': 'Switch'}
            Plug 'vim-scripts/a.vim', {'on': 'A'}

            Plug 'rizzatti/dash.vim'
            nmap <leader>D <Plug>DashSearch

            Plug 'w0rp/ale'

            Plug 'AndrewRadev/splitjoin.vim'
            let g:splitjoin_split_mapping = 'cS'
            let g:splitjoin_join_mapping  = 'cJ'

            Plug 'vim-scripts/matchit.zip'
            let b:match_ignorecase = 1

            Plug 'SirVer/ultisnips'
            Plug 'honza/vim-snippets'
            let g:UltiSnipsExpandTrigger       = "<c-k>"
            let g:UltiSnipsJumpForwardTrigger  = "<c-k>"
            let g:UltiSnipsJumpBackwardTrigger = "<c-j>"

            Plug 'Chiel92/vim-autoformat', {'on': 'AutoFormat'}
            nnoremap <leader>gq :Autoformat<cr>

            Plug 'thinca/vim-quickrun', {'on': 'QuickRun'}
            nnoremap <leader>kr :QuickRun -outputter/buffer/into 1<cr>

            Plug 'tomtom/tcomment_vim'
            nnoremap <silent> gc :<c-u>if v:count > 0 \| call tcomment#SetOption("count", v:count) \| endif \| let w:tcommentPos = getpos(".") \| set opfunc=tcomment#Operator<cr>g@
            nnoremap <silent> gcc :let w:tcommentPos = getpos(".") \| set opfunc=tcomment#OperatorLine<cr>g@$
            xnoremap <silent> gc :TCommentMaybeInline<cr>
            nnoremap <silent> gC :let w:tcommentPos = getpos(".") \| set opfunc=tcomment#OperatorAnyway<cr>g@
            nnoremap <silent> gCc :let w:tcommentPos = getpos(".") \| set opfunc=tcomment#OperatorLineAnyway<cr>g@$
            xnoremap <silent> C :TCommentMaybeInline!<cr>
            nmap <silent><leader>C yygccp
            vmap <silent><leader>C ygvgc'>p
            nmap <silent><leader>cy yygcc
            vmap <silent><leader>cy ygvgc

            " EasyAlign {{{
                Plug 'junegunn/vim-easy-align', {'on_cmd': ['EasyAlign', 'LiveEasyAlign']}
                let g:easy_align_delimiters = {
                            \ '>': { 'pattern': '>>\|=>\|>' },
                            \ '"': { 'pattern': '"', 'ignore_groups': [] },
                            \ '/': { 'pattern': '//\+\|/\*\|\*/', 'ignore_groups': ['string'] },
                            \ '#': { 'pattern': '#\+', 'ignore_groups': ['string'], 'delimiter_align': 'l' },
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
                            \     'pattern': ' \(\s\+\s*[;=]\)\@=',
                            \     'left_margin': 0,
                            \     'right_margin': 0
                            \   }
                            \ }

                vnoremap <silent> <enter> :EasyAlign<cr>
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

            " ctags {{{
                if executable('ctags')
                    Plug 'ludovicchabant/vim-gutentags'
                    Plug 'majutsushi/tagbar', {'on_cmd': 'TagbarToggle'}

                    nnoremap <silent><leader>tt :TagbarToggle<cr>
                    nnoremap <silent><f8> :TagbarToggle<cr>
                    inoremap <silent><f8> <esc>:TagbarToggle<cr>a

                    " And make sure gotags is in your path
                    if count(g:dewdrops_bundle_groups, 'go')
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
                endif
            " }}}
        endif
    " }}}

    " Git {{{
        if count(g:dewdrops_bundle_groups, 'git')
            Plug 'mhinz/vim-signify'
            " Plug 'jaxbot/github-issues.vim'
            Plug 'junegunn/vim-github-dashboard'
            Plug 'tpope/vim-git'

            Plug 'mattn/webapi-vim'
            Plug 'mattn/gist-vim'

            Plug 'tpope/vim-fugitive'
            nnoremap <leader>gp :Git push https://github.com/Dewdrops/
            " add :w to trigger gitgutter
            nnoremap <leader>gr :Gwrite<cr>:w<cr>
            autocmd FileType gitcommit nmap <buffer> U :Git checkout -- <C-r><C-g><CR>
            autocmd BufReadPost fugitive://* set bufhidden=delete
            Plug 'tpope/vim-rhubarb'
            Plug 'junegunn/gv.vim'
            Plug 'idanarye/vim-merginal', {'branch': 'develop'}
            Plug 'int3/vim-extradite', {'on': 'Extradite'}
            Plug 'gregsexton/gitv', {'on': 'Gitv'}

            Plug 'rhysd/git-messenger.vim', {'on': 'GitMessengerToggle'}
            nnoremap <leader>gm :GitMessengerToggle<cr>
        endif
    " }}}

    " AutoComplete {{{
        if count(g:dewdrops_bundle_groups, 'neocomplete')
            " neocomplete {{{

                let g:acp_enableAtStartup = 0

                if has('lua')
                    Plug 'Shougo/unite.vim'
                    Plug 'Shougo/neocomplete'

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
            " }}}
        elseif count(g:dewdrops_bundle_groups, 'ycm')
            " YouCompleteMe {{{
                Plug 'Valloric/YouCompleteMe'
                nnoremap <leader>jd :YcmCompleter GoTo<cr>
                nnoremap <leader>jg :YcmCompleter GetDoc<cr>
                let g:ycm_key_detailed_diagnostics         = ''
                let g:ycm_complete_in_comments_and_strings = 1
                let g:ycm_key_list_select_completion       = ['<tab>', '<C-n>', '<Down>']
                let g:ycm_key_list_previous_completion     = ['<s-tab>', '<C-p>', '<Up>']
                let g:ycm_global_ycm_extra_conf            = '~/.ycm_extra_conf.py'
                let g:ycm_python_binary_path               = 'python3'
                let g:ycm_confirm_extra_conf               = 0
                let g:ycm_enable_diagnostic_signs          = 0
                let g:ycm_semantic_triggers                = {}
                let g:ycm_semantic_triggers.html           = [' ']
                let g:ycm_semantic_triggers.xhtml          = [' ']
                let g:ycm_semantic_triggers.haskell        = ['.']
                let g:ycm_semantic_triggers.rs             = ['::', '.']
            "}}}
        else
            Plug 'ajh17/VimCompletesMe'
        endif

    " }}}

    " PHP {{{
        if count(g:dewdrops_bundle_groups, 'php')
            Plug 'StanAngeloff/php.vim'
            Plug 'jwalton512/vim-blade'
            Plug 'arnaud-lb/vim-php-namespace'
            Plug 'shawncplus/phpcomplete.vim'
        endif
    " }}}

    " Lisp {{{
        if count(g:dewdrops_bundle_groups, 'lisp')
            Plug 'losingkeys/vim-niji'

            Plug 'guns/vim-sexp', {'for': ['lisp', 'scheme', 'clojure']}
            au FileType lisp,scheme,clojure let maplocalleader = '-'
            au FileType lisp,scheme,clojure map <buffer> <leader>jb <Plug>(sexp_move_to_prev_element_head)
            au FileType lisp,scheme,clojure map <buffer> <leader>jw <Plug>(sexp_move_to_next_element_head)
            au FileType lisp,scheme,clojure map <buffer> <leader>jge <Plug>(sexp_move_to_prev_element_tail)
            au FileType lisp,scheme,clojure map <buffer> <leader>je <Plug>(sexp_move_to_next_element_tail)
            au FileType lisp,scheme,clojure nmap <buffer> <leader>jk <Plug>(sexp_swap_element_backward)
            au FileType lisp,scheme,clojure nmap <buffer> <leader>jj <Plug>(sexp_swap_element_forward)
            let g:sexp_enable_insert_mode_mappings = 0
            let g:sexp_insert_after_wrap           = 0
            let g:sexp_mappings = {
                        \ 'sexp_select_prev_element': '[j',
                        \ 'sexp_select_next_element': ']j',
                        \ 'sexp_emit_tail_element': '<c-left>',
                        \ 'sexp_capture_next_element': '<c-right>'
                        \ }
        endif
    " }}}

    " Clojure {{{
        if count(g:dewdrops_bundle_groups, 'clojure')
            Plug 'guns/vim-clojure-static'
            Plug 'tpope/vim-foreplay'
            Plug 'guns/vim-clojure-highlight'
            Plug 'tpope/vim-classpath'
            Plug 'tpope/vim-leiningen'
            Plug 'tpope/vim-salve'
            Plug 'typedclojure/vim-typedclojure'
        endif
    " }}}

    " HTML {{{
        if count(g:dewdrops_bundle_groups, 'html')
            Plug 'othree/html5.vim'
            Plug 'othree/xml.vim'
            Plug 'hail2u/vim-css3-syntax'
            Plug 'gorodinskiy/vim-coloresque'
            Plug 'greyblake/vim-preview'

            Plug 'gcmt/breeze.vim'
            au Filetype html,xhtml,xml nnoremap <buffer> <cr> :BreezeJumpF<cr>
            au Filetype html,xhtml,xml nnoremap <buffer> <leader><cr> :BreezeJumpB<cr>
            au Filetype html,xhtml,xml nnoremap <buffer> <leader>jn :BreezeNextSibling<cr>
            au Filetype html,xhtml,xml nnoremap <buffer> <leader>jp :BreezePrevSibling<cr>
            au Filetype html,xhtml,xml nnoremap <buffer> <leader>jf :BreezeFirstSibling<cr>
            au Filetype html,xhtml,xml nnoremap <buffer> <leader>jl :BreezeLastSibling<cr>
            au Filetype html,xhtml,xml nnoremap <buffer> <leader>ju :BreezeParent<cr>

            Plug 'mattn/emmet-vim'
            let g:user_emmet_mode = 'i'
        endif
    " }}}

    " Javascript {{{
        if count(g:dewdrops_bundle_groups, 'js')
            Plug 'pangloss/vim-javascript'
            Plug 'mxw/vim-jsx'
            Plug 'tpope/vim-jdaddy'
        endif
    " }}}

    " Misc Languages {{{
        " Plug 'kchmck/vim-coffee-script'
        Plug 'chrisbra/csv.vim'
        " Plug 'tpope/vim-haml'
        Plug 'fatih/vim-go'
        " Plug 'petRUShka/vim-opencl'
        " Plug 'andreimaxim/vim-io'
        " Plug 'tpope/timl'
        " Plug 'JuliaLang/julia-vim'
        " Plug 'Rykka/riv.vim'
        Plug 'fatih/vim-nginx'
        Plug 'darfink/vim-plist'
        Plug 'hiqsol/pgsql.vim'
        Plug 'dag/vim-fish'
        Plug 'wting/rust.vim'
        Plug 'cespare/vim-toml'
        Plug 'tikhomirov/vim-glsl'
        " Plug 'chilicuil/vim-sml-coursera'
        Plug 'rgrinberg/vim-ocaml'
        Plug 'fsharp/vim-fsharp'

        Plug 'artur-shaik/vim-javacomplete2'
        autocmd FileType java set omnifunc=javacomplete#Complete

        " Plug 'rdolgushin/groovy.vim'

        Plug 'OrangeT/vim-csharp'
        " Plug 'OmniSharp/omnisharp-vim'
        " autocmd Filetype cs nnoremap <buffer> <leader>jr :OmniSharpRename<cr>

        Plug 'travitch/hasksyn', {'on_ft': 'haskell'}
        Plug 'vim-scripts/Superior-Haskell-Interaction-Mode-SHIM',
                    \ {'on': ['GhciFile', 'GhciRange', 'GhciReload']}


        Plug 'oscarh/vimerl'
        " Plug 'elixir-lang/vim-elixir'

        Plug 'vim-ruby/vim-ruby'
        " Plug 'ecomba/vim-ruby-refactoring'
        " Plug 'sheerun/rspec.vim'
        " Plug 'tpope/vim-rails'

        Plug 'vim-perl/vim-perl', {'branch': 'dev'}
        Plug 'vim-perl/vim-perl6'
        Plug 'c9s/perlomni.vim'

        Plug 'yko/mojo.vim'
        let mojo_highlight_data = 1

        " Plug 'tpope/vim-cucumber'
        " Plug 'quentindecock/vim-cucumber-align-pipes'
        "
        " Plug 'derekwyatt/vim-sbt'
        " Plug 'derekwyatt/vim-scala'
        "
        " Plug 'xolox/vim-misc'
        " Plug 'xolox/vim-lua-ftplugin'
        " Plug 'xolox/vim-lua-inspect'
        "
        " Plug 'dhruvasagar/vim-dotoo'

        Plug 'jceb/vim-orgmode'
        au FileType org setlocal fdm=expr

        " Plug 'LaTeX-Box-Team/LaTeX-Box'
        " let g:LatexBox_Folding = 1
    " }}}

" }}}

" Neovim specific settings {{{

    if has('nvim')
        " set inccommand=nosplit
    endif

" }}}
" 
" Finish initializations {{{

    filetype plugin indent on
    syntax enable

    call plug#end()

    " this should be placed after dein#install()
    colo Tomorrow-Night-Eighties
    " colo hybrid

" }}}

