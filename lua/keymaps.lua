-- keymaps.lua - Custom Key Mappings

local keymap = vim.keymap

-- Nvim-tree: Toggle file explorer with Ctrl+b
keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Telescope mappings
keymap.set("n", "<C-f>", ":Telescope find_files<CR>", { noremap = true, silent = true })
keymap.set("n", "<C-p>", ":Telescope live_grep<CR>", { noremap = true, silent = true })

-- Clipboard mappings
keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true }) -- Select all in normal mode
keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })
keymap.set("n", "<C-c>", '"+yy', { noremap = true, silent = true })
keymap.set("n", "<C-x>", '"+dd', { noremap = true, silent = true })
keymap.set("v", "<C-x>", '"+d', { noremap = true, silent = true })
keymap.set("n", "<C-v>", '"+p', { noremap = true, silent = true })
keymap.set("i", "<C-v>", '<C-r>+', { noremap = true, silent = true })

-- Move lines up/down
keymap.set("n", "<A-Up>", ":m .-2<CR>==", { noremap = true, silent = true })
keymap.set("n", "<A-Down>", ":m .+1<CR>==", { noremap = true, silent = true })
keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true }) -- Move focus between NvimTree and editor
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })          -- Move left
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })          -- Move right

