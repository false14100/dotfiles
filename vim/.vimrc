set mouse=a
set number
set rnu
syntax on
set nocompatible
filetype on
filetype plugin on
filetype indent on
set cursorline
set cursorcolumn
set shiftwidth=4
set tabstop=4
set softtabstop=4
set scl="yes:2"
set expandtab
set nobackup
set scrolloff=10
set nowrap
set incsearch
set ignorecase
set showcmd
set showmode
set showmatch
set hlsearch
set splitbelow
set history=1000
set encoding=utf-8
set nobackup
set updatetime=300
set signcolumn=yes
set clipboard=unnamed,unnamedplus
set wildmenu
set list
set listchars=eol:↴,tab:\ \ ╎,extends:»,precedes:«,trail:·
set undofile
set undodir=~/.vim/undodir
let mapleader = " "
set pumheight=10
set visualbell
set t_vb=
set rtp^="/home/suman/.opam/default/share/ocp-indent/vim"

" Additional improvements
set smartcase
set smartindent
set autoindent
set autoread
set nowritebackup
set noswapfile
set splitright
set ttyfast
set lazyredraw
set termguicolors

" Ensure undodir exists
if !isdirectory(&undodir)
    call mkdir(&undodir, 'p')
endif
"}}}

" Lexplorer {{{
let g:netrw_keepdir = 0
let g:netrw_banner = 0
let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_winsize = 27
let g:netrw_bufsettings='wru,nr'
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
nnoremap <Leader>e :Ex <CR>
"}}}


" Smart Clipboard Configuration {{{
" Automatically detect clipboard support and display server

function! s:DetectClipboard()
    " Case 1: Vim has built-in clipboard support
    if has('clipboard')
        return 'native'
    endif

    " Case 2: No clipboard support, detect display server
    " Check for Wayland first
    if $WAYLAND_DISPLAY != '' || $XDG_SESSION_TYPE == 'wayland'
        " Verify wl-copy/wl-paste are available
        if executable('wl-copy') && executable('wl-paste')
            return 'wayland'
        endif
    endif

    " Check for X11
    if $DISPLAY != '' || $XDG_SESSION_TYPE == 'x11'
        " Verify xclip is available
        if executable('xclip')
            return 'x11'
        endif
    endif

    " Fallback: no external clipboard available
    return 'none'
endfunction

let s:clipboard_type = s:DetectClipboard()

" Configure mappings based on detected clipboard type
if s:clipboard_type == 'native'
    " Case 1: Native clipboard support (+clipboard)
    vnoremap <leader>y "+y
    nnoremap <leader>Y "+Y
    nnoremap <leader>p "+p
    nnoremap <leader>P "+P
    vnoremap <leader>p "+p

elseif s:clipboard_type == 'wayland'
    " Case 2a: Wayland with wl-clipboard
    vnoremap <leader>y y:call system('wl-copy', @")<CR>
    nnoremap <leader>Y y$:call system('wl-copy', @")<CR>
    nnoremap <leader>p :call setreg('"', system('wl-paste'))<CR>p
    nnoremap <leader>P :call setreg('"', system('wl-paste'))<CR>P
    vnoremap <leader>p "_d:call setreg('"', system('wl-paste'))<CR>P

elseif s:clipboard_type == 'x11'
    " Case 2b: X11 with xclip
    vnoremap <leader>y y:call system('xclip -selection clipboard', @")<CR>
    nnoremap <leader>Y y$:call system('xclip -selection clipboard', @")<CR>
    nnoremap <leader>p :call setreg('"', system('xclip -selection clipboard -o'))<CR>p
    nnoremap <leader>P :call setreg('"', system('xclip -selection clipboard -o'))<CR>P
    vnoremap <leader>p "_d:call setreg('"', system('xclip -selection clipboard -o'))<CR>P

else
    " No clipboard support available - inform user
    echohl WarningMsg
    echo "Warning: No clipboard support detected. Install xclip (X11) or wl-clipboard (Wayland), or use vim with +clipboard"
    echohl None
endif

"}}}

" QuickFixList
nnoremap <C-j> :cnext<cr>
nnoremap <C-k> :cprev<cr>

nnoremap <Leader>no :nohls<CR>
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap G Gzz
inoremap <C-c> <Esc>
nnoremap <C-d> <C-d>zz<Esc>
nnoremap <C-u> <C-u>zz<Esc>
nnoremap ]b :bnext<CR>
nnoremap [b :bprevious<CR>
nnoremap ]t :tabnext<CR>
nnoremap [t :tabprevious<CR>
nnoremap <Leader>u :MundoToggle<CR>
nnoremap <Leader>lf  gg=G<C-o><C-o>
"}}}

" Theme {{{
set background=dark
let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1
colorscheme base16-classic-dark

" Custom Line Number Highlighting
highlight LineNrAbove guifg=#aa759f gui=bold ctermfg=205 cterm=bold
highlight LineNr guifg=#f5f5f5 gui=bold ctermfg=white cterm=bold
highlight LineNrBelow guifg=#6a9fb5 gui=bold ctermfg=39 cterm=bold
"}}}

" FZF {{{
nnoremap <silent> <Leader>sb :Buffers<CR>
nnoremap <silent> <Leader>sf :Files<CR>
nnoremap <silent> <Leader>sh :Help<CR>
nnoremap <silent> <C-p> :GFiles<CR>
nnoremap <silent> <Leader>sg :Rg<CR>
nnoremap <silent> <Leader>/ :BLines<CR>
nnoremap <silent> <Leader>' :Marks<CR>
nnoremap <silent> <Leader>H :Helptags<CR>
nnoremap <silent> <Leader>hh :History<CR>
nnoremap <silent> <Leader>h: :History:<CR>
nnoremap <silent> <Leader>h/ :History/<CR>
" Git-fzf
nnoremap <silent> <Leader>gc :Commits<CR>
nnoremap <silent> <Leader>bc :BCommits<CR>
nnoremap <silent> <Leader>gh :GFiles?<CR>

function! s:build_quickfix_list(lines)
      call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
      copen
      cc
endfunction

let g:fzf_action = {
                  \ 'ctrl-q': function('s:build_quickfix_list'),
                  \ 'ctrl-t': 'tab split',
                  \ 'ctrl-x': 'split',
                  \ 'ctrl-v': 'vsplit' }

let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let g:fzf_buffers_jump = 1
"}}}

" Plugins {{{
call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'dense-analysis/ale'
Plug 'tribela/vim-transparent'
Plug 'xianzhon/vim-code-runner'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'chrisbra/Colorizer'
Plug 'sheerun/vim-polyglot'
Plug 'simnalamburt/vim-mundo'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'puremourning/vimspector'
Plug 'idanarye/vim-merginal'
Plug 'machakann/vim-highlightedyank'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'chriskempson/base16-vim'
call plug#end()
"}}}

" Code Runner {{{
nmap <silent><leader>cr <plug>CodeRunner
let g:code_runner_save_before_execute = 1

let g:CodeRunnerCommandMap = {
                  \ 'python' : 'python3 $fileName',
                  \ 'cpp' : 'g++ -std=c++17 $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt',
                  \ 'c' : 'gcc $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt',
                  \ 'java' : 'javac $fileName && java $fileNameWithoutExt',
                  \ 'kotlin' : 'kotlinc $fileName -include-runtime -d $fileNameWithoutExt.jar && java -jar $fileNameWithoutExt.jar',
                  \ 'cs' : 'mcs $fileName && mono $fileNameWithoutExt.exe',
                  \ 'go' : 'go run $fileName',
                  \ 'javascript' : 'node $fileName',
                  \ 'typescript' : 'ts-node $fileName',
                  \ 'rust' : 'rustc $fileName && ./$fileNameWithoutExt',
                  \ 'php' : 'php $fileName',
                  \ 'ruby' : 'ruby $fileName',
                  \ 'perl' : 'perl $fileName',
                  \ 'lua' : 'lua $fileName',
                  \ 'sh' : 'bash $fileName',
                  \}
"}}}

" Git Gutter {{{
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
nmap <Leader>hp <Plug>(GitGutterPreviewHunk)
nmap <Leader>hs <Plug>(GitGutterStageHunk)
nmap <Leader>hu <Plug>(GitGutterUndoHunk)

" Enhanced GitGutter settings
let g:gitgutter_preview_win_floating = 1
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_modified_removed = '±'
"}}}

" Vim Fugitive {{{

nnoremap <Leader>gg :0G<CR>
nnoremap <Leader>mm :MerginalToggle<CR>

" Fugitive Conflict Resolution
nnoremap <leader>df :Gvdiff<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>
"}}}

" Highlighted Yank {{{
let g:highlightedyank_highlight_duration = 100
"}}}

" AirLine {{{
let g:airline_theme='base16_classic_dark'
"}}}

" Templates {{{
function! ChooseTemplate()
      let l:filetype = &filetype

      let l:template_dir = expand('~/.vim/templates/' . l:filetype . '/')

      let l:templates = glob(l:template_dir . '*', 0, 1)

      if empty(l:templates)
            echo "No templates found for file type: " . l:filetype
            return
      endif

      let l:menu = ""
      for l:idx in range(len(l:templates))
            let l:template_name = fnamemodify(l:templates[l:idx], ':t')
            let l:menu .= printf("%d. %s\n", l:idx + 1, l:template_name)
      endfor

      let l:choice = input(l:menu . "\nChoose a template: ")

      if l:choice !~ '^\d\+$' || l:choice < 1 || l:choice > len(l:templates)
            echo "Invalid choice."
            return
      endif

      let l:chosen_template = l:templates[l:choice - 1]

      execute '0r ' . l:chosen_template
endfunction

nnoremap <leader>t :call ChooseTemplate()<CR>
"}}}

" Auto Commands {{{
augroup VimrcAutoCommands
  autocmd!
  " Return to last edit position when opening files
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  " Auto-create directories when saving files
  autocmd BufWritePre * if !isdirectory(expand('<afile>:p:h')) | call mkdir(expand('<afile>:p:h'), 'p') | endif

  " Remove trailing whitespace on save for specific filetypes
  autocmd BufWritePre *.py,*.js,*.ts,*.jsx,*.tsx,*.c,*.cpp,*.h,*.hpp :%s/\s\+$//e
augroup END
"}}

" Vimspector {{{
let g:vimspector_enable_mappings = 'HUMAN'

" Custom keymaps matching your DAP configuration
nnoremap <leader>db <Plug>VimspectorToggleBreakpoint
nnoremap <leader>dB <Plug>VimspectorToggleConditionalBreakpoint
nnoremap <leader>dS <Plug>VimspectorContinue
nnoremap <F3> <Plug>VimspectorStepInto
nnoremap <F1> <Plug>VimspectorStepOver
nnoremap <F4> <Plug>VimspectorStepOut
nnoremap <F2> <Plug>VimspectorUpFrame
nnoremap <F5> <Plug>VimspectorRestart
nnoremap <leader>dt <Plug>VimspectorStop
nnoremap <leader>dr :VimspectorReset<CR>

" Additional useful mappings
nnoremap <leader>di <Plug>VimspectorBalloonEval
xnoremap <leader>di <Plug>VimspectorBalloonEval
nnoremap <leader>dw :VimspectorWatch<CR>
nnoremap <leader>do :VimspectorShowOutput<CR>
"}}}

