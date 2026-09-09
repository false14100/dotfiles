local M = {
	"MagicDuck/grug-far.nvim",
}
function M.config()
	require("grug-far").setup({})
	vim.keymap.set(
		"n",
		"<leader>R",
		"<cmd>lua require('grug-far').open({ transient = true })<CR>",
		{ desc = "Open Grug Far" }
	)
	vim.keymap.set(
		"n",
		"<leader>rw",
		"<cmd>lua require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })<CR>",
		{ desc = "replace word under cursor" }
	)
	vim.keymap.set(
		"v",
		"<leader>rw",
		"<cmd>lua require('grug-far').with_visual_selection({ prefills = { search = vim.fn.expand('<cword>') } })<CR>",
		{ desc = "replace word under cursor" }
	)
	vim.keymap.set(
		"n",
		"<leader>rb",
		"<cmd>lua require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })<CR>",
		{ desc = "replace in current buffer" }
	)
end

return M
