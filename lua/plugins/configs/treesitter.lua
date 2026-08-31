require("nvim-treesitter.configs").setup {
  ensure_installed = { "lua", "vim", "vimdoc", "rust", "python", "markdown", "markdown_inline", "html", "yaml", "toml" },
  auto_install = true,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}
