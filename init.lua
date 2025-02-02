-- init.lua - Basic Neovim settings

vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.wrap = false
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.termguicolors = true

-- Leader key
vim.g.mapleader = " "

-- Load Lua modules
require("plugins")
require("lsp")
require("keymaps")
