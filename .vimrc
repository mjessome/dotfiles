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
set wildmenu            " For easier tab completion on command line
set number

cmap :tc tagclose

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

" Tagbar
cmap tagb TagbarToggle
let Tlist_WinWidth=40
map <F8> :TagbarToggle<CR> :wincmd =<CR>
let g:tagbar_autofocus = 1

" Local vimrc loading
let g:localvimrc_ask=0

" Status Line
set laststatus=2
set statusline=                              " clear the status line
set statusline=%-3.3n                        " buffer number
set statusline+=%f%m%r%h\                    " file info
set statusline+=[%{&ff}]\ \ \ \              " file formatting
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
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
"     * Portions of lines past 80 chars wide (79 for python)
"     * leading tabs
"     * Whitespace at end of line
highlight BadFormat ctermbg=red ctermfg=white guibg=#592929
" TODO: Change these to use a line_width variable, or could also use textwidth.
au BufRead,BufnewFile *.C,*.c,*.h,*.cpp,*.cc,*.js,*.ps,*.sh,*.bash match BadFormat /\(\%81v.\+\)\|\(^\t\+\)\|\(\s\+$\)/
au BufRead,BufnewFile *.py,*.pyw match BadFormat /\(\%80v.\+\)\|\(^\t\+\)\|\(\s\+$\)/

" set local pwd to same as file
cmap cwd :lcd $:p:h<CR>

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
" don't put comment leader in column 0 as caused by smartindent
:inoremap # X<BS>#

" ----------------------------------------------------------------------------
"  Mouse & Keyboard
" ----------------------------------------------------------------------------
set mouse=a         " Enable the use of the mouse.
set mousehide       " Hide the mouse while typing
map <MouseMiddle> <esc>*p       " The mouse to paste unformatted block of code
set backspace=indent,eol,start  " Influences the working of backspaces

" ----------------------------------------------------------------------------
" Tabs and Windows
" ----------------------------------------------------------------------------
cmap tbn tabnew 
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
au FileType python inoremap <buffer> $p print
au FileType python inoremap <buffer> $i import

" ----------------------------------------------------------------------------
" C/CPP FileTypes
" ----------------------------------------------------------------------------
au FileType c,cpp,cc,C,h setlocal number

" ----------------------------------------------------------------------------
" HTM/HTML/PHP FileTypes
" ----------------------------------------------------------------------------
au FileType html,htm,php,xml setlocal tabstop=2
au FileType html,htm,php,xml setlocal shiftwidth=2
au FileType html,htm,php,xml setlocal number

" ----------------------------------------------------------------------------
" Vim FileType
" ----------------------------------------------------------------------------
au FileType vim setlocal number

