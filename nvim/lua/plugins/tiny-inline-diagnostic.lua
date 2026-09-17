return {
    "rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy",
    priority = 1500,
    config = function()
        require('tiny-inline-diagnostic').setup({
          options = {
            throttle = 50, -- Slower throttle for Rust
            softwrap = 20,
            multiple_diag_under_cursor = true,
			enable_on_insert=true,
			show_all_diags_on_cursorline=true,
			multilines=true,
            show_source = false,
			 overflow = {
            -- Overflow handling mode:
            -- "wrap" - Split long messages into multiple lines
            -- "none" - Do not truncate messages
            -- "oneline" - Keep the message on a single line, even if it's long
            mode = "wrap",

            -- Trigger wrapping this many characters earlier when mode == "wrap"
            -- Increase if the last few characters of wrapped diagnostics are obscured
            padding = 0,
        },
				virt_texts= {
					priority=4096
				}
          }
})
        vim.diagnostic.config({ virtual_text = false }) -- Disable default virtual text
    end
}
