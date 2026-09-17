return {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
        {"nvim-lua/plenary.nvim"},
    },
    event = "LspAttach",
    opts = {
		picker='buffer'
	},
	config = function()
		local tca = require("tiny-code-action")
		--       tca.setup({
		-- 	picker = { "buffer", }
		-- })
vim.keymap.set({ "n", "x" }, "<M-CR>", function()
	tca.code_action()
end, { noremap = true, silent = true })
	end,
}
