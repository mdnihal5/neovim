-- lsp.lua
-- LSP configuration, formatting, and autocompletion

local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Create capabilities for nvim-cmp to use LSP completion
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Mason setup for managing LSP servers
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "html", "ts_ls", "pyright", "lua_ls", "cssls", "jsonls", "tailwindcss" },
})

-- Define a common on_attach function for LSP servers
local function on_attach(client, bufnr)
    -- If the LSP client supports formatting, set up an autocommand to format on save
    if client.supports_method("textDocument/formatting") then
        local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end,
        })
    end
end

-- LSP Server Configurations

-- TypeScript / JavaScript using tsserver
lspconfig.ts_ls.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        -- Disable formatting so that null-ls handles it
        client.server_capabilities.documentFormattingProvider = false
        on_attach(client, bufnr)
    end,
})

-- Python using pyright
lspconfig.pyright.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

-- Lua using lua_ls with custom settings
lspconfig.lua_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                },
            },
        },
    },
})

-- HTML, CSS, and JSON language servers
lspconfig.html.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})
lspconfig.cssls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})
lspconfig.jsonls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

-- Tailwind CSS language server
lspconfig.tailwindcss.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

-- Configure null-ls for formatting
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier, -- For HTML, CSS, JS, etc.
        null_ls.builtins.formatting.stylua,   -- For Lua
    },
    on_attach = on_attach,
})

-- Setup nvim-cmp for autocompletion
local cmp = require("cmp")
require("luasnip.loaders.from_vscode").lazy_load() -- Load VSCode snippets

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-o>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- LSP completions
        { name = "luasnip" },  -- Snippet completions
    }, {
        { name = "buffer" },   -- Buffer completions
    }),
    formatting = {
        format = function(entry, vim_item)
            -- Set the menu for completion items
            if entry.completion_item.detail ~= nil and entry.completion_item.detail ~= "" then
                vim_item.menu = entry.completion_item.detail
            else
                vim_item.menu = ({
                    nvim_lsp = "[LSP]",
                    luasnip = "[Snippet]",
                    buffer = "[Buffer]",
                    path = "[Path]",
                })[entry.source.name] or "[Unknown]"
            end
            return vim_item
        end,
    },
})

-- LSP-related keybindings using an autocommand
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
    end,
})

