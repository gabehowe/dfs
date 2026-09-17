return { 
	lazy=false,
	"mason-org/mason-lspconfig.nvim",
	opts= {automatic_enable = true}, 
	dependencies = {
	{ "mason-org/mason.nvim", opts = {PATH = "append"},  },
	"neovim/nvim-lspconfig" }
}
