local M = { "nvim-lualine/lualine.nvim" }

function M.config()
	local function arrow_component()
		local statusline = require("arrow.statusline")
		local function get_arrow_status()
			if statusline.is_on_arrow_file() then
				return statusline.text_for_statusline_with_icons()
			end
			return ""
		end

		return {
			function()
				return get_arrow_status()
			end,
			color = {
				gui = "bold",
			},
			-- Only show when there's actual content
			cond = function()
				return statusline.is_on_arrow_file() ~= nil
			end,
			padding = { left = 1, right = 1 },
		}
	end

	require("lualine").setup({
		options = {
			icons_enabled = true,
			theme = "base16",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = {
				statusline = {},
				winbar = {},
			},
			ignore_focus = {},
			always_divide_middle = true,
			always_show_tabline = true,
			globalstatus = true,
			refresh = {
				statusline = 100,
				tabline = 100,
				winbar = 100,
			},
		},
		sections = {
			lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = {
				{
					"filename",
					symbols = {
						modified = "●",
						readonly = "🔒",
						unnamed = "[No Name]",
						newfile = "[New]",
					},
				},
				arrow_component(),
			},
			lualine_x = {
				"lsp_status",
				"encoding",
				"fileformat",
				"filetype",
			},
			lualine_y = { "progress" },
			lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {},
	})
end

return M
