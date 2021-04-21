map <F5> :tabp<Enter>
map <F6> :tabn<Enter>
map ZA :qa!<Enter>
map ZS :wqa<Enter>
map SS :w<Enter>

" Select all
map <C-a> <ESC>ggVG<Enter>

" noexpandtab means don't replace tabs with spaces.
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
autocmd FileType html setlocal shiftwidth=2 tabstop=2

" RT for ReTab
map RT :%s/\t/    /g

" vimdiff
map ]q :diffg LO<Enter>
map ]w :diffg BA<Enter>
map ]e :diffg RE<Enter>
