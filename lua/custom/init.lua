vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN]  = "▲",
      [vim.diagnostic.severity.HINT]  = "⚑",
      [vim.diagnostic.severity.INFO]  = "»",
    },
  },
})

-- Ctrl+P: find files ordered by recent/frequent use (see core/mappings.lua
-- M.telescope, powered by telescope-frecency.nvim).

-- Border for all floating windows (hover, signature help, LspInfo, etc.),
-- replacing the deprecated vim.lsp.with() handler-wrapping approach.
vim.o.winborder = "single"
