return {
  "nvim-tree/nvim-tree.lua",
  cmd = {"NvimTreeOpen", "NvimTreeToggle"},
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {}
  end,
}
