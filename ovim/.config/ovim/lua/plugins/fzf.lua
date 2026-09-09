local M = {
	"ibhagwan/fzf-lua",
}

function M.config()
	require("fzf-lua").setup({
		"telescope",
		fzf_opts = {
			["--layout"] = "reverse",
		},
		oldfiles = {
			include_current_session = true,
		},
		previewers = {
			builtin = {
				syntax_limit_b = 1024 * 100, -- 100KB
			},
		},
		grep = {
			rg_glob = true, -- enable glob parsing
			glob_flag = "--iglob", -- case insensitive globs
			glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
		},
	})
	local fzf = require("fzf-lua")

	vim.keymap.set("n", "<leader>sh", function()
		fzf.help_tags()
	end, { desc = "[S]earch [H]elp" })
	vim.keymap.set("n", "<leader>sk", function()
		fzf.keymaps()
	end, { desc = "[S]earch [K]eymaps" })
	vim.keymap.set("n", "<leader>sf", function()
		fzf.files()
	end, { desc = "[S]earch [F]iles" })
	vim.keymap.set("n", "<leader>ss", function()
		fzf.builtin()
	end, { desc = "[S]earch [S]elect FZF" })
	vim.keymap.set("n", "<leader>sd", function()
		fzf.diagnostics_workspace()
	end, { desc = "[S]earch [D]iagnostics" })
	vim.keymap.set("n", "<leader>rs", function()
		fzf.resume()
	end, { desc = "[R]esume [S]earch" })
	vim.keymap.set("n", "<leader>s.", function()
		fzf.oldfiles()
	end, { desc = '[S]earch Recent Files ("." for repeat)' })
	vim.keymap.set("n", "<leader>sb", function()
		fzf.buffers()
	end, { desc = "[ ] Find existing buffers" })

	vim.keymap.set("n", "<leader>sg", function()
		fzf.live_grep()
	end, { desc = "[S]earch by [G]rep" })
	vim.keymap.set("n", "<leader>sw", function()
		fzf.grep_cword()
	end, { desc = "[S]earch word under [C]ursor" })

	-- Git keymaps
	vim.keymap.set("n", "<C-p>", function()
		fzf.git_files()
	end, { desc = "[G]it [F]iles" })
	vim.keymap.set("n", "<leader>gb", function()
		fzf.git_branches()
	end, { desc = "[G]it [B]ranches" })
	vim.keymap.set("n", "<leader>gh", function()
		fzf.git_status()
	end, { desc = "[G]it [H]unks" })
	vim.keymap.set("n", "<leader>gs", function()
		fzf.git_stash()
	end, { desc = "[G]it [S]tash" })
	vim.keymap.set("n", "<leader>gc", function()
		fzf.git_commits()
	end, { desc = "[G]it [C]ommits" })
end

return M
