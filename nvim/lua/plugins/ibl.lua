return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
	enabled = true;
    ---@module "ibl"
    ---@type ibl.config,
	dependencies = {"HiPhish/rainbow-delimiters.nvim"},
    opts = {},
	config = function()
		require("rainbow-delimiters.setup")
		local highlight = {
		  "RainbowDelimiterRed"
		, "RainbowDelimiterYellow"
		, "RainbowDelimiterBlue"
		, "RainbowDelimiterOrange"
		, "RainbowDelimiterGreen"
		, "RainbowDelimiterViolet"
		, "RainbowDelimiterCyan"
			}
		local hooks = require "ibl.hooks"
		require("ibl").setup{scope = {highlight = highlight, show_start=false, show_end=false} }
		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
		vim.g.rainbow_delimiters = {highlight = highlight}
		--
	end
}
