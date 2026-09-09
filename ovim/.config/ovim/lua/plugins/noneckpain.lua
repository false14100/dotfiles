local M = {
	"shortcuts/no-neck-pain.nvim",
	version = "*",
	keys = {
		{ "<leader>z", "<cmd>NoNeckPain<cr>", desc = "[T]oggle [N]o[N]eckPain" },
	},
}
function M.config()
	require("no-neck-pain").setup()
end
return M
