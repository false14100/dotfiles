local M = {
	"sindrets/diffview.nvim", -- optional - Diff integration
}

function M.config()
	local function diffOpenWithInput()
		local user_input = vim.fn.input("Revision to Open: ")
		vim.cmd("DiffviewOpen " .. user_input)
	end

	local function diffOpenFileHistory()
		local user_input = vim.fn.input("Files to Open: ")
		vim.cmd("DiffviewFileHistory" .. user_input)
	end

	-- Here are some soem ways I commonly call it:

	-- 1. diffOpenFileHistory with . opens commit wise history of entire codebase.

	-- 2. diffOpenFileHistory with % opens commit wise history of current file.

	-- 3. diffOpenFileHistory with <any file path> opens commit wise history of that file.

	-- 4. diffOpenWithInput with HEAD opens diff of latest commit.

	-- 5. diffOpenWithInput with HEAD~3 opens diff of last 3 commits.

	-- 6. diffOpenWithInput with master..HEAD opens changes of your feature branch.
	vim.keymap.set("n", "<leader>df", diffOpenFileHistory, { desc = "Open DiffView on Files" })
	vim.keymap.set("n", "<leader>do", diffOpenWithInput, { desc = "Open DiffView" })
	vim.keymap.set("n", "<leader>dg", "<cmd>DiffviewOpen<CR>", { desc = "Open DiffView in git" })
	vim.keymap.set("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { desc = "Close DiffView" })
end

return M
