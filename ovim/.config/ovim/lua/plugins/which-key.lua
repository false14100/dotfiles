local M = {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		plugins = { spelling = true },
		defaults = {
			mode = { "n", "v" },
			["g"] = { name = "+goto" },
			["gz"] = { name = "+surround" },
			["<leader>"] = { name = "+leader" },
			["<leader>b"] = { name = "+buffer" },
			["<leader>c"] = { name = "+code" },
			["<leader>d"] = { name = "+debug" },
			["<leader>f"] = { name = "+file/find" },
			["<leader>g"] = { name = "+git" },
			["<leader>gh"] = { name = "+hunks" },
			["<leader>q"] = { name = "+quit/session" },
			["<leader>s"] = { name = "+search" },
			["<leader>u"] = { name = "+ui" },
			["<leader>w"] = { name = "+windows" },
			["<leader>x"] = { name = "+diagnostics/quickfix" },
			["<leader>t"] = { name = "+test/tailwind" },
		},
	},
}

function M.config()
	local wk = require("which-key")
	wk.setup()
end

return M
