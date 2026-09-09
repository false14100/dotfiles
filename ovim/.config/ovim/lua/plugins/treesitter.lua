local M = {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-context",
			opts = {
				enable = true,
				max_lines = 3,
				min_window_height = 0,
				line_numbers = true,
				multiline_threshold = 1,
				trim_scope = "outer",
				mode = "topline",
				separator = nil,
				zindex = 20,
			},
		},
	},
}

function M.config()
	require("nvim-treesitter").setup({
		-- Install parsers for note-taking
		ensure_installed = {
			"markdown",
			"markdown_inline",
			"lua", -- for config files
			"vim", -- for vim help
			"vimdoc",
			"bash", -- for code blocks
			"python", -- common in notes
			"json", -- common in notes
			"yaml", -- common in notes
		},

		-- Auto-install missing parsers
		auto_install = true,

		highlight = {
			enable = true,
			-- Disable for very large files
			disable = function(_, buf)
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,
			-- Required for markdown concealing to work
			additional_vim_regex_highlighting = { "markdown" },
		},

		-- Incremental selection - useful for selecting markdown sections
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-space>",
				node_incremental = "<C-space>",
				scope_incremental = false,
				node_decremental = "<bs>",
			},
		},

		-- Indentation based on treesitter
		indent = {
			enable = true,
			disable = { "markdown" }, -- Markdown indentation can be finicky
		},
	})

	-- Configure treesitter-context for markdown headers
	require("treesitter-context").setup({
		enable = true,
		max_lines = 3,
		min_window_height = 0,
		line_numbers = true,
		multiline_threshold = 1,
		trim_scope = "outer",
		mode = "topline",
		separator = nil,
		zindex = 20,
		-- Markdown-specific settings
		patterns = {
			default = {
				"class",
				"function",
				"method",
			},
			markdown = {
				"section", -- Markdown sections
				"atx_heading", -- # Headers
				"setext_heading", -- Underlined headers
			},
		},
	})

	-- Optional: Add a keymap to toggle context
	vim.keymap.set("n", "<leader>tc", function()
		require("treesitter-context").toggle()
	end, { desc = "Toggle Treesitter Context" })
end

return M
