set spell
set shiftwidth=2
set tabstop=2
" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method:
let g:vimtex_view_method = 'zathura'
let g:latex_view_general_viewer = 'zathura'
if empty(v:servername) && exists('*remote_startserver')
        call remote_startserver('VIM')
endif
" Or with a generic interface:
" let g:vimtex_view_general_viewer = 'okular'
" let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_toggle_fractions = {
        \ 'INLINE': 'dfrac',
        \ 'dfrac': 'frac',
		\ 'frac': 'INLINE'
        \}
let g:vimtex_env_toggle_math_map = {
          \ '$': 'equation',
          \ 'equation': 'align',
          \ 'align': 'gather',
          \ 'gather': '$',
          \}
let g:vimtex_compiler_latexmk = {
        \ 'out_dir': './pdfs',
        \ 'aux_dir': './.aux',
        \ 'options': [
         \   '-pdf',
         \   '-shell-escape',
         \   '-verbose',
         \   '-file-line-error',
         \   '-synctex=1',
         \   '-interaction=nonstopmode',
         \ ],
        \}
"let g:vimtex_compiler_tectonic = {
        "\ 'out_dir': './pdfs',
        "\ 'aux_dir': './.aux',
        "\ 'options': [
         "\   '-X watch',
         "\   '--pdf',
         "\   '--shell-escape',
         "\   '--verbose',
         "\   '--file-line-error',
         "\   '--synctex=1',
         "\   '',
         "\   '--keep-logs'
         "\ ],
        "\}

let b:surround_{char2nr("c")} = "\\\1command: \1{\r}"
" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see ":help vimtex-compiler".
"let g:vimtex_compiler_method = 'tectonic'

" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol "\".
let g:vimtex_syntax_custom_cmds = [{'name':'nsection', 'cmdre':'n(sub)*section\**'}, 
			\ {'name': 'question'},
			\ {'name': 'term', 'argstyle': 'bold'},
			\ {'name': 'jterm', 'argstyle': 'bold'}]
let g:vimtex_fold_enabled=1
highlight link texCmdCQuestion RainbowBlue
highlight link texCNsectionArg texPartArgTitle
let g:vimtex_fold_types_defaults = {
          \ 'preamble' : {},
          \ 'items' : {},
          \ 'comment_pkg' : {},
          \ 'comments' : {'enabled' : 0},
          \ 'envs' : {
          \   'blacklist' : [],
          \   'whitelist' : [],
          \ },
          \ 'env_options' : {},
          \ 'markers' : {},
          \ 'sections' : {
          \   'parse_levels' : 0,
          \   'sections' : [
          \     '%(add)?part',
          \     '%(chapter|addchap)',
          \     '%(section|addsec)',
          \     'subsection',
          \     'subsubsection',
		  \ 	'question'
          \   ],
          \   'parts' : [
          \     'appendix',
          \     'frontmatter',
          \     'mainmatter',
          \     'backmatter',
          \   ],
          \ },
          \ 'cmd_single' : {
          \   'cmds' : [
          \     'hypersetup',
          \     'tikzset',
          \     'pgfplotstableread',
          \     'lstset',
          \   ],
          \ },
          \ 'cmd_single_opt' : {
          \   'cmds' : [
          \     'usepackage',
          \     'includepdf',
          \   ],
          \ },
          \ 'cmd_multi' : {
          \   'cmds' : [
          \     '%(re)?new%(command|environment)',
          \     'providecommand',
          \     'presetkeys',
          \     'Declare%(Multi|Auto)?CiteCommand',
          \     'Declare%(Index)?%(Field|List|Name)%(Format|Alias)',
          \   ],
          \ },
          \ 'cmd_addplot' : {
          \   'cmds' : [
          \     'addplot[+3]?',
          \   ],
          \ },
          \}
