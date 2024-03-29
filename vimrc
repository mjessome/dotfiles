" .vimrc
" Notes: you are suggested to see
"        http://vimdoc.sourceforge.net/htmldoc/options.html
"        for more information.

" multi-bytes characters support, for example CJK support:
"set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,gb18030,latin1

" Plugins {{{
call plug#begin('~/.config/nvim/plugged')
Plug 'bogado/file-line'
Plug 'embear/vim-localvimrc'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'mbbill/undotree'
Plug 'mileszs/ack.vim', { 'on': 'Ack' }
Plug 'scrooloose/nerdtree'
Plug 'tmhedberg/matchit'
Plug 'wellle/targets.vim'

Plug 'derekwyatt/vim-fswitch'
Plug 'majutsushi/tagbar'
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
Plug 'm-pilia/vim-ccls'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-fugitive'

" Themes
Plug 'NLKNguyen/papercolor-theme'
Plug 'sjl/badwolf/'
Plug 'tomasr/molokai'
Plug 'romainl/Apprentice'
Plug 'morhetz/gruvbox'
Plug 'jacoborus/tender'
Plug 'fcpg/vim-fahrenheit'
Plug 'muellan/am-colors'
Plug 'KeitaNakamura/neodark.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'smallwat3r/vim-efficient'
call plug#end()
" }}}

" File Handling {{{
" ----------------------------------------------------------------------------
set encoding=utf-8

" Persistent undo dir
if has("persistent_undo")
    set undolevels=1000
    set undofile
    if !has('nvim')
        set undodir=~/.vim/undo//
    endif
endif

if !has('nvim')
  set directory=~/.vim/swap//
endif

" Write file as superuser
cmap w!! %!sudo tee > /dev/null %

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

" Make tabs and trailing whitespace visible
set list
set listchars=tab:>·,trail:·,nbsp:⎵

" Get rid of delay in command mode, for eg. <ESC>O
set timeout timeoutlen=1000 ttimeoutlen=0

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
colorscheme jellybeans

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

" Status Line {{{
" ----------------------------------------------------------------------------
function! GitStatus()
  let l:branch = fugitive#head(8)
  if strlen(l:branch) == 0
    return ''
  endif
  return ' Git:'.l:branch.' '
endfunction

set statusline=
set statusline+=%#Visual#
set statusline+=\ %-3.3n\            " Buffer number
set statusline+=%<%f\                " Filename
set statusline+=%#WarningMsg#%r%*    " Read-only
set statusline+=%#WildMenu#%h%w%m%*  " File status flags
set statusline+=%#Question#
set statusline+=%{GitStatus()}  " Git
set statusline+=%*
set statusline+=%=                   " Right side
set statusline+=%#Visual#
set statusline+=%y\                  " FileType
set statusline+=%-16.((%l/%L,\ %c%V)%)\ %P
" }}}

" Plugin Settings {{{
" ----------------------------------------------------------------------------
" Highlighted Yank
let g:highlightedyank_highlight_duration = 300

"" fzf
nnoremap <leader>ee :FZF<CR>
nnoremap <leader>eb :Buffers<CR>
nnoremap <leader>el :BLines<CR>
nnoremap <leader>eh :History<CR>

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

let g:fzf_layout = { 'down': '~15%' }

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

" Undotree
nnoremap <leader>u :UndotreeToggle<CR>

" Local vimrc loading
let g:localvimrc_ask=0
let g:localvimrc_sandbox=0

" Fugitive
command! Gadd :Git add %
nnoremap <silent><leader>ga :Gadd<CR>
nnoremap <silent><leader>gb :Gblame<CR>
nnoremap <silent><leader>gd :Gdiff<CR>
nnoremap <silent><leader>gs :Gstatus<CR>
nnoremap <silent><leader>gl :silent! Glog<CR>:bot copen<CR>

" Ack
nnoremap <leader>a :Ack 
nnoremap <leader>A :tabnew<CR>:Ack 
if executable('rg') " Use Ripgrep
  let g:ackprg="rg --color never --smart-case --column --no-heading --no-messages -j2"
elseif executable('ag') "Use the Silver Searcher
  let g:ackprg="ag --nocolor --nogroup --column"
endif

" }}}

syntax on               " Turn on syntax highlighting

" Custom Syntax Highlighting {{{
" ----------------------------------------------------------------------------
function s:CustomHighlights()
  syntax match NoteHL "^.*\[MJ\].*$" containedin=ALL
  highlight NoteHL guibg=darkred guifg=white
endfunction

augroup custom_syntax
  autocmd!
  autocmd Syntax * call s:CustomHighlights()
augroup end
" }}}

if exists('+colorcolumn')
  set colorcolumn=+0
  highlight ColorColumn ctermbg=234
endif

" Change directory to file's
command! Cwd :lcd %:p:h

" Copy & Paste
map <leader>p "*p
map <leader>P "*P

" reselect previously changed / yanked text (eg. a paste)
nnoremap <leader>v `[V`]

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
" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
" }}}

" Filetype Settings {{{
" ============================================================================
"

" Python FileType {{{
" ----------------------------------------------------------------------------
au FileType python setlocal textwidth=79
au FileType python setlocal shiftwidth=4
au FileType python setlocal tabstop=4
au FileType python setlocal number

" don't put comment leader in column 0 as caused by smartindent
au FileType python inoremap # X<BS>#

au FileType python setlocal completeopt-=preview

" wscript files are python files
au BufNewFile,BufRead */wscript set ft=python
" }}}

" C/C++ FileTypes {{{
" ----------------------------------------------------------------------------
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
if has('nvim')
autocmd! bufwritepost vimrc source ~/.config/nvim/init.vim
autocmd! bufwritepost init.vim source ~/.config/nvim/init.vim
else
autocmd! bufwritepost vimrc source ~/.vimrc
autocmd! bufwritepost .vimrc source ~/.vimrc
endif
" }}}

" Makefile FileType {{{
" ----------------------------------------------------------------------------
au FileType make setlocal noexpandtab
au FileType make let g:leading_tab_m=0
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

" Coc.nvim {{{

set shortmess+=c
set updatetime=300

nmap <silent><leader>ld <Plug>(coc-definition)
nmap <silent><leader>lD <Plug>(coc-declaration)
nmap <silent><leader>lr <Plug>(coc-references)

nnoremap <silent><leader>lk :call CocActionAsync('doHover')<cr>

" List and search
nnoremap <silent><leader>ll :CocList<cr>
nnoremap <silent><leader>ls :CocList outline<cr>
nnoremap <silent><leader>lw :CocList -I symbols<cr>
nnoremap <leader>la :CocSearch 

" Folding
nnoremap <leader>lz :call CocActionAsync('fold')<cr>

" Rename
nmap <leader>ln <Plug>(coc-rename)
nmap <leader>lm <Plug>(coc-refactor)

" Tab/S-Tab to move through completions
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Tab/S-Tab to move through snippet positions
let g:coc_snippet_next = "<Tab>"
let g:coc_snippet_prev = "<S-Tab>"

" Ccls.vim
let g:ccls_close_on_jump = v:true
nnoremap <leader>lc :CclsCallHierarchy<CR>

" }}}

" vim:foldmethod=marker
