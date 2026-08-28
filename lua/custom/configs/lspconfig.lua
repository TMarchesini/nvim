local config = require("plugins.configs.lspconfig")

local on_attach = config.on_attach
local capabilities = config.capabilities


vim.lsp.config('ty', {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
})

vim.lsp.config('ruff', {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  init_options = {
    settings = {
      showSyntaxErrors = false,
      lint = {
        select = { 'E', 'I', 'SIM', 'B', 'S', 'N' },
      },
    },
  },
}
)

vim.lsp.enable { "ty", "ruff" }
