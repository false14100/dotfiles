-- Disable backup and swap files
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false

-- UI - Keep it clean for notes
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.numberwidth = 2 -- Narrower for notes

-- Editing
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
-- vim.opt.iskeyword:append("-") -- Important for wiki-links
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Indentation for markdown/notes (2 spaces is common)
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftround = true

-- Search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Performance
vim.opt.updatetime = 300
vim.opt.timeoutlen = 1000

-- Text wrapping - essential for notes
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true -- Wrapped lines preserve indentation

-- UI
vim.opt.termguicolors = true
vim.opt.fileencoding = "utf-8"
vim.opt.conceallevel = 2 -- Nice for markdown formatting (bold, italic, links)

-- Command line
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.showmode = false

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Undo persistence - crucial for notes!
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/ovim-undodir"

-- Spelling - essential for note-taking
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Misc
vim.opt.shortmess:append("c")
vim.opt.fillchars:append({ eob = " " })

-- Remove auto-comment continuation
vim.opt.formatoptions:remove({ "c", "r", "o", "l" })

-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("ovim-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
