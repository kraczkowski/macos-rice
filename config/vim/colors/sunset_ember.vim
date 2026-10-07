" Sunset Ember — dark teal + sunset reds. The colours are named in theme.ini.
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

let s:base    = '#{{base}}'
let s:surface = '#{{surface}}'
let s:text    = '#{{text}}'
let s:sand    = '#{{sand}}'
let s:muted   = '#{{muted}}'
let s:faint   = '#{{faint}}'
let s:flame   = '#{{flame}}'
let s:ember   = '#{{ember}}'
let s:mahogany = '#{{mahogany}}'
let s:gold    = '#{{gold}}'
let s:amber   = '#{{amber}}'
let s:olive   = '#{{olive}}'
let s:teal    = '#{{teal}}'
let s:sky     = '#{{sky}}'
let s:rose    = '#{{rose}}'

" --- editor ---
call s:hi('Normal',       s:text,  'NONE',    'NONE')
call s:hi('NonText',      s:faint, 'NONE',    'NONE')
call s:hi('EndOfBuffer',  s:base,  'NONE',    'NONE')
call s:hi('LineNr',       s:faint, 'NONE',    'NONE')
call s:hi('CursorLineNr', s:flame, 'NONE',    'bold')
call s:hi('CursorLine',   'NONE',  s:surface, 'NONE')
call s:hi('ColorColumn',  'NONE',  s:surface, 'NONE')
call s:hi('SignColumn',   s:muted, 'NONE',    'NONE')
call s:hi('VertSplit',    s:surface, 'NONE',  'NONE')
call s:hi('Visual',       'NONE',  s:mahogany, 'NONE')
call s:hi('Search',       s:base,  s:amber,   'NONE')
call s:hi('IncSearch',    s:base,  s:flame,   'NONE')
call s:hi('CurSearch',    s:base,  s:flame,   'NONE')
call s:hi('MatchParen',   s:gold,  s:surface, 'bold')
call s:hi('StatusLine',   s:text,  s:surface, 'NONE')
call s:hi('StatusLineNC', s:muted, s:surface, 'NONE')
call s:hi('StatusLineTerm',   s:text,  s:surface, 'NONE')
call s:hi('StatusLineTermNC', s:muted, s:surface, 'NONE')
call s:hi('User1',        s:base,  s:ember,   'bold')
call s:hi('User2',        s:sand,  s:surface, 'NONE')
call s:hi('Pmenu',        s:text,  s:surface, 'NONE')
call s:hi('PmenuSel',     s:text,  s:ember,   'NONE')
call s:hi('WildMenu',     s:text,  s:ember,   'NONE')
call s:hi('Folded',       s:muted, s:surface, 'NONE')
call s:hi('Directory',    s:sky,   'NONE',    'NONE')
call s:hi('Title',        s:flame, 'NONE',    'bold')
call s:hi('ErrorMsg',     s:flame, 'NONE',    'bold')
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
call s:hi('Statement',  s:flame, 'NONE', 'NONE')
call s:hi('Keyword',    s:flame, 'NONE', 'NONE')
call s:hi('Operator',   s:sand,  'NONE', 'NONE')
call s:hi('PreProc',    s:rose,  'NONE', 'NONE')
call s:hi('Type',       s:teal,  'NONE', 'NONE')
call s:hi('Special',    s:olive, 'NONE', 'NONE')
call s:hi('Underlined', s:sky,   'NONE', 'underline')
call s:hi('Error',      s:text,  s:ember, 'NONE')
call s:hi('Todo',       s:base,  s:gold, 'bold')

" Colours for the run pane (:terminal), same 16 as Ghostty.
let g:terminal_ansi_colors = [
      \ '#{{black}}', '#{{ember}}', '#{{moss}}', '#{{amber}}', '#{{ocean}}', '#{{berry}}', '#{{teal}}', '#{{text}}',
      \ '#{{plum}}', '#{{flame}}', '#{{olive}}', '#{{gold}}', '#{{steel}}', '#{{rose}}', '#{{sky}}', '#{{cream}}']
call s:hi('Terminal', s:text, 'NONE', 'NONE')
