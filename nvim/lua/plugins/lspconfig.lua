local function lsp_highlight_document(client)
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
		vim.api.nvim_create_autocmd("CursorHold", {
			group = "lsp_document_highlight",
			buffer = 0,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = "lsp_document_highlight",
			buffer = 0,
			callback = vim.lsp.buf.clear_references,
		})
	end
end

return {
	"neovim/nvim-lspconfig",
	inlay_hints = { enabled = true },
	-- opts_extend = { "servers.*.keys" },
	opts = {
		servers = {
			["*"] = {
				capabilities = {
					workspace = {
						fileOperations = {
							didRename = true,
							willRename = true,
						}
					}
				}
			},
			clangd = {
				keys = { { "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" } },
				cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu",
					"--completion-style=detailed", "--function-arg-placeholders=1", "--fallback-style=GNU",
					"--query-driver=/nix/store/*/bin/*,/run/current-system/sw/bin/*" },
			},
			tinymist = { settings = { exportPdf = 'onType' } }
		}
	},
	-- feed opts.servers to the native vim.lsp.config instead of the deprecated require("lspconfig")
	config = function(_, opts)
		vim.lsp.inlay_hint.enable(true)
		for name, server in pairs(opts.servers) do
			local keys = server.keys
			server.keys = nil
			vim.lsp.config(name, server)
			if keys then
				vim.api.nvim_create_autocmd("LspAttach", {
					callback = function(ev)
						local client = vim.lsp.get_client_by_id(ev.data.client_id)
						if client and client.name == name then
							for _, k in ipairs(keys) do
								vim.keymap.set("n", k[1], k[2], { buffer = ev.buf, desc = k.desc })
							end
						end
					end,
				})
			end
		end
	end
}
