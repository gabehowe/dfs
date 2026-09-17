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
-- 		vim.api.nvim_create_autocmd('LspAttach', {
-- 			group = vim.api.nvim_create_augroup('UserLspConfig', {}),
-- 			callback = function(ev)
-- 				local client = vim.lsp.get_client_by_id(ev.data.client_id)
-- 				lsp_highlight_document(client)
-- 			end,
-- 		})
		servers = {
			["*"] = { capabilities = { workspace = { fileOperations = {
				didRename = true,
				willRename = true,
			}}}},
			clangd = {
				keys= { { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" } },
				cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu",
				"--completion-style=detailed", "--function-arg-placeholders", "--fallback-style=gcc", "--query-driver=/usr/bin/clang++,/usr/bin/g++"
			},
			settings = { InlayHints = {
				Enabled = true,
				ParameterNames = true,
				DeducedTypes = true
			}}},
							tinymist = { settings = { exportPdf = 'onType' }}
						}
				},
			config = function () end
		}
