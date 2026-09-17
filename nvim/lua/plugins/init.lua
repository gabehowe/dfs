return
{
{
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      require("flash").setup({
        modes = {
          search = { enabled = true, max_length = 4 },
          char = { enabled = true },
        }
      })
      -- Your easymotion mapping: <leader>s
      vim.keymap.set({"n", "x", "o"}, "<leader>s", function() require("flash").jump() end, {desc = "Flash Jump"})
      vim.keymap.set({"n", "x", "o"}, "<leader>S", function() require("flash").treesitter() end, {desc = "Flash Treesitter"})
      vim.keymap.set("o", "r", function() require("flash").remote() end, {desc = "Remote Flash"})
      vim.keymap.set({"o", "x"}, "R", function() require("flash").treesitter_search() end, {desc = "Treesitter Search"})
      vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, {desc = "Toggle Flash Search"})
    end
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { 
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim", -- Optional: faster sorting
    },
    config = function()
      require("telescope").setup({
        defaults = {
          -- Better layout
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            width = 0.87,
            height = 0.80,
          },
          -- Case insensitive search
          file_ignore_patterns = { "%.git/", "node_modules/", "%.pyc" },
        },
        pickers = {
          oldfiles = {
            prompt_title = "Recent Files (MRU)",
          },
        },
      })
      
      -- Essential telescope keybindings
      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {desc = "Find Files"})
      vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", {desc = "Recent Files (MRU)"})
      vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", {desc = "Live Grep"})
      vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", {desc = "Buffers"})
      vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", {desc = "Help Tags"})
      vim.keymap.set("n", "<leader>fc", "<cmd>Telescope commands<cr>", {desc = "Commands"})
      vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", {desc = "Keymaps"})
    end
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
			priority=50, -- Load before ibl
    config = function()
      require("rainbow-delimiters.setup")
    end
  },

{
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
vim.keymap.set("n", "<C-g>s", "<Plug>(nvim-surround-insert)", {})
vim.keymap.set("n", "<C-g>S", "<Plug>(nvim-surround-insert_line)", {})
vim.keymap.set("n", "ys", "<Plug>(nvim-surround-normal)", {})
vim.keymap.set("n", "yss", "<Plug>(nvim-surround-normal_cur)", {})
vim.keymap.set("n", "yS", "<Plug>(nvim-surround-normal_line)", {})
vim.keymap.set("n", "ySS", "<Plug>(nvim-surround-normal_cur_line)", {})
vim.keymap.set("n", "S", "<Plug>(nvim-surround-visual)", {})
vim.keymap.set("n", "gS", "<Plug>(nvim-surround-visual_line)", {})
vim.keymap.set("n", "ds", "<Plug>(nvim-surround-delete)", {})
vim.keymap.set("n", "cs", "<Plug>(nvim-surround-change)", {})
vim.keymap.set("n", "cS", "<Plug>(nvim-surround-change_line)", {})
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
		surrounds = {
					["c"] = {
						add = function()
							local config = require("nvim-surround.config")
							local result = config.get_input("command:")
							if result then
								return {{"\\" ..result .. "{"}, {"}"}}
							end
							end
					},
					["e"] = {
						add = function()
							local config = require("nvim-surround.config")
							local result = config.get_input("environment:")
							if result then
								return {{"\\begin{" ..result .. "}"}, {"\\end{".. result .."}"}}
							end
							end
					}
				},
      })
    end,
  },
{
    "SirVer/ultisnips",
	ft="tex",
    dependencies = { "honza/vim-snippets" },
    init = function()
      vim.g.UltiSnipsExpandTrigger = ";"  -- Your custom trigger TODO: make this work as intended.
      vim.g.UltiSnipsJumpForwardTrigger = "<Tab>"
      -- vim.g.UltiSnipsJumpBackwardTrigger = "<C-B>"  -- Your custom backward trigger
      vim.g.UltiSnipsSnippetDirectories = { vim.fn.expand("$HOME/.vim/snips") }
      vim.g.UltiSnipsEditSplit = "vertical"
    end
  },
{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
	enabled = true;
	opts_extend = {"ensure_installed"},
	opts = {
        ensure_installed = {
          "lua", "python", "rust", "javascript", "typescript", "html", "css",
          "bash", "c", "cpp", "go", "java", "json", "yaml", "markdown"
        },
        highlight = { enable = true, additional_vim_regex_highlighting = {"latex", "tex"}},
        indent = { enable = true },
      }
},
{
    "jpalardy/vim-slime",
    config = function()
      vim.g.slime_target = "tmux"  -- Using nvim's built-in terminal (better than vimterminal)
      vim.g.slime_python_ipython = 1  -- Your ipython setting
      vim.keymap.set("n", "<leader>sp", "<Plug>SlimeParagraphSend", {desc = "Slime Send Paragraph"})
    end
  },

{
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()

	local function gproj()
	  local f = io.open(".gproj", "r")
	  if not f then return "" end
	  for line in f:lines() do
		local name = line:match("title:%s*'?([^']+)'?")
		if name and name ~= "" then
		  f:close()
		  return name
		end
	  end
	  f:close()
	  return ""
	end
	local function vimtex_wordcount()
	  if vim.bo.filetype ~= "tex" then
		return ""
	  end

	  local wc = vim.fn["vimtex#misc#wordcount"]()
	  return ("\u{eb7e} " .. wc) or ""
	end	
      require("lualine").setup({
        options = {
          theme = "PaperColor", -- Match your colorscheme
          globalstatus = true,
        },
        sections = {
          lualine_a = {"mode"},
          lualine_b = {"branch", "diff", "diagnostics"},
		  lualine_c = { gproj, "filename" },
          lualine_x = {"encoding", "fileformat", "filetype"},
          lualine_y = {"progress", vimtex_wordcount},
          lualine_z = {"location"}
        },
        tabline = {
          lualine_a = {"buffers"},
          lualine_z = {"tabs"}
        }
      })
    end,
  },
}
