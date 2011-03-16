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

" ----------------------------------------------------------------------------
" User Interface
" ----------------------------------------------------------------------------
set showcmd             " Show (partial) command in status line
set ruler               " Show line & column number
set nolazyredraw
set whichwrap+=<,>,h,l  " arrow keys wrap around line
set wildmenu            " For easier tab completion on command line
colorscheme icansee
set background=dark
syntax on               " Turn on syntax highlighting

" Highlight portions of lines past the 80th column
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

set showmatch           " briefly jump to matching bracket upon bracket insert
set matchtime=1         " How many 10ths of a second to show the match for

" ----------------------------------------------------------------------------
" Search
" ----------------------------------------------------------------------------
set hlsearch            " Highligh search matches
set incsearch           " Show search matches as you type
set ignorecase          " Ignore case in search patterns
set smartcase           " Override ignorecase if pattern contains capitals

" ----------------------------------------------------------------------------
" Formatting
" ----------------------------------------------------------------------------
set tabstop=8
set shiftwidth=8
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
" Tabs
" ----------------------------------------------------------------------------
cmap tn tabnew
nmap <tab> :tabnext<CR>

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
" Change to witdh of 79
au FileType python match OverLength /\%80v.\+/
au FileType python setlocal textwidth=79

au FileType python setlocal number

" Open up a small conque window with the python interpreter at the bottom.
"au FileType python let g:ConqueTerm_InsertOnEnter=0
au FileType python :ConqueTermSplit python
au FileType python :set im&     " Exit insert mode
au FileType python :res 10

" ----------------------------------------------------------------------------
" C/CPP FileTypes
" ----------------------------------------------------------------------------
au FileType c,cpp,cc,C setlocal number

" ----------------------------------------------------------------------------
" HTM/HTML/PHP FileTypes
" ----------------------------------------------------------------------------
au FileType html,htm,php setlocal tabstop=2
au FileType html,htm,php setlocal shiftwidth=2

" ----------------------------------------------------------------------------
" Spell Checking
" ----------------------------------------------------------------------------
map ss :setlocal spell!<CR>

