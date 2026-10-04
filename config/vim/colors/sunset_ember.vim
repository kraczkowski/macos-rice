" Sunset Ember — dark teal + sunset reds. Palette mirrors config/ghostty/config.
" Needs `set termguicolors`. The background is left empty so Ghostty's transparency shows through.

highlight clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name = 'sunset_ember'
set background=dark

function! s:hi(group, fg, bg, style) abort
  execute 'highlight' a:group
        \ 'guifg=' . a:fg 'guibg=' . a:bg 'gui=' . a:style 'cterm=' . a:style
endfunction

let s:bg      = '#0a1618'
let s:surface = '#162930'
let s:text    = '#e8d5c2'
let s:sand    = '#c9a892'
let s:muted   = '#7a6a5e'
let s:faint   = '#4a3f3a'
let s:ember   = '#d6492b'
let s:brick   = '#b33219'
let s:mahog   = '#481510'
let s:gold    = '#e8a04f'
let s:amber   = '#d9853f'
let s:olive   = '#8a9560'
let s:teal    = '#4f9aa5'
let s:sky     = '#6bb3bd'
let s:rose    = '#b9576a'

" --- editor ---
call s:hi('Normal',       s:text,  'NONE',    'NONE')
call s:hi('NonText',      s:faint, 'NONE',    'NONE')
call s:hi('EndOfBuffer',  s:bg,    'NONE',    'NONE')
call s:hi('LineNr',       s:faint, 'NONE',    'NONE')
call s:hi('CursorLineNr', s:ember, 'NONE',    'bold')
call s:hi('CursorLine',   'NONE',  s:surface, 'NONE')
call s:hi('ColorColumn',  'NONE',  s:surface, 'NONE')
call s:hi('SignColumn',   s:muted, 'NONE',    'NONE')
call s:hi('VertSplit',    s:surface, 'NONE',  'NONE')
call s:hi('Visual',       'NONE',  s:mahog,   'NONE')
call s:hi('Search',       s:bg,    s:amber,   'NONE')
call s:hi('IncSearch',    s:bg,    s:ember,   'NONE')
call s:hi('CurSearch',    s:bg,    s:ember,   'NONE')
call s:hi('MatchParen',   s:gold,  s:surface, 'bold')
call s:hi('StatusLine',   s:text,  s:surface, 'NONE')
call s:hi('StatusLineNC', s:muted, s:surface, 'NONE')
call s:hi('StatusLineTerm',   s:text,  s:surface, 'NONE')
call s:hi('StatusLineTermNC', s:muted, s:surface, 'NONE')
call s:hi('User1',        s:bg,    s:brick,   'bold')
call s:hi('User2',        s:sand,  s:surface, 'NONE')
call s:hi('Pmenu',        s:text,  s:surface, 'NONE')
call s:hi('PmenuSel',     s:text,  s:brick,   'NONE')
call s:hi('WildMenu',     s:text,  s:brick,   'NONE')
call s:hi('Folded',       s:muted, s:surface, 'NONE')
call s:hi('Directory',    s:sky,   'NONE',    'NONE')
call s:hi('Title',        s:ember, 'NONE',    'bold')
call s:hi('ErrorMsg',     s:ember, 'NONE',    'bold')
call s:hi('WarningMsg',   s:gold,  'NONE',    'NONE')
call s:hi('MoreMsg',      s:olive, 'NONE',    'NONE')
call s:hi('ModeMsg',      s:sand,  'NONE',    'NONE')
call s:hi('Question',     s:olive, 'NONE',    'NONE')

" --- syntax ---
call s:hi('Comment',    s:muted, 'NONE', 'italic')
call s:hi('String',     s:gold,  'NONE', 'NONE')
call s:hi('Number',     s:amber, 'NONE', 'NONE')
call s:hi('Float',      s:amber, 'NONE', 'NONE')
call s:hi('Boolean',    s:rose,  'NONE', 'NONE')
call s:hi('Constant',   s:rose,  'NONE', 'NONE')
call s:hi('Identifier', s:text,  'NONE', 'NONE')
call s:hi('Function',   s:sky,   'NONE', 'NONE')
call s:hi('Statement',  s:ember, 'NONE', 'NONE')
call s:hi('Keyword',    s:ember, 'NONE', 'NONE')
call s:hi('Operator',   s:sand,  'NONE', 'NONE')
call s:hi('PreProc',    s:rose,  'NONE', 'NONE')
call s:hi('Type',       s:teal,  'NONE', 'NONE')
call s:hi('Special',    s:olive, 'NONE', 'NONE')
call s:hi('Underlined', s:sky,   'NONE', 'underline')
call s:hi('Error',      s:text,  s:brick, 'NONE')
call s:hi('Todo',       s:bg,    s:gold, 'bold')

" Colours for the run pane (:terminal), same 16 as Ghostty.
let g:terminal_ansi_colors = [
      \ '#030602', '#b33219', '#6e7a52', '#d9853f', '#3e7a85', '#9c3b4a', '#4f9aa5', '#e8d5c2',
      \ '#38252a', '#d6492b', '#8a9560', '#e8a04f', '#4f93a0', '#b9576a', '#6bb3bd', '#f2e6d8']
call s:hi('Terminal', s:text, 'NONE', 'NONE')
