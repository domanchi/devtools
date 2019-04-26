" http://vim.wikia.com/wiki/Improved_hex_editing
function! ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    silent :e " this will reload the file without trickeries 
              "(DOS line endings will be shown entirely )
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

command Hexmode call ToggleHex()

" https://vi.stackexchange.com/a/5919
function! Rotate()
    " save the original position, jump to the first window
    let initial = winnr()
    exe 1 . "wincmd w"

    wincmd 1
    if winnr() != 1
        " succeeded moving to the right window
        wincmd J " make it the bottom window
    else
        " cannot move to the right, so we are at the top
        wincmd H " make it the left window
    endif

    " restore cursor to the initial window
    exe initial . "wincmd w"
endfunction

" Rotate splits easily
map <C-w><C-r> :call Rotate()<Enter>
