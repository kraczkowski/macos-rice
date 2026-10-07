" Run the current Python file, or the project's tests. The keys are in vimrc.
" RunPython: save, then run it with uv in a small pane at the bottom. Vim stays usable while a
" plot window is open, and running again closes the previous run (and its plot) first.
let s:rice_matplotlib = fnamemodify(resolve(expand('<sfile>:p')), ':h:h:h') . '/matplotlib'
function! CloseRun() abort
  if exists('g:rice_run_buf') && bufexists(g:rice_run_buf)
    execute 'bwipeout!' g:rice_run_buf
  endif
endfunction
function! s:RunInPane(cmd, cwd, height) abort
  call CloseRun()
  execute 'botright' a:height . 'new'
  " Point Python at the rice repo's plot-window backend, so it works even in a shell that predates ~/.zshrc.
  let g:rice_run_buf = term_start(a:cmd,
        \ {'curwin': 1, 'cwd': a:cwd, 'term_name': 'run',
        \  'env': {'MPLBACKEND': 'module://ember_backend',
        \          'PYTHONPATH': s:rice_matplotlib . (empty($PYTHONPATH) ? '' : ':' . $PYTHONPATH)}})
  " Ctrl-h/j/k/l leaves this pane. Only here: in any other terminal they stay the shell's keys.
  for l:key in ['h', 'j', 'k', 'l']
    execute 'tnoremap <buffer> <C-' . l:key . '> <C-w>' . l:key
  endfor
  wincmd p
endfunction
function! RunPython() abort
  write
  let l:file = expand('%:p')
  call s:RunInPane(['uv', 'run', 'python', l:file], fnamemodify(l:file, ':h'), 8)
endfunction
" RunTests: run the project's tests (pytest, from the nearest folder above with a pyproject.toml).
function! RunTests() abort
  update
  let l:project = findfile('pyproject.toml', expand('%:p:h') . ';')
  if empty(l:project)
    echo 'No pyproject.toml above this file'
    return
  endif
  call s:RunInPane(['uv', 'run', 'pytest', '-q'], fnamemodify(l:project, ':p:h'), 14)
endfunction
