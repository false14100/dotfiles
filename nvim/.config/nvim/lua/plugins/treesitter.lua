local M = {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"folke/ts-comments.nvim",
		{
			"windwp/nvim-ts-autotag",
			ft = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			},
		},
		"nvim-treesitter/nvim-treesitter-context",
	},
	event = { "VeryLazy" },
}

function M.config()
	require("nvim-treesitter").setup({
		-- Add languages to be installed here that you want installed for treesitter
		ensure_installed = {
			"bash",
			"c",
			"c_sharp",
			"cpp",
			"diff",
			"html",
			"java",
			"javascript",
			"jsdoc",
			"json",
			"jsonc",
			"lua",
			"luadoc",
			"luap",
			"go",
			"markdown",
			"markdown_inline",
			"printf",
			"python",
			"query",
			"regex",
			"ruby",
			"sql",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
		},

		-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
		auto_install = false,

		highlight = { enable = true },
		indent = { enable = true, disable = { "python", "ocaml" } },
		incremental_selection = {
			enable = true,
		},
	})
	require("nvim-ts-autotag").setup()
	require("ts-comments").setup()
end

return M
