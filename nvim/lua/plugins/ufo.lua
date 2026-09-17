local matching_delimiter = function(delim)
    -- 1.1. Table of matching pairs
    local delims = {
        ["("] = ")",
        [")"] = "(",
        ["["] = "]",
        ["]"] = "[",
        ["{"] = "}",
        ["}"] = "{",
        ["<"] = ">",
        [">"] = "<",
        ['"'] = '"',
        ["'"] = "'"
    }
	local v = delims[delim]
	if (v == nil) then
	v = " "
	end
	return v
end
local virttexthandler = function(virtText, lnum, endLnum, width, truncate) 
	local newVirtText = {}
    local suffix = '...'
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
	local open_delim = newVirtText[#newVirtText]
	local next_delim = matching_delimiter(open_delim[1])
	table.insert(newVirtText, {"", "None"})
    table.insert(newVirtText, {suffix, 'UfoFoldedEllipsis'})
	table.insert(newVirtText, {next_delim, open_delim[2]})
    return newVirtText
end


return {
	enabled = false,
	'kevinhwang91/nvim-ufo',
	dependencies= {
		'kevinhwang91/promise-async'
	},
	config = function() 
		 require('ufo').setup({
			provider_selector = function(bufnr, filetype, buftype)
				return {'treesitter', 'indent'}
			end,
			fold_virt_text_handler=virttexthandler
		})
		vim.api.nvim_set_hl(0, "UfoFoldedBg", {bg="#333000"})
	end
}

