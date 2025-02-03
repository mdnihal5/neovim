-- plugins.lua
-- Plugin management using lazy.nvim

-- Bootstrap lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- use the stable branch
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- File Explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup {}
        end,
    },

    -- Telescope for file searching
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup {}
        end,
    },

    -- LSP and Completion plugins
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim",          build = ":MasonUpdate" },
    { "williamboman/mason-lspconfig.nvim" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "L3MON4D3/LuaSnip" },

    -- Auto-close brackets and auto-rename tags
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup {}
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup {}
        end,
    },

    -- Linting & Formatting with null-ls
    { "jose-elias-alvarez/null-ls.nvim" },

    -- Treesitter for enhanced syntax highlighting, indentation, etc.
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                -- List of parsers to install
                ensure_installed = { "c", "lua", "rust", "ruby", "vim", "html" },
                sync_install = false,
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- Keybinding Helper
    {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {}
        end,
    },

    -- Monokai theme setup
    {
        "tanvirtin/monokai.nvim", -- Add Monokai theme plugin
        config = function()
            require("monokai").setup({
                palette = require("monokai").pro, -- Use Monokai Pro palette
                transparent_background = true,    -- Enable transparent background
                italics = {
                    comments = true,              -- Make comments italic
                },
            })
            vim.o.termguicolors = true
            vim.o.background = "dark"
            vim.cmd [[colorscheme monokai]] -- Set the theme to Monokai
        end,
    },
})

