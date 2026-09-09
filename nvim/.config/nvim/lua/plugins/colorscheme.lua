local M = {
	"RRethy/base16-nvim",
	lazy = false,
	priority = 1000,
	opts = {},
}

function M.config()
	vim.cmd.colorscheme("base16-classic-dark")

	-- Function to set custom UI settings including diff highlights
	local function CustomUiSettings()
		-- Original UI settings
		vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#aa759f", bold = true })
		vim.api.nvim_set_hl(0, "LineNr", { fg = "#f5f5f5", bold = true })
		vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#6a9fb5", bold = true })
		-- Normal mode background
		vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		-- Terminal background
		vim.api.nvim_set_hl(0, "Terminal", { bg = "NONE", ctermbg = "NONE" })
		-- Sign column background
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })
		-- Diagnostic virtual text backgrounds
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextOk", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { bg = "NONE", ctermbg = "NONE" })
		-- Treesitter Context highlighting
		vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = "#51B3EC" })
		vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "#51B3EC" })
		-- StatusLine
		vim.api.nvim_set_hl(0, "StatusLine", { fg = "#51B3EC" })

		-- Added diff highlights based on background setting
		if vim.opt.background:get() == "dark" then
			vim.api.nvim_set_hl(0, "DiffAdd", { bold = true, fg = "NONE", bg = "#2e4b2e" })
			vim.api.nvim_set_hl(0, "DiffDelete", { bold = true, fg = "NONE", bg = "#4c1e15" })
			vim.api.nvim_set_hl(0, "DiffChange", { bold = true, fg = "NONE", bg = "#45565c" })
			vim.api.nvim_set_hl(0, "DiffText", { bold = true, fg = "NONE", bg = "#996d74" })
		else
			vim.api.nvim_set_hl(0, "DiffAdd", { bold = true, fg = "NONE", bg = "palegreen" })
			vim.api.nvim_set_hl(0, "DiffDelete", { bold = true, fg = "NONE", bg = "tomato" })
			vim.api.nvim_set_hl(0, "DiffChange", { bold = true, fg = "NONE", bg = "lightblue" })
			vim.api.nvim_set_hl(0, "DiffText", { bold = true, fg = "NONE", bg = "lightpink" })
		end
	end

	-- Create an autocommand to set UI settings after VimEnter
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = CustomUiSettings,
	})

	-- Make it work with colorscheme changes
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = CustomUiSettings,
	})
end

return M
