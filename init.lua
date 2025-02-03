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

-- proxy
 vim.env.http_proxy = "http://tempuser1:rgukt123@staffnet.rgukt.ac.in:3128"
vim.env.https_proxy = "http://tempuser1:rgukt123@staffnet.rgukt.ac.in:3128"


-- Leader key
vim.g.mapleader = " "

-- Load Lua modules
require("plugins")
require("lsp")
require("keymaps")
