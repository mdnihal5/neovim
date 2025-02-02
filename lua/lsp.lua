-- lsp.lua - LSP Configuration

local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- LSP capabilities for autocompletion
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "html", "ts_ls", "pyright", "lua_ls", "cssls", "jsonls" },
})

-- TypeScript LSP (ts_ls)
lspconfig.ts_ls.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
  end,
})

-- Python LSP
lspconfig.pyright.setup({ capabilities = capabilities })

-- Lua LSP
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = { diagnostics = { globals = { "vim" } } },
  },
})

-- HTML, CSS, JSON LSP
lspconfig.html.setup({ capabilities = capabilities })
lspconfig.cssls.setup({ capabilities = capabilities })
lspconfig.jsonls.setup({ capabilities = capabilities })

-- Auto-formatting setup
local null_ls = require("null-ls")

-- Define LspFormatting group once globally
local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier, -- Ensure Prettier works
    null_ls.builtins.formatting.stylua,
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})
