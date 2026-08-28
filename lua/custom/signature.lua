-- Auto-popup signature help while typing, reimplemented from NvChad's
-- lua/nvchad/signature.lua without the deprecated vim.lsp.with() wrapper.
-- Instead of wrapping the handler, we build a plain closure that merges the
-- desired config (border/focusable/silent) before calling the base handler.
local config = require("core.utils").load_config().ui.lsp.signature

local M = {}

M.signature_window = function(err, result, ctx, cfg)
  local bufnr, winnr = vim.lsp.handlers.signature_help(err, result, ctx, cfg)
  local current_cursor_line = vim.api.nvim_win_get_cursor(0)[1]

  if winnr then
    if current_cursor_line > 3 then
      vim.api.nvim_win_set_config(winnr, {
        anchor = "SW",
        relative = "cursor",
        row = 0,
        col = -1,
      })
    end
  end

  if bufnr and winnr then
    return bufnr, winnr
  end
end

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local util = require "vim.lsp.util"
local clients = {}

local check_trigger_char = function(line_to_cursor, triggers)
  if not triggers then
    return false
  end

  for _, trigger_char in ipairs(triggers) do
    local current_char = line_to_cursor:sub(#line_to_cursor, #line_to_cursor)
    local prev_char = line_to_cursor:sub(#line_to_cursor - 1, #line_to_cursor - 1)
    if current_char == trigger_char then
      return true
    end
    if current_char == " " and prev_char == trigger_char then
      return true
    end
  end
  return false
end

local open_signature = function()
  local triggered = false

  for _, client in pairs(clients) do
    local triggers = client.server_capabilities.signatureHelpProvider.triggerCharacters

    -- csharp has wrong trigger chars for some odd reason
    if client.name == "csharp" then
      triggers = { "(", "," }
    end

    local pos = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()
    local line_to_cursor = line:sub(1, pos[2])

    if not triggered then
      triggered = check_trigger_char(line_to_cursor, triggers)
    end
  end

  if triggered then
    local params = util.make_position_params()
    local cfg = {
      border = "single",
      focusable = false,
      silent = config.silent,
    }

    vim.lsp.buf_request(0, "textDocument/signatureHelp", params, function(err, result, ctx, handler_cfg)
      handler_cfg = vim.tbl_deep_extend("force", handler_cfg or {}, cfg)
      return M.signature_window(err, result, ctx, handler_cfg)
    end)
  end
end

M.setup = function(client)
  if config.disabled then
    return
  end
  table.insert(clients, client)
  local group = augroup("LspSignature", { clear = false })
  vim.api.nvim_clear_autocmds { group = group, pattern = "<buffer>" }

  autocmd("TextChangedI", {
    group = group,
    pattern = "<buffer>",
    callback = function()
      -- Guard against spamming of method not supported after
      -- stopping a language server with LspStop
      local active_clients = vim.lsp.get_clients()
      if #active_clients < 1 then
        return
      end
      open_signature()
    end,
  })
end

return M
