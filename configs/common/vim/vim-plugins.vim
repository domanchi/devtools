"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" After changing this file, be sure to run `:PlugInstall` "
" in the vim screen, to install new plugins.              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 

call plug#begin()

    " This plugin allows for quick commenting of lines by doing
    " `\c ` to toggle comments on large chunks of code.
    Plug 'scrooloose/nerdcommenter'

    " This allows for faster code folding.
    Plug 'Konfekt/FastFold'

    " This allows for better Python folding.
    Plug 'tmhedberg/SimpylFold'

call plug#end()

" Necessary for NERDCommenter
filetype plugin on
