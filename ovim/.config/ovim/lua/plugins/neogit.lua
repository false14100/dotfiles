local M = {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>gg", "<cmd>Neogit<CR>", desc = "Open Neogit" },
	},
}

function M.config()
	require("neogit").setup({
		-- Core settings
		disable_context_highlighting = false,
		disable_signs = false,
		disable_hint = false,
		disable_commit_confirmation = false,
		disable_relative_line_numbers = false,
		auto_refresh = true,

		-- Customizing the UI
		kind = "tab", -- Or "split", "tab", "floating" based on your preference

		-- Integration with other plugins
		integrations = {
			diffview = true,
			fzf_lua = true,
		},

		-- Mappings configuration
		mappings = {
			status = {
				-- Disable number mappings
				["1"] = false,
				["2"] = false,
				["3"] = false,
				["4"] = false,
			},
		},

		-- Commit editor settings
		commit_editor = {
			kind = "split",
		},

		-- Notifications
		notification_settings = {
			enabled = true,
			timeout = 3000, -- in milliseconds
			max_width = nil,
		},

		-- Repository settings
		repository_list = {
			status_width = 80,
		},
	})
end

return M
