return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  lazy = false, -- This plugin is already lazy
  config = function()
  end,
  opts = {
		server = {default_settings = {
			['rust-analyzer'] = {
				checkOnSave = {
					enabled = true,
					command = 'clippy'
				},
				procMacro = { enable = true },
				completion = { postfix = { enable = true }},
				inlayHints = {
					enable = true,
					showParameterNames = true
				},
			}
		}
	}
}
}

