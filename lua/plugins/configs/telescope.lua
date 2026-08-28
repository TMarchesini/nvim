local options = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { "node_modules" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    -- Show "filename  path/relative/to/project/root" instead of the full,
    -- long path anchored at the filesystem root (which otherwise repeats
    -- the project folder itself on every line).
    path_display = function(opts, path)
      local Path = require "plenary.path"
      local utils = require "telescope.utils"
      local cwd = opts.cwd or vim.loop.cwd()
      local relative = Path:new(path):make_relative(cwd)
      local tail = utils.path_tail(relative)
      return relative == tail and tail or string.format("%s  %s", tail, relative)
    end,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    mappings = {
      n = { ["q"] = require("telescope.actions").close },
      i = {
        ["<C-j>"] = require("telescope.actions").move_selection_next,
        ["<C-k>"] = require("telescope.actions").move_selection_previous,
      },
    },
  },

  extensions_list = { "themes", "terms" },

  extensions = {
    -- Disable frecency's own "workspace tag" column (e.g. "quantapps/"),
    -- which is separate from path_display and was showing alongside it.
    frecency = { show_filter_column = false },
  },
}

return options
