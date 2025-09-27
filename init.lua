require "core"

local cargo_bin = vim.fn.expand("~/.cargo/bin")
local local_bin = vim.fn.expand("~/.local/bin") -- Often useful for other tools

local existing_path = vim.env.PATH or ""

if not string.find(existing_path, cargo_bin, 1, true) then
  vim.env.PATH = cargo_bin .. ":" .. existing_path
end

if not string.find(existing_path, local_bin, 1, true) then
  vim.env.PATH = local_bin .. ":" .. (vim.env.PATH or existing_path) -- Append to the potentially updated PATH
end

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"


vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({higroup="IncSearch", timeout=200})
  end,
})

vim.opt.relativenumber = true

vim.lsp.enable("ts_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("ruff")
