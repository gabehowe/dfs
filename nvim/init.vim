autocmd TextYankPost * silent! lua vim.hl.on_yank {higroup='Visual', timeout=300}
let g:UltiSnipsExpandTrigger = '<Tab>'
let g:python3_host_prog= "/home/gabri/.config/nvim/py/venv/bin/python3"
lua require('config')
set ignorecase smartcase
set title
let $LD_LIBRARY_PATH = system('nix eval --raw nixpkgs#stdenv.cc.cc.lib') . '/lib'

function! TabComplete()
	if exists("UltiSnips#CanExpandSnippet")
	  if UltiSnips#CanExpandSnippet()
		  echom "ha!"
		return UltiSnips#ExpandSnippet()
	  elseif UltiSnips#CanJumpForwards()
		  echom "drr"
		return UltiSnips#JumpForwards()
	  endif
	endif
	if pumvisible()
	    echom "grr"
	  return "\<C-n>"
	else
	    echom "tr"
	  return "\<Tab>"
	endif
endfunction

inoremap <silent><expr> <Tab> TabComplete()
nnoremap <leader>gw <Cmd>lua vim.lsp.buf.format()<CR>
let g:load_doxygen_syntax=1
colorscheme papercolorslim
set signcolumn=no
