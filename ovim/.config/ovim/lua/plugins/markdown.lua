local M = {
	"MeanderingProgrammer/render-markdown.nvim",
}

function M.config()
	require("render-markdown").setup({
		completions = { lsp = { enabled = true } },
	})
end

return M
