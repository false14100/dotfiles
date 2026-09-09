local M = {
	"folke/trouble.nvim",
	opts = {},
	cmd = "Trouble",
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
		{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
		{ "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace Diagnostics" },
		{ "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Document Diagnostics" },
		{ "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
		{ "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
		{ "<leader>xr", "<cmd>Trouble lsp toggle<cr>", desc = "LSP References" },
	},
}

return M
