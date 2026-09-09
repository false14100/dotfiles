-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Navigate buffers
keymap("n", "]b", ":bnext<CR>", opts)
keymap("n", "[b", ":bprevious<CR>", opts)

-- Move text up and down
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- Half-Page move
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- To Keep the search terms in the middle
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")
keymap("n", "G", "Gzz")

-- Clear highlights
keymap("n", "<leader>no", "<cmd>nohlsearch<CR>", opts)

--QuickfixList
keymap("n", "<C-j>", "<cmd>cnext<CR>zz")
keymap("n", "<C-k>", "<cmd>cprev<CR>zz")
keymap("n", "<leader>j", "<cmd>lnext<CR>zz")
keymap("n", "<leader>k", "<cmd>lprev<CR>zz")

--Replace Text
keymap("n", "<leader>rr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Copy and Paste
keymap("x", "<leader>rp", [["_dP]])
keymap("n", "<leader>p", [["+p]])

keymap({ "n", "v" }, "<leader>y", [["+y]])
keymap("n", "<leader>Y", [["+Y]])

keymap({ "n", "v" }, "<leader>d", [["_d]])

keymap("i", "<C-c>", "<Esc>")

-- Insert --

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
