" Format Python on save.
" ruff rewrites spacing, quotes and line breaks. A file with a syntax error is left as typed.
function! s:FormatPython() abort
  let l:old = getline(1, '$')
  let l:new = systemlist('uvx ruff format --quiet --stdin-filename ' . shellescape(expand('%:p'))
        \ . ' - 2>/dev/null', l:old)
  if v:shell_error || empty(l:new) || l:new ==# l:old
    return
  endif
  let l:view = winsaveview()
  call setline(1, l:new)
  call deletebufline('%', len(l:new) + 1, '$')
  call winrestview(l:view)
endfunction
augroup rice_format
  autocmd!
  autocmd BufWritePre *.py call s:FormatPython()
augroup END
