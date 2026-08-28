-- nvim-treesitter (main branch) only installs parsers; highlighting, indent
-- and folding are provided by Neovim core and enabled here manually.
local ensure_installed = { "lua", "vim", "vimdoc", "rust", "python", "markdown", "markdown_inline", "html", "yaml", "toml" }

require("nvim-treesitter").setup {
  install_dir = vim.fn.stdpath "data" .. "/site",
}
require("nvim-treesitter").install(ensure_installed, { compilers = { "zig" } })

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local ok = pcall(vim.treesitter.start, args.buf)
    if ok then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo[0][0].foldmethod = "expr"
      vim.wo[0][0].foldlevel = 99
      vim.wo[0][0].foldenable = true
    end
  end,
})
