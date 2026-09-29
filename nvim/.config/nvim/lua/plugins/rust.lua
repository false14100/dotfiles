local M = {
	"mrcjkb/rustaceanvim",
	version = "^9",
	lazy = false, -- rustaceanvim manages its own ft-based lazy loading internally
	ft = { "rust" },
	dependencies = {
		"saecki/crates.nvim",
	},
}

function M.config()
	-- crates.nvim needs its own setup call
	require("crates").setup({
		completion = {},
	})

	vim.g.rustaceanvim = {
		server = {
			on_attach = function(client, bufnr)
				local opts = { silent = true, buffer = bufnr }
				vim.keymap.set("n", "<leader>ce", function()
					vim.cmd.RustLsp("expandMacro")
				end, opts)
				vim.keymap.set("n", "<leader>ca", function()
					vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
					-- or vim.lsp.buf.codeAction() if you don't want grouping.
				end, { silent = true, buffer = bufnr })
				vim.keymap.set(
					"n",
					"K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
					function()
						vim.cmd.RustLsp({ "hover", "actions" })
					end,
					{ silent = true, buffer = bufnr }
				)
			end,
			default_settings = {
				["rust-analyzer"] = {
					cargo = {
						allFeatures = true,
						buildScripts = {
							enable = true,
						},
					},
					imports = {
						granularity = {
							group = "module",
						},
						prefix = "self",
					},
					procMacro = {
						enable = true,
					},
				},
			},
		},
	}
end

return M
