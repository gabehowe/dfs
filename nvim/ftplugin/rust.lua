
function james(input) 
	vim.print(input[1]['result']['expansion'])
end

vim.api.nvim_create_user_command(
	'ExpandMacro', 
	function() 
		vim.lsp.buf_request_all(0, "rust-analyzer/expandMacro", vim.lsp.util.make_position_params(), james)
end,
	{desc="expand macro under cursor"})
