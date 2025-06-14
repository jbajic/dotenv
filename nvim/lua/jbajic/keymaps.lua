local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
--[[keymap("n", "<C-h>", "<C-w>h", opts)]]
--[[keymap("n", "<C-j>", "<C-w>j", opts)]]
--[[keymap("n", "<C-k>", "<C-w>k", opts)]]
--[[keymap("n", "<C-l>", "<C-w>l", opts)]]
keymap("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", opts)
keymap("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", opts)
keymap("n", "<C-l>", "<cmd> TmuxNavigateDown<CR>", opts)
keymap("n", "<C-l>", "<cmd> TmuxNavigateUp<CR>", opts)

-- keymap("n", "<leader>e", ":lex 30<cr>", opts)
-- nvim-tree
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)


-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
-- Does not remove the first copied value after pasting some other
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Custom --

-- Execute current file
vim.keymap.set("n", "<F5>", function()
	vim.cmd(":!%:p")
end)

-- Search vidtulesual selected file
mapping_string = "y/\\V<C-r>=escape(@\",'/\\\\')<CR><CR>"
keymap('v', '//', mapping_string, term_opts)

-- Custom scripts for building TODO(jbajic) write a function that detets
-- and runs appropriate tool
keymap("n", "<leader>rb", "<cmd>!cargo build<CR>", opts)

-- Remaps for quick text formatting
-- under_score to camelCase
keymap("n", "<leader>sfc", [[:s#\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)#\u\1\2#g]], opts)
-- under_score to PascalCase
keymap("n", "<leader>sfp", [[:s#_\(\l\)#\u\1#g]], opts)

keymap("n", "<leader>ws", "<cmd>SymbolsOutline<CR>", opts)

-- Controlling tabs
keymap("n", "]t", ":tabnext<CR>", opts)
keymap("n", "[t", ":tabprev<CR>", opts)

keymap("n", "<leader>tn", ":tabnew %<CR>", opts)
keymap("n", "<leader>tc", ":tabclose<CR>", opts)

-- Navigate buffers
keymap("n", "]b", ":bnext<CR>", opts)
keymap("n", "[b", ":bnext<CR>", opts)

-- Lazy git
keymap("n", "<leader>gg", "<cmd>LazyGit<CR>", opts)

