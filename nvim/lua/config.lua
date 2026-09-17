-- ~/.config/nvim/init.lua
-- Neovim migration maintaining your Vim functionality

-- Install lazy.nvim plugin manager


-- Basic vim settings (matching your .vimrc) - these go BEFORE the plugin setup
-- vim.opt.background = "dark"
vim.opt.linebreak = true
vim.opt.showbreak = "+"
vim.opt.display = "lastline"
vim.opt.autoread = true
vim.opt.history = 1000
vim.opt.formatoptions:append("j")
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.scrolloff = 1
vim.opt.sidescrolloff = 5
vim.opt.termguicolors=true
vim.opt.ttyfast = true
vim.o.signcolumn="yes"
vim.opt.clipboard = ""

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Key mappings (matching your .vimrc) - these go BEFORE the plugin setup
vim.keymap.set("n", "<Esc><Esc>", ":noh<CR>", { desc = "Clear highlighting" })
vim.keymap.set("n", "j", "gj", { desc = "Move down display line" })
vim.keymap.set("n", "k", "gk", { desc = "Move up display line" })
vim.keymap.set("n", "gj", "j", { desc = "Move down logical line" })
vim.keymap.set("n", "gk", "k", { desc = "Move up logical line" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Move up logical line" })
vim.keymap.set("n", "<leader>nt", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "gu", "<cmd>Telescope lsp_references<CR>")
vim.keymap.set("n", "<C-/>", "<cmd>Telescope live_grep<CR>")

-- Cursor settings for insert mode (nvim handles this better)
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
-- ALL PLUGINS MUST GO INSIDE require("lazy").setup({})
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
      vim.lsp.buf.hover()
	end
})


vim.opt.updatetime = 600
vim.cmd("syntax enable")

-- Conceal highlighting (from your config)
vim.cmd("hi Conceal ctermfg=109 ctermbg=236")

-- Python highlighting
vim.g.python_highlight_all = 1

-- Quickscope disable (you had this disabled)
vim.g.qs_enable = 0
-- force rounded all the time.
local orig_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"  -- options: "single", "double", "rounded", "solid", "shadow"
  return orig_open_floating_preview(contents, syntax, opts, ...)
end
-- Set up autocommands for file types
-- vim.api.nvim_create_augroup("filetypedetect", { clear = true })
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  group = "filetypedetect",
  pattern = "*.msnippets",
  command = "set syntax=snippets",
})

-- gproj lua



vim.api.nvim_set_hl(0, "@comment.documentation", {fg=vim.g.terminal_color_2})
vim.api.nvim_set_hl(0, "@comment.documentation.java", {fg=vim.g.terminal_color_2})
vim.api.nvim_set_hl(0, "@comment.documentation.rust", {fg=vim.g.terminal_color_2})

vim.api.nvim_set_hl(0, "RainbowDelimiterRed"   , {fg=vim.g.terminal_color_15})
vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", {fg=vim.g.terminal_color_10})
vim.api.nvim_set_hl(0, "RainbowDelimiterBlue"  , {fg=vim.g.terminal_color_14})
vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", {fg=vim.g.terminal_color_12})
vim.api.nvim_set_hl(0, "RainbowDelimiterGreen" , {fg=vim.g.terminal_color_10})
vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", {fg=vim.g.terminal_color_11})
vim.api.nvim_set_hl(0, "RainbowDelimiterCyan"  , {fg=vim.g.terminal_color_13})
vim.api.nvim_set_hl(0, "IblIndent"  , {fg="#2c2c2c"})


require('config.lazy')


vim.api.nvim_set_hl(0, "Folded", {bg="none"})
vim.api.nvim_set_hl(0, "UfoFoldedEllipsis", {fg=vim.g.terminal_color_1, bg="#2c2c2c"})
vim.diagnostic.config({update_in_insert = true})
-- folding
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 1
vim.opt.foldnestmax = 4
vim.opt.foldtext = ""

