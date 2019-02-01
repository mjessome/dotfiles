" .vimrc
" Notes: you are suggested to see
"        http://vimdoc.sourceforge.net/htmldoc/options.html
"        for more information.

" multi-bytes characters support, for example CJK support:
"set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,gb18030,latin1


" Plugins {{{
call plug#begin('~/.vim/plugged')
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'scrooloose/nerdtree'
Plug 'embear/vim-localvimrc'
Plug 'tmhedberg/matchit'
Plug 'bogado/file-line'
Plug 'majutsushi/tagbar'
Plug 'tomtom/tcomment_vim'
Plug 'rust-lang/rust.vim'
Plug 'derekwyatt/vim-fswitch'
Plug 'machakann/vim-highlightedyank'
Plug 'wellle/targets.vim'

" ctrlp
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-register'
Plug 'JazzCore/ctrlp-cmatcher', { 'do': './install.sh' }

Plug 'mileszs/ack.vim', { 'on': 'Ack' }
Plug 'Rip-Rip/clang_complete', { 'for': ['c', 'cpp'], 'do': 'make install' }

Plug 'racer-rust/vim-racer'

" Themes
Plug 'sjl/badwolf/'
Plug 'tomasr/molokai'
Plug 'romainl/Apprentice'
Plug 'morhetz/gruvbox'
Plug 'jacoborus/tender'
Plug 'fcpg/vim-fahrenheit'
Plug 'muellan/am-colors'
Plug 'KeitaNakamura/neodark.vim'
call plug#end()
" }}}

" File Handling {{{
" ----------------------------------------------------------------------------
set encoding=utf-8
" Use a single swap directory
set directory^=$HOME/.vim/swp/

" Persistent undo dir
try
    set undodir=~/.vim/undo
    set undolevels=1000
    set undofile
endtry

" Write file as superuser
cmap w!! %!sudo tee > /dev/null %

" Relaod vimrc when writing to it
autocmd! bufwritepost vimrc source ~/.vimrc

filetype plugin on
filetype indent on
" }}}

" User Interface {{{
" ============================================================================ 
set noerrorbells        " don't make noise
set showcmd             " Show (partial) command in status line
set ruler               " Show line & column number
set nolazyredraw
set whichwrap+=<,>,h,l  " arrow keys wrap around line
set wildmode=list:longest:full
set wildmenu            " For easier tab completion on command line
set ttyfast
set laststatus=2
set number
"let mapleader=" "
map <space> <leader>
set breakindent         " Wrapped lines will preserve indent

" Mouse to be able to click on a really wide terminal
if !has('nvim')
"set ttymouse=urxvt
endif

" Make tabs and trailing whitespace visible
set list
set listchars=tab:>·,trail:·,nbsp:⎵

" Get rid of delay in command mode, for eg. <ESC>O
set timeout timeoutlen=1000 ttimeoutlen=1000

" Get rid of the F1 mapping to help
nmap <F1> <nop>
imap <F1> <nop>

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Colour Scheme Settings
set background=dark
let g:neodark#background = '#3f3f3f'
colorscheme neodark

set showmatch     " briefly jump to matching bracket upon bracket insert
set matchtime=1   " How many 10ths of a second to show the match for

autocmd InsertLeave * if &diff|diffupdate|endif

set cursorline  " highlight current line
nnoremap <silent><leader>c :set cursorline!<CR>
nnoremap <silent><leader>C :set cursorcolumn!<CR>

" Don't wait for return press when viewing a man page.
if !has('nvim')
  nnoremap K :<c-u>exe "!man " (v:count == 0 ? '' : '-s ' . v:count . ' ') . shellescape(expand('<cword>')) <cr><cr>
endif

" }}}

" Plugin Settings {{{
" ----------------------------------------------------------------------------
" clang_complete
"let g:clang_library_path='/usr/lib/llvm-3.4/lib'
let s:clang_library_path='/Library/Developer/CommandLineTools/usr/lib'
if isdirectory(s:clang_library_path)
    let g:clang_library_path=s:clang_library_path
endif
let g:clang_snippets=1
let g:clang_close_preview=1
let g:clang_complete_auto=1
let g:clang_use_library=1
let g:clang_auto_user_options='compile_commands.json'
set completeopt+=longest
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
inoremap <expr> <C-x><C-i> "\<C-x>\<C-u>"

" vim-racer
let g:racer_cmd = "/Users/marc.jessome/.cargo/bin/racer"
let g:racer_experimental_completer = 1

" Highlighted Yank
let g:highlightedyank_highlight_duration = 300

" Airline
let g:airline_left_sep='▶'
let g:airline_right_sep='◀'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" CtrlP
let g:ctrlp_working_path_mode = 'rwa'
set wildignore+=*/tmp/*,*.o,*.so,*.swp,*.zip,*.tar.gz,*.tgz,*.pyc
let g:ctrlp_map = '<leader>e'
nnoremap <leader>b :CtrlPBuffer<CR>
if executable('rg') " Use Ripgrep
  let g:ctrlp_user_command = 'rg %s -i
        \ --color never
        \ --no-heading
        \ --hidden
        \ --files
        \ -j2
        \ --no-messages
        \ -g "!**/*.pyc"
        \ -g "!.git"
        \ -g "!.svn"
        \ -g "!.hg"
        \ -g "!.DS_Store"'
elseif executable('ag') " Use the Silver Searcher
  let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
        \ --ignore .git
        \ --ignore .svn
        \ --ignore .hg
        \ --ignore .DS_Store
        \ --ignore "**/*.pyc"
        \ -g ""'
endif
"let g:ctrlp_match_func = { 'match' : 'matcher#cmatch' }

" Tagbar
let Tlist_WinWidth=40
map <F8> :TagbarToggle<CR> :wincmd =<CR>
let g:tagbar_autofocus = 1
" Speed up cursor movement
autocmd FileType tagbar setlocal nocursorline nocursorcolumn

" Ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" NERDTree
map <F9> :NERDTreeToggle<CR>

" Local vimrc loading
let g:localvimrc_ask=0
let g:localvimrc_sandbox=0

" Fugitive
command! Gadd :Git add %
nnoremap <silent><leader>gb :Gblame<CR>
nnoremap <silent><leader>gd :Gdiff<CR>
nnoremap <silent><leader>gs :Gstatus<CR>
nnoremap <silent><leader>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <silent><leader>ga :Gadd<CR>

" Ack
nnoremap <leader>a :Ack 
nnoremap <leader>A :tab<CR>:Ack 
if executable('rg') " Use Ripgrep
  let g:ackprg="rg --color never --smart-case --column --no-heading --no-messages -j2"
elseif executable('ag') "Use the Silver Searcher
  let g:ackprg="ag --nocolor --nogroup --column"
endif

" }}}

syntax on               " Turn on syntax highlighting

" Custom syntax highlighting support
highlight CustomSyntax ctermfg=144

" Note Highlight {{{
" ----------------------------------------------------------------------------
highlight NoteHL ctermbg=52 ctermfg=white
function! EnableNoteHilights()
  "if ! exists('b:note_hl')
    "let b:note_hl = matchadd('NoteHL', '^.*\[MJ\].*$')
  "endif
endfunction
" }}}

if exists('+colorcolumn')
    set colorcolumn=+0
    highlight ColorColumn ctermbg=234
endif

" Change directory to file's
command! Cwd :lcd %:p:h<CR>

" Copy & Paste
map <leader>p "*p
map <leader>P "*P

" reselect just pasted text
nnoremap <leader>v V`]

" Search and Replace {{{
" ----------------------------------------------------------------------------
set hlsearch            " Highligh search matches
set incsearch           " Show search matches as you type
set ignorecase          " Ignore case in search patterns
set smartcase           " Override ignorecase if pattern contains capitals

" Clear search highlight
nnoremap <silent><leader>/ :noh<CR>
highlight Search ctermfg=black ctermbg=174

" nvim incremental / live substitute
if has('nvim')
  set inccommand=split
endif

" }}}

" Default Formatting {{{
" ----------------------------------------------------------------------------
set tabstop=2
set shiftwidth=2
set expandtab           " Use spaces instead of tabs
set smarttab
set autoindent          " Copy indent from current line when starting new line
set smartindent         " Smart indent on new line, works for C-like langs.
set textwidth=80        " Set comment text width to 80 chars:
set formatoptions=tcqjr
" }}}

"  Mouse & Keyboard {{{
" ============================================================================
set mouse=a         " Enable the use of the mouse.
set mousehide       " Hide the mouse while typing
map <MouseMiddle> <esc>*p       " The mouse to paste unformatted block of code
set backspace=indent,eol,start  " Influences the working of backspaces

" Movement {{{
" Get rid of arrow keys.
nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>
" movement done by visual line, not file line
nnoremap j gj
nnoremap k gk
" bash-like movement
inoremap <C-a> <esc>I
inoremap <C-e> <esc>A
cnoremap <C-a> <home>
cnoremap <C-e> <end>
vnoremap <C-a> ^
vnoremap <C-e> g_

" quicker escaping
inoremap jj <ESC>
" }}}

" }}}

" Tabs, Windows and Buffers {{{
" ----------------------------------------------------------------------------
set switchbuf=useopen
" can have unwritten buffers in background
set hidden
cmap tbn tabnew 
cmap <leader>tc tagclose
" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
" }}}

" Filetype Settings {{{
" ============================================================================

" Python FileType {{{
" ----------------------------------------------------------------------------
au FileType python setlocal textwidth=79
au FileType python setlocal shiftwidth=4
au FileType python setlocal tabstop=4
au FileType python setlocal number

au FileType python inoremap <buffer> $p print
au FileType python inoremap <buffer> $i import

" don't put comment leader in column 0 as caused by smartindent
au FileType python inoremap # X<BS>#

au FileType python setlocal completeopt-=preview
au FileType python call EnableNoteHilights()

" wscript files are python files
au BufNewFile,BufRead */wscript set ft=python
" }}}

" C/C++ FileTypes {{{
" ----------------------------------------------------------------------------
au FileType c,cpp,cc,C,h,hpp,s,asm map <F2> :call MakeWithCopen()<CR>
au FileType c,cpp,cc,C,h,hpp,s,asm map <F3> :cprev<CR>zz
au FileType c,cpp,cc,C,h,hpp,s,asm map <F4> :cnext<CR>zz
au FileType c,cpp,cc,C,h,hpp,s,asm call EnableNoteHilights()

fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
au FileType c,cpp,cc,C,h,hpp,s,asm map <leader>f :call ShowFuncName()<CR>
" }}}

" HTM/HTML/PHP FileTypes {{{
" ----------------------------------------------------------------------------
au FileType html,htm,php,xml setlocal tabstop=2
au FileType html,htm,php,xml setlocal shiftwidth=2
" }}}

" Vim FileType {{{
" ----------------------------------------------------------------------------
autocmd! bufwritepost .vimrc source ~/.vimrc
" }}}

" Makefile FileType {{{
" ----------------------------------------------------------------------------
au FileType make setlocal noexpandtab
au FileType make let g:leading_tab_m=0
" }}}

" Shell Script FileTypes {{{
" ----------------------------------------------------------------------------
" }}}

" Lisp-like FileTypes {{{
" ----------------------------------------------------------------------------
" }}}

" SQL FileTypes {{{
" ----------------------------------------------------------------------------
au BufNewFile,BufRead *.presto set filetype=sql
" }}}

""" }}}

" Quickly toggle sequential & relative line numbering
function! ToggleNumberMode()
    if (&relativenumber)
        set number
        set norelativenumber
    elseif (!&relativenumber)
        " leave number set so current line is numbered
        set relativenumber
    endif
endfunction
nnoremap <silent><leader>n :call ToggleNumberMode()<CR>

function! MakeWithCopen()
    make!
    let qflist = getqflist()
    for e in qflist
        if e.valid
            if exists('w:build_window')
                copen
                cc
            else
                tabnew
                let w:build_window=1
                copen
                cc
            endif
            break
        endif
    endfor
endfunction

" Insert blank line above or below, remove any possible comment continuations
nnoremap <leader>iO O<Esc>S<Esc>j
nnoremap <leader>io o<Esc>S<Esc>k
nnoremap <leader>ic o<Esc>S<Esc>80i/<Esc>yypO<Esc>S//

" Cscope {{{
if has("cscope")
  set cscopetag
  set cscopetagorder=0

  command! Cr :cscope reset
  command! -nargs=+ Cc :cscope find c <args>
  command! -nargs=+ Cg :cscope find g <args>
  command! -nargs=+ Ce :cscope find e <args>
  command! -nargs=+ Cs :cscope find s <args>
  command! -nargs=+ Cd :cscope find d <args>
  command! -nargs=+ Ci :cscope find i <args>
endif
" }}}

" vim:foldmethod=marker
