setlocal spell
" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method:
let g:vimtex_view_method = 'zathura'
let g:latex_view_general_viewer = 'zathura'
highlight texCmdCQuestion ctermfg=127
highlight link texCNsectionArg texPartArgTitle
if empty(v:servername) && exists('*remote_startserver')
        call remote_startserver('VIM')
endif
let b:surround_{char2nr("c")} = "\\\1command: \1{\r}"

let g:vimtex_toggle_fractions = {
        \ 'INLINE': 'dfrac',
        \ 'dfrac': 'frac',
		\ 'frac': 'INLINE'
        \}
let g:vimtex_compiler_method = 'latexmk'
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

" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol "\".
let g:vimtex_syntax_custom_cmds = [{'name':'nsection', 'cmdre':'n(sub)*section\**'}, 
			\ {'name': 'question'},
			\ {'name': 'term', 'argstyle': 'bold'},
			\ {'name': 'jterm', 'argstyle': 'bold'}]
let g:vimtex_fold_enabled=0
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
call vimtex#imaps#add_map({
        \ 'lhs' : 'v',
        \ 'rhs' : 'vimtex#imaps#style_math("vb")',
        \ 'expr' : 1,
        \ 'leader' : '#',
        \ 'wrapper' : 'vimtex#imaps#wrap_math'
        \})

call vimtex#imaps#add_map({
        \ 'lhs' : 'h',
        \ 'rhs' : 'vimtex#imaps#style_math("hat")',
        \ 'expr' : 1,
        \ 'leader' : '#',
        \ 'wrapper' : 'vimtex#imaps#wrap_math'
        \})

let g:ycm_semantic_triggers = {
    \ 'tex' : g:vimtex#re#youcompleteme
    \}

let g:ale_tex_chktex_options = "-I -n1 -n3 -n8 -n36 -n2"
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 1

let g:UltiSnipsSnippetDirectories = [$HOME."/.config/vim/snips"]
" add latex delimiters.
"let b:delimitMate_quotes = "\" ' $"
