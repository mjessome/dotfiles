" .vimrc
" Notes: you are suggested to see
"        http://vimdoc.sourceforge.net/htmldoc/options.html
"        for more information.

" multi-bytes characters support, for example CJK support:
"set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,gb18030,latin1

" Use Vim settings rather than Vi settings
set nocompatible

autocmd! bufwritepost vimrc source ~/.vimrc
cmap w!! %!sudo tee > /dev/null %       " Write file as superuser
filetype plugin on
filetype indent on

" For session saving
" :mksession /path/to/file
set sessionoptions=blank,buffers,curdir,folds,globals,help,localoptions,options,resize,tabpages,winsize,winpos

" Use a single swap directory
set directory^=$HOME/.vim/swp//

" ----------------------------------------------------------------------------
" User Interface
" ----------------------------------------------------------------------------
set noerrorbells        " don't make noise
set showcmd             " Show (partial) command in status line
set ruler               " Show line & column number
set nolazyredraw
set whichwrap+=<,>,h,l  " arrow keys wrap around line
set wildmenu            " For easier tab completion on command line

" Colour Schemes
set background=dark
set t_Co=256            "Set terminals to use 256, instead of 16 colors
colorscheme pw_custom
let g:zenburn_high_Contrast=1   " high contrast zenburn for dark bg
let g:zenburn_force_dark_Background = 1
syntax on               " Turn on syntax highlighting

set showmatch           " briefly jump to matching bracket upon bracket insert
set matchtime=1         " How many 10ths of a second to show the match for

" TagList
cmap tagl TlistToggle 
let Tlist_WinWidth=40
map <F8> :TlistToggle<CR> :wincmd =<CR>


" Status Line
set laststatus=2
set statusline=                              " clear the status line
set statusline+=%-3.3n\                      " buffer number
set statusline+=%F%m%r%h\                    " file info
set statusline+=[%{&ff}]\                    " file formatting
set statusline+=PWD:\ %{getcwd()}/           " pwd
set statusline+=%=                           " align right
set statusline+=%b,0x%-8B\                   " current char
set statusline+=%-14.(%l,%c%V%)\             " offset
set statusline+=%<%P\                        " percentage scrolled into file

" Highlight bad formatting:
"     * Portions of lines past 80 chars wide (79 for python)
"     * leading tabs
"     * Whitespace at end of line
highlight BadFormat ctermbg=red ctermfg=white guibg=#592929
" TODO: Change these to use a line_width variable, or could also use textwidth.
au BufRead,BufnewFile *.C,*.c,*.h,*.cpp,*.cc,*.js,*.ps,*.sh,*.bash match BadFormat /\(\%81v.\+\)\|\(^\t\+\)\|\(\s\+$\)/
au BufRead,BufnewFile *.py,*.pyw match BadFormat /\(\%80v.\+\)\|\(^\t\+\)\|\(\s\+$\)/

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
" Conque Plugin
" ----------------------------------------------------------------------------
let g:ConqueTerm_CloseOnEnd=1       " Close the tab upon program completion
"let g:ConqueTerm_EscKey='<C-w>'     " Exit insert on <C-w>, so 3x<C-w> to
                                    " go back to main window.
"let g:ConqueTerm_CWInsert=1        " Allow <C-w> to leave buffer while in
                                    " insert mode.
let g:ConqueTerm_PyVersion=3
let g:ConqueTerm_SendVisKey='<F9>'  " Send selection to conque buffer on F9
let g:ConqueTerm_ReadUnfocused=1
let g:ConqueTerm_InsertOnEnter=1

" ----------------------------------------------------------------------------
" PyClewn Plugin
" ----------------------------------------------------------------------------
cmap gdb Pyclewn

" ----------------------------------------------------------------------------
" Python FileType
" ----------------------------------------------------------------------------
" Change to width of 79
au FileType python setlocal textwidth=79
au FileType python setlocal number

" Open up a 10 line conque window with the python interpreter at the bottom.
"au FileType python let g:ConqueTerm_InsertOnEnter=0
"au FileType python :ConqueTermSplit python
"au FileType python :set im&     " Exit insert mode
"au FileType python :res 10

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

" ----------------------------------------------------------------------------
" Spell Checking
" ----------------------------------------------------------------------------
"map ss :setlocal spell!<CR>

