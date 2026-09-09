local M = {
	"jiaoshijie/undotree",
	dependencies = { "nvim-lua/plenary.nvim", lazy = true },
	keys = {
		{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
	},
}

function M.config()
	local undotree = require("undotree")
	undotree.setup({
		float_diff = true, -- using float window previews diff, set this `true` will disable layout option
		layout = "left_bottom", -- "left_bottom", "left_left_bottom"
		position = "left", -- "right", "bottom"
		ignore_filetype = { "undotree", "undotreeDiff", "qf", "TelescopePrompt", "spectre_panel", "tsplayground" },
		window = {
			winblend = 30,
		},
		keymaps = {
			["move_next"] = "j",
			["move_prev"] = "k",
			["move2parent"] = "gj",
			["move_change_next"] = "J",
			["move_change_prev"] = "K",
			["action_enter"] = "<cr>",
			["enter_diffbuf"] = "p", -- is defined for both undotree and preview buffers, so it works as a toggle
			["quit"] = "q", -- is defined for both undotree and preview buffers
			["update_undotree_view"] = "S",
		},
	})
end

return M
