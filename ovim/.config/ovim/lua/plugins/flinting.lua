local M = {
	"stevearc/conform.nvim",
	keys = {
		{
			"<leader>lf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			desc = "Format Buffer",
		},
	},
}

function M.config()
	local conform = require("conform")

	conform.setup({
		default_format_opts = {
			timeout_ms = 3000,
			async = false,
			quiet = false,
			lsp_format = "fallback",
		},
		formatters_by_ft = {
			-- Markdown formatting
			markdown = { "prettierd", "prettier", stop_after_first = true },

			-- Optional: if you also write other formats in your notes
			-- json = { "prettierd", "prettier", stop_after_first = true },
			-- yaml = { "prettierd", "prettier", stop_after_first = true },
		},
	})
end

return M
