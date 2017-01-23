map <F5> :tabp<Enter>
map <F6> :tabn<Enter>
map ZA :qa<Enter>
map ZS :wqa<Enter>
map SS :w<Enter>

" Select all
map <C-a> <ESC>ggVG<Enter>

" noexpandtab means don't replace tabs with spaces.
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
map RT :%s/\t/    /g
" RT for ReTab

" add colors in vim
syntax on
colorscheme default
set colorcolumn=80

" split windows that actually make sense
set splitbelow
set splitright

" display line numbers in vim
set number

" Folding configs
set foldmethod=syntax   " because indent acts weird with empty lines
set nofoldenable        " so files won't open closed

" vimdiff
map ]q :diffg LO<Enter>
map ]w :diffg BA<Enter>
map ]e :diffg RE<Enter>

" Needed setting for NERD commenter
" Installation: https://github.com/scrooloose/nerdcommenter#user-content-unix
filetype plugin on

" Better searching
set incsearch
set hlsearch
