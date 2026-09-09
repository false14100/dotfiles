local M = {
	"laytan/tailwind-sorter.nvim",
	version = "*",
	build = "cd formatter && npm ci && npm run build",
	ft = { "html", "css", "scss", "javascriptreact", "typescriptreact", "svelte", "vue" },
	keys = {
		{
			"<leader>ts",
			function()
				require("tailwind-sorter").sort()
			end,
			desc = "Tailwind: Sort classes (buffer)",
		},
		{
			"<leader>tS",
			function()
				require("tailwind-sorter").sort_selected()
			end,
			mode = { "v" },
			desc = "Tailwind: Sort classes (selection)",
		},
	},
}

function M.config()
	require("tailwind-sorter").setup({
		on_save_enabled = false,
		on_save_pattern = { "*.html", "*.jsx", "*.tsx", "*.css", "*.scss", "*.svelte", "*.vue" },
	})
end

return M
