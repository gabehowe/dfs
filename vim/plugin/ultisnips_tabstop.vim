vim9script
# ultisnips_tabstop_hl.vim
# Highlights the character immediately after the current UltiSnips tabstop
# using matchaddpos(). Requires Vim 8+ or Neovim with Python3 + UltiSnips.
#
# Installation: place in ~/.vim/plugin/ (Vim) or ~/.config/nvim/plugin/ (Neovim)
# Optional config (set before plugin loads, or in vimrc):
#   let g:ultisnips_tabstop_hl_group = 'WarningMsg'  " default: 'UltiSnipsTabstopHL'
#
# ── guard ──────────────────────────────────────────────────────────────────────
if exists('g:loaded_ultisnips_tabstop_hl') 
  finish 
endif
g:loaded_ultisnips_tabstop_hl = 1

if !has('python3')
  echohl WarningMsg
  echom '[ultisnips_tabstop_hl] python3 support required – plugin not loaded.'
  echohl None
  finish
endif

# ── highlight group ────────────────────────────────────────────────────────────
def DefineHL() 
  if !hlexists('UltiSnipsTabstopHL0') || synIDattr(hlID('UltiSnipsTabstopHL'), 'fg') == ''
    for i in range(8)
      execute 'highlight UltiSnipsTabstopHL' .. string(i) .. ' ctermbg=' .. string(57 + 12 * i)
    endfor
  endif
enddef

DefineHL()
# Re-apply after colorscheme changes
augroup UltiSnipsTabstopHL_colors
  autocmd!
  autocmd ColorScheme * DefineHL()
augroup END

# ── state ──────────────────────────────────────────────────────────────────────
# match id returned by matchadd(); -1 means no active match
var match_id: list<number> = repeat([-1], 8)

# ── core Python helper ─────────────────────────────────────────────────────────
# Returns [line, col] (1-based) of the character right after the current
# tabstop end, or an empty list if unavailable.
python3 << PYEOF
import vim

def _ultisnips_tabstop_hl_pos() -> list:
    """
    Walk the UltiSnips snippet stack and return (1-based line, 1-based col)
    of the character immediately after the *current* tabstop's end position.
    Returns None if not inside a snippet or position is out of range.
    """
    try:
        from UltiSnips import UltiSnips_Manager as mgr
        # Access the active snippet (top of the stack)
        stack = mgr._active_snippets
        if not stack:
            return None
        snippet = stack[-1]

        # Current tabstop index
        tabs = [(-1, snippet._get_tabstop(snippet,0))]
        i = snippet._cts
        while (nt := snippet._get_next_tab(i)) is not None:
          tabs.append(nt)
          i += 1
        ts = [i[1] for i in tabs]
        #zero = ts.pop(0) if 0 in ts.keys() else None
        ts = ts[:min(8, len(ts))]

        # ts.end is a Position(line, col) – both 0-based
        #end_line, end_col = ts.end.line, ts.end.col
        ret = [[i.end.line+1, i.end.col, 1] for i in ts if i.end.col]
        # The character *after* the tabstop end on the same line
        #buf = vim.current.buffer
        #line_text = buf[line_idx]
        # end_col is already just past the tabstop text; that *is* the next char
        #if end_col >= len(line_text):
        #    return None

        return ret   # both 1-based for Vim
    except Exception as e:
        return str(e)
PYEOF

# ── VimScript wrappers ─────────────────────────────────────────────────────────
def GetAfterPos(): list<list<number>>
  # Returns [[line, col]] (1-based) or [] on failure
  python3 _result = _ultisnips_tabstop_hl_pos()
  var pos = py3eval('_result if _result else []')
  if type(pos) == v:t_string
    echoerr pos
  endif
  return pos
enddef


def ClearMatch()
  if match_id[0] != -1
      for i in range(8)
      try
        matchdelete(match_id[i])
      catch
      endtry
      match_id[i] = -1
      endfor
  endif
enddef

def ClearState()
  augroup UltiSnipsTabstopUpdateOnType | autocmd! | augroup END
enddef

def ApplyMatch()
  ClearMatch()
  var pos = GetAfterPos()
  if empty(pos)
    return
  endif
  var hl_group = get(g:, 'ultisnips_tabstop_hl_group', 'UltiSnipsTabstopHL')
  # matchaddpos takes a list of positions; each position is [line, col, len]
  for i in range(len(pos))
    match_id[i] = matchaddpos('UltiSnipsTabstopHL' .. string(i), [pos[i]])
  endfor
  #match_id = matchaddpos(hl_group, pos)
enddef


export def JumpForward(): string
  # Let UltiSnips do its jump, then update the highlight one tick later so the
  # cursor and snippet state have both settled.
  if UltiSnips#JumpForwards() == ""
    timer_start(0, (_) => ApplyMatch())
  endif
  return ''
enddef
 
export def JumpBackward(): string
  if UltiSnips#JumpBackwards() == ""
    timer_start(0, (_) => ApplyMatch())
  endif
  return ''
enddef

def SetupMaps()
  #let g:UltiSnipsJumpForwardTrigger = "b"
  var fwd = get(g:, 'UltiSnipsJumpForwardTrigger',  '<Tab>')
  var bwd = get(g:, 'UltiSnipsJumpBackwardTrigger', '<S-Tab>')
 
  # We only intercept in insert mode while a snippet is active.
  # Using <expr> lets us call the function and swallow the key in one step.
  execute 'inoremap <silent><expr><buffer> ' .. fwd
         .. ' UltiSnips#CanJumpForwards() ? "<ScriptCmd>JumpForward()<CR>" : "\' .. fwd .. '"'
 
  execute 'inoremap <silent><expr><buffer> ' .. bwd
         .. ' UltiSnips#CanJumpBackwards()'
         .. ' ? "<ScriptCmd>JumpBackward()<CR>" : "\' .. bwd .. '"'
  augroup UltiSnipsTabstopUpdateOnType
    autocmd TextChanged,TextChangedI * ApplyMatch()
  augroup END
enddef
# ── autocommands ───────────────────────────────────────────────────────────────
var Lambd = (_) => {
  ApplyMatch()
  SetupMaps()
}
augroup UltiSnipsTabstopHL
  autocmd!

  # Fired just before jumping to the next tabstop – the jump has not happened
  # yet, so we schedule the highlight update for after the jump completes.
  autocmd User UltiSnipsEnterFirstSnippet  timer_start(1, Lambd) 

  # Clean up when the snippet session ends
  autocmd User UltiSnipsExitLastSnippet    ClearMatch() | ClearState()

  # Also clean up if the user leaves insert mode without finishing the snippet
  #autocmd InsertLeave * ClearMatch() | ClearState()
augroup END



command! UltiSnipsTabstopHLDisable ClearMatch()
      \| augroup UltiSnipsTabstopHL | autocmd! | augroup END
