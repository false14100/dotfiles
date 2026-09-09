local M = {
	"3rd/image.nvim",
	build = false,
	dependencies = {
		{
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				default = {
					-- Paste images relative to current file
					dir_path = "assets",
					-- Auto-generate filename with timestamp
					file_name = "%Y-%m-%d-%H-%M-%S",
					-- Use markdown syntax without alt text prompt
					template = "![]($FILE_PATH)",
					-- Don't prompt for filename
					prompt_for_file_name = false,
					-- Show notification when image is saved
					show_dir_path_in_prompt = false,
				},
			},
			keys = {
				{ "<C-v>", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard", mode = { "n", "i" } },
			},
		},
	},
}

function M.config()
	require("image").setup({
		backend = "kitty", -- or "ueberzug" if not using kitty
		processor = "magick_cli", -- requires imagemagick
		integrations = {
			markdown = {
				enabled = true,
				clear_in_insert_mode = false,
				download_remote_images = true,
				only_render_image_at_cursor = false,
				filetypes = { "markdown", "vimwiki" },
			},
		},
		max_width = nil,
		max_height = nil,
		max_width_window_percentage = nil,
		max_height_window_percentage = 50,
		window_overlap_clear_enabled = false,
		window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
		editor_only_render_when_focused = false,
		tmux_show_only_in_active_window = false,
		hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
	})
end

return M
