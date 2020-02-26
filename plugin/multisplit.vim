" FILE:     multisplit.vim
" AUTHOR:   Daniel Horner <daniel_horner@pobox.com>
" VERSION:  1.0
" DESCRIPTION:
" This module defines new window motion keystrokes to navigate between a large
" set of vertical splits. The splits are resized as you move into them  to
" make the current window readable. The remaining space is allocated uniformly
" between remaining windows.
"
"
" LICENSE:
"
" Multisplit.vim
" (c) Daniel Horner 2012
" 
" MIT License
" 
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal in the Software without restriction, including without limitation the
" rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
" sell copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
" 
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
" 
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
" FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
" IN THE SOFTWARE.
"

if exists("g:loaded_multisplit_vim")
    finish
endif
let g:loaded_multisplit_vim = 1


" Size to reserve for the highlighted window
if !exists("g:winSplitSize")
    let g:winSplitSize=100
endif

"Navigate left and right
map <C-W><C-l> :MoveSplit l<CR>
map <C-W><C-h> :MoveSplit h<CR>

"Expand the current window
map <C-W><C-i> :ExpandCurrentWindow<CR>

" I like to drill down into a few splits, using tags (<C-W>]) 
" or filenames (<C-W><C-F>) and then Delete the old windows at the edge
map <C-W><C-b> :DeleteLeftmost<CR> 
map <C-W><C-m> :DeleteRightmost<CR>

map <C-W><C-n> :CreateSplit<CR>

" CREATE A SPLIT
command! CreateSplit call CreateSplit()
command! -nargs=1 MoveSplit call MoveSplit(<f-args>)
command! DeleteLeftmost call DeleteLeftmost()
command! DeleteRightmost call DeleteRightmost()
command! ExpandCurrentWindow call ExpandCurrentWindow()


function! CreateSplit()
  vsplit
  call MoveSplit('l')
endfunction

function! MoveSplit(direction)
  exec ('wincmd ' . a:direction)
  call ExpandCurrentWindow()
endfunction

function! ExpandCurrentWindow()
	exec('vertical resize '.g:winSplitSize)
	call BalanceOtherWindows()
endfunction

function! BalanceOtherWindows()
  let &winfixwidth=1
  wincmd =
  let &winfixwidth=0
endfunction

function! DeleteLeftmost()
  let w=FindFarthest('h')
  call CloseWindow(w)
  call BalanceOtherWindows()
endfunction

function! DeleteRightmost()
   let w=FindFarthest('l')
  call CloseWindow(w)
  call BalanceOtherWindows()
endfunction

function! CloseWindow(w)
  let l:currentWin=winnr()
  exec a:w . ' wincmd w'
  if l:currentWin > a:w
	  let l:currentWin = l:currentWin - 1
  endif
  close
  exec l:currentWin . ' wincmd w'
endfunction

function! FindFarthest(direction)
  let l:startWin = winnr()
  let l:previousWin = -1
  while winnr() != l:previousWin
    let l:previousWin = winnr()
    exec 'wincmd '. a:direction 
  endwhile
  let l:found = winnr()
  exec l:startWin .' wincmd w'
  return l:found
endfunction
