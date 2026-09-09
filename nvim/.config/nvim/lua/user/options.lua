-- Disable backup and swap files to improve performance
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false

-- UI and Cursor Enhancements
vim.opt.number = true -- Show line numbers
vim.opt.rnu = true -- Relative line numbers
vim.opt.cursorline = true -- Highlight current line
vim.opt.cursorcolumn = true -- Highlight current column
vim.opt.scrolloff = 8 -- Keep 8 lines visible above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns visible left/right of cursor
vim.opt.guicursor = "" -- Preserve terminal cursor style
vim.opt.signcolumn = "yes:2" -- Always show sign column
vim.opt.numberwidth = 4 -- Minimal width for line numbers

-- Editing Comfort
vim.opt.clipboard = "unnamedplus" -- System clipboard integration
vim.opt.mouse = "a" -- Enable mouse in all modes
vim.opt.iskeyword:append("-") -- Treat hyphenated words as single word
vim.opt.smartindent = true -- Smart autoindenting
vim.opt.autoindent = true -- Maintain indent level on new lines

-- CONSISTENT TAB AND INDENTATION SETTINGS
-- These are your global defaults - spaces with 4-character width
vim.opt.expandtab = true -- Always use spaces instead of tabs
vim.opt.shiftwidth = 4 -- Number of spaces for each indentation level
vim.opt.tabstop = 4 -- Number of spaces a tab character displays as
vim.opt.softtabstop = 4 -- Number of spaces inserted when pressing tab
vim.opt.shiftround = true -- Round indent to multiple of shiftwidth
vim.opt.smarttab = true -- Use shiftwidth when inserting tabs

-- Search and Case Sensitivity
vim.opt.hlsearch = true -- Highlight search results
vim.opt.ignorecase = true -- Ignore case in searches
vim.opt.smartcase = true -- Override ignorecase if search contains uppercase

-- Performance and Completion
vim.opt.updatetime = 300 -- Faster completion
vim.opt.timeoutlen = 1000 -- Timeout for mapped sequences
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.pumheight = 10 -- Popup menu height

-- Visual Indicators
vim.opt.list = true
vim.opt.listchars = {
	tab = "╎ ", -- Shows tabs (if any exist)
	trail = "·", -- Shows trailing spaces
	nbsp = "␣", -- Shows non-breaking spaces
	eol = "¬", -- Shows end of line
	extends = "»", -- Shows when line continues beyond screen
	precedes = "«", -- Shows when line starts before screen
}

-- Setup diff options
vim.opt.fillchars = {
	diff = "╱",
}
vim.opt.diffopt = {
	"internal",
	"filler",
	"closeoff",
	"context:12",
	"algorithm:histogram",
	"linematch:200",
	"indent-heuristic",
}

-- Text Wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.lbr = true

-- UI and Encoding
vim.opt.termguicolors = true -- Enable true color support
vim.opt.fileencoding = "utf-8"
vim.opt.conceallevel = 0 -- Show all text in markdown

-- Command and Status Line
vim.opt.cmdheight = 1
vim.opt.laststatus = 3 -- Global status line
vim.opt.showmode = false -- Hide mode indicator
vim.opt.showcmd = false -- Hide partial commands
vim.opt.ruler = false -- Hide cursor position

-- Split Behavior
vim.opt.splitbelow = true -- New splits below
vim.opt.splitright = true -- New splits to the right

-- Undo Persistence
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undodir"

-- Misc
vim.opt.shortmess:append("c") -- Reduce completion messages
vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.fillchars:append({ eob = " " })

-- Remove auto-comment continuation
vim.opt.formatoptions:remove({ "c", "r", "o", "l" })

-- FILE TYPE SPECIFIC INDENTATION OVERRIDES
-- Create autocommands for file types that commonly use different indentation
vim.api.nvim_create_augroup("FileTypeIndent", { clear = true })

-- Languages that commonly use 2 spaces
vim.api.nvim_create_autocmd("FileType", {
	group = "FileTypeIndent",
	pattern = {
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"ocaml",
		"json",
		"html",
		"css",
		"scss",
		"yaml",
		"yml",
		"java",
		"c",
		"cpp",
	},
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.expandtab = true
	end,
})

-- Languages that use tabs (like Go)
vim.api.nvim_create_autocmd("FileType", {
	group = "FileTypeIndent",
	pattern = { "go", "make", "gitconfig" },
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 0
	end,
})

-- Languages that commonly use 4 spaces (your default, but explicit)
vim.api.nvim_create_autocmd("FileType", {
	group = "FileTypeIndent",
	pattern = { "lua", "python", "rust" },
	callback = function()
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.expandtab = true
	end,
})
