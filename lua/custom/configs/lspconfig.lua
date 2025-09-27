local config = require("plugins.configs.lspconfig")

local on_attach = config.on_attach
local capabilities = config.capabilities


vim.lsp.config('pyright', {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"python"},
  init_options = {
    settings = {
      pyright = {
        disableOrganizeImport = true,
        exclude = { ".venv" },
        venvPath = ".",
        venv = ".venv",
      },
      python = {
        analysis = {
          ignore = { '*'}
        }
      }
   }
  }
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
