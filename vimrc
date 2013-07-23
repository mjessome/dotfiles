" .vimrc
" Notes: you are suggested to see
"        http://vimdoc.sourceforge.net/htmldoc/options.html
"        for more information.

" multi-bytes characters support, for example CJK support:
"set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,gb18030,latin1

" Use Vim settings rather than Vi settings
set nocompatible
set encoding=utf-8

" call pathogen to install plugins from .vim/bundle
call pathogen#infect()

autocmd! bufwritepost vimrc source ~/.vimrc
" Write file as superuser
cmap w!! %!sudo tee > /dev/null %
filetype plugin on
filetype indent on

" For session saving
" :mksession /path/to/file
set sessionoptions=blank,buffers,curdir,folds,globals,help,localoptions,options,resize,tabpages,winsize,winpos

" ----------------------------------------------------------------------------
" File Handling
" ----------------------------------------------------------------------------
" Use a single swap directory
set directory^=$HOME/.vim/swp/
" Persistent undo dir
try
    set undodir=~/.vim/undo
    set undolevels=1000
    set undofile
endtry

" ----------------------------------------------------------------------------
" User Interface
" ----------------------------------------------------------------------------
set noerrorbells        " don't make noise
set showcmd             " Show (partial) command in status line
set ruler               " Show line & column number
set nolazyredraw
set whichwrap+=<,>,h,l  " arrow keys wrap around line
set wildmode=longest:full
set wildmenu            " For easier tab completion on command line
set ttyfast
set laststatus=2
let mapleader=","
" Get rid of delay in command mode, for eg. <ESC>O
set timeout timeoutlen=1000 ttimeoutlen=1000

" Get rid of the F1 mapping to help
:nmap <F1> <nop>
:imap <F1> <nop>

" Colour Schemes
set background=dark
set t_Co=256            "Set terminals to use 256, instead of 16 colors
let g:zenburn_high_Contrast=1   " high contrast zenburn for dark bg
let g:zenburn_force_dark_Background = 1
colorscheme zenburn

set showmatch           " briefly jump to matching bracket upon bracket insert
set matchtime=1         " How many 10ths of a second to show the match for

" ----------------------------------------------------------------------------
" Plugin Settings
" ----------------------------------------------------------------------------
" clang_complete
let g:clang_library_path='/usr/local/lib'
let g:clang_snippets=1
let g:clang_close_preview=1
let g:clang_complete_auto=1
set completeopt+=longest
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
inoremap <expr> <C-x><C-i> "\<C-x>\<C-u>"

" Tagbar
cmap tagb TagbarToggle
let Tlist_WinWidth=40
map <F8> :TagbarToggle<CR> :wincmd =<CR>
let g:tagbar_autofocus = 1

" Local vimrc loading
let g:localvimrc_ask=0

" Gitv
let g:Gitv_TruncateCommitSubjects=1

" Ack
nnoremap <leader>a :Ack 

" Status Line
set laststatus=2
set statusline=                              " clear the status line
set statusline=%-3.3n                        " buffer number
set statusline+=%f%m%r%h\                    " file info
set statusline+=[%{&ff}]\ \ \ \              " file formatting
set statusline+=%#warningmsg#
set statusline+=%{fugitive#statusline()}
set statusline+=%*
set statusline+=%=                           " align right
set statusline+=%b,0x%-8B\                   " current char
set statusline+=%-14.(%l,%c%V%)\             " offset
set statusline+=%<%P\                        " percentage scrolled into file

" Gitv
let g:Gitv_TruncateCommitSubjects=1

" Place a coloured column at textwidth
if exists('+colorcolumn')
    set colorcolumn=+0
    highlight ColorColumn ctermbg=234
endif

syntax on               " Turn on syntax highlighting
                        " This has to come after colorcolumn in order to
                        " draw it.

" Highlight bad formatting:
"     * Portions of lines past 'textwidth', or defaults to 80
"           (set g:long_line_m)
"     * leading tabs    (set g:leading_tab_m)
"     * Whitespace at end of line (set g:trailing_whitespace_m)
highlight LongLine ctermbg=grey ctermfg=black guibg=#592929
highlight LeadingTab ctermbg=grey ctermfg=white
highlight TrailingWhitespace ctermbg=grey ctermfg=white
function! ToggleFormatMatching()
    if exists('w:format_match')
        call clearmatches()
        unlet w:format_match
        if exists('w:long_line')
            unlet w:long_line
        endif
        if exists('w:leading_tab')
            unlet w:leading_tab
        endif
        if exists('w:trailing_whitespace')
            unlet w:trailing_whitespace
        endif
    else
        let w:format_match = 1
        if g:long_line_m
            if &textwidth > 0
                let w:long_line = matchadd('LongLine', '\%'.&tw.'v.\+', -1)
            else
                let w:long_line = matchadd('LongLine', '\%80v.\+', -1)
            endif
        endif
        if g:leading_tab_m
            let w:leading_tab = matchadd('LeadingTab', '^\t\+', -1)
        endif
        if g:trailing_whitespace_m
            let w:trailing_whitespace = matchadd('TrailingWhitespace', '\s\+$', -1)
        endif
    endif
endfunction
let g:long_line_m = 1
let g:leading_tab_m = 1
let g:trailing_whitespace_m = 1
nnoremap <silent><leader>h :call ToggleFormatMatching()<CR>

" reselect just pasted text
nnoremap <leader>v V`]

if exists('+colorcolumn')
    set colorcolumn=+0
    highlight ColorColumn ctermbg=234
endif

cmap cwd :lcd %:p:h<CR>
map <leader>p :setlocal paste!<CR>

" Rainbow Parentheses
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
au Syntax * RainbowParenthesesLoadChevrons
map <leader>r :RainbowParenthesesToggleAll<CR>

" ----------------------------------------------------------------------------
" Search
" ----------------------------------------------------------------------------
set hlsearch            " Highligh search matches
set incsearch           " Show search matches as you type
set ignorecase          " Ignore case in search patterns
set smartcase           " Override ignorecase if pattern contains capitals
nmap // :noh<CR>        " Remove search highlighting

" ----------------------------------------------------------------------------
" Formatting
" ----------------------------------------------------------------------------
set tabstop=4
set shiftwidth=4
set expandtab           " Use spaces instead of tabs
set smarttab
set autoindent          " Copy indent from current line when starting new line
set smartindent         " Smart indent on new line, works for C-like langs.
set textwidth=80        " Set comment text width to 80 chars:
set formatoptions=c,q,r         " c: Auto-wrap comments to textwidth
                                " q: Allow formatting comments with "gq".
                                " r: Automatically insert current comment char

" ----------------------------------------------------------------------------
"  Mouse & Keyboard
" ----------------------------------------------------------------------------
set mouse=a         " Enable the use of the mouse.
set mousehide       " Hide the mouse while typing
map <MouseMiddle> <esc>*p       " The mouse to paste unformatted block of code
set backspace=indent,eol,start  " Influences the working of backspaces

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

" ----------------------------------------------------------------------------
" Tabs, Windows and Buffers
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

" ----------------------------------------------------------------------------
" Python FileType
" ----------------------------------------------------------------------------
" Change to width of 79
au FileType python setlocal textwidth=79
au FileType python setlocal number
au FileType python call ToggleFormatMatching()

au FileType python inoremap <buffer> $p print
au FileType python inoremap <buffer> $i import

" don't put comment leader in column 0 as caused by smartindent
au FileType python inoremap # X<BS>#

" ----------------------------------------------------------------------------
" C/CPP FileTypes
" ----------------------------------------------------------------------------
au FileType c,cpp,cc,C,h setlocal number
au FileType c,cpp,cc,C,h,hpp,s,asm call ToggleFormatMatching()
au FileType c,cpp,cc,C,h,hpp,s,asm map <F2> :call MakeWithCopen()<CR>
au FileType c,cpp,cc,C,h,hpp,s,asm map <F3> :cprev<CR>zz
au FileType c,cpp,cc,C,h,hpp,s,asm map <F4> :cnext<CR>zz

au FileType c,cpp,cc,C,h,hpp inoremap <buffer> #in #include 
au FileType c,cpp,cc,C,h,hpp inoremap <buffer> #def #define 

" ----------------------------------------------------------------------------
" HTM/HTML/PHP FileTypes
" ----------------------------------------------------------------------------
au FileType html,htm,php,xml setlocal tabstop=2
au FileType html,htm,php,xml setlocal shiftwidth=2
au FileType html,htm,php,xml setlocal number
au FileType html,htm,php,xml call ToggleFormatMatching()

" ----------------------------------------------------------------------------
" Vim FileType
" ----------------------------------------------------------------------------
au FileType vim setlocal number
au FileType vim call ToggleFormatMatching()
autocmd! bufwritepost .vimrc source ~/.vimrc

" ----------------------------------------------------------------------------
" Makefile FileType
" ----------------------------------------------------------------------------
au FileType make setlocal noexpandtab
au FileType make let g:leading_tab_m=0
au FileType make call ToggleFormatMatching()

" ----------------------------------------------------------------------------
" Shell Script FileTypes
" ----------------------------------------------------------------------------
au FileType zsh,bash,sh setlocal number
au FileType zsh,bash,sh call ToggleFormatMatching()

" ----------------------------------------------------------------------------
" Lisp-like FileTypes
" ----------------------------------------------------------------------------
au FileType lisp,scheme setlocal number
au FileType lisp,scheme call ToggleFormatMatching()
au FileType list,scheme :RainbowParenthesesToggleAll<CR>

" Quickly toggle sequential & relative line numbering
function! ToggleNumberMode()
    if (&relativenumber && !&number)
        set number
    elseif (&number && !&relativenumber)
        set relativenumber
    endif
endfunction
nnoremap <silent><leader>n :call  ToggleNumberMode()<CR>

function! MakeWithCopen()
    make!
    let qflist = getqflist()
    for e in qflist
        if e.valid
            tabnew
            copen
            cc
            break
        endif
    endfor
endfunction

