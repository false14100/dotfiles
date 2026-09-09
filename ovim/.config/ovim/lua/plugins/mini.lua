local M = {
	"nvim-mini/mini.nvim",
	version = "*",
	init = function()
		package.preload["nvim-web-devicons"] = function()
			require("mini.icons").mock_nvim_web_devicons()
			return package.loaded["nvim-web-devicons"]
		end
	end,
}

function M.config()
	-- ===== mini.hipatterns =====
	require("mini.hipatterns").setup({
		highlighters = {
			fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
			hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
			todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
			note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
			hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
		},
	})

	-- ===== mini.indentscope =====
	require("mini.indentscope").setup({
		symbol = "│",
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"Trouble",
				"fzf",
				"help",
				"lazy",
				"lspinfo",
				"man",
				"mason",
				"minifiles",
				"neo-tree",
				"nofile",
				"notify",
				"noice",
				"netrw",
				"oil",
				"oil_preview",
				"toggleterm",
				"trouble",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		}),
	})

	-- ===== other mini plugins =====
	require("mini.extra").setup({})
	require("mini.icons").setup({})
	require("mini.git").setup({})
end

return M
