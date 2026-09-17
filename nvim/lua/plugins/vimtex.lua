return {{
    "lervag/vimtex",
    ft = "tex",
    config = function()
      -- Configure vimtex
	  vim.g.tex_flavor = "latex"
      vim.g.vimtex_view_method = "zathura"  -- or "zathura", "evince", etc.
	  vim.g.vimtex_view_automatic = 1
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_view_general_viewer = "okular"
      vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"
      
      -- Disable overfull/underfull warnings
      vim.g.vimtex_quickfix_ignore_filters = {
        "Underfull",
      }
-- TODO: fix vimtex
      
      -- Custom keymaps for vimtex
      vim.keymap.set("n", "<leader>lc", "<cmd>VimtexCompile<cr>", {desc = "VimTeX Compile"})
      vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<cr>", {desc = "VimTeX View"})
    end
 },
 {
	 "saghen/blink.cmp",
	 dependencies = {
		"micangl/cmp-vimtex",
		dependencies = {
			{
				"saghen/blink.compat",
				version = "*",
				lazy = true,
				opts = {}
			}
		},
	 },
		opts = { sources = {
			default = {"vimtex"},
			providers = { vimtex = {
				name = "vimtex",
				module = "blink.compat.source",
				score_offset = 100
			}
			}

		}
 }
 }
 }

