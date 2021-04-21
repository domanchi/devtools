""""""""""""""""""""""""
" This assumes Vim 7.4 "
""""""""""""""""""""""""

" add colors in vim
syntax on
set colorcolumn=80
highlight Folded ctermbg=Black

colorscheme gruvbox
set background=dark

" fallback color, if gruvbox doesn't work.
"colorscheme monokai

" split windows that actually make sense
set splitbelow
set splitright

" display line numbers in vim
set number

" show column / row number
set ruler

" Folding configs
set foldmethod=syntax   " because indent acts weird with empty lines
set nofoldenable        " so files won't open closed

" Better searching
set incsearch
set hlsearch
