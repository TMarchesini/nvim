local plugins = {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-telescope/telescope-frecency.nvim" },
    opts = function()
      local conf = require "plugins.configs.telescope"
      table.insert(conf.extensions_list, "frecency")
      return conf
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    ft = {"python"},
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- "ty" installed via `uv tool install ty`, not Mason (needs python3 in PATH for pip installs)
        "lua-language-server",
        "ruff",
        "typescript-language-server",
        "rust-analyzer",
        "codelldb",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
    dependencies = {"williamboman/mason.nvim"},
  },
  {
    "mrcjkb/rustaceanvim",
    version = '^6',
    ft = 'rust',
    dependencies = {"williamboman/mason.nvim"},
    init = function()
      require("core.utils").load_mappings "lspconfig"
    end,
    config = function()
      -- Deferred (function form) so it's evaluated lazily when rustaceanvim
      -- actually needs it, avoiding a race with mason-registry's async init.
      vim.g.rustaceanvim = function()
        local extension_path = vim.fn.expand("$MASON/packages/codelldb") .. "/extension/"
        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
        local cfg = require('rustaceanvim.config')

        return {
          inlay_hints = {
            enabled = true,
            binding_mode = 'virtual_text', -- or 'prefix' or 'suffix'
            type_hints = true,
            parameter_hints = true,
            chaining_hints = true,
            closure_return_type_hints = true,
            lifetime_hints = true,
            -- etc. based on rust-analyzer's capabilities
          },
          dap = {
            adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
          },
        }
      end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
			local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
		end,
    init = function()
      require("core.utils").load_mappings "dap"
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "github/copilot.vim",
    lazy = false,
    config = function()  -- Mapping tab is already used by NvChad
      vim.g.copilot_no_tab_map = true;
      vim.g.copilot_assume_mapped = true;
      vim.g.copilot_tab_fallback = "";
    -- The mapping is set to other key, see custom/lua/mappings
    -- or run <leader>ch to see copilot mapping section
  end 
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatClose",
      "CopilotChatToggle",
      "CopilotChatStop",
      "CopilotChatReset",
      "CopilotChatSave",
      "CopilotChatLoad",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    build = "make tiktoken",
    opts = {
      model = "claude-opus-5",
    },
    init = function()
      require("core.utils").load_mappings "copilotchat"
    end,
  },
  {
    "nvim-neotest/neotest",
    ft = {"python", "rust"},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require("neotest-python") {
            dap = { justMyCode = false },
            runner = "pytest",
          },
          require("neotest-rust") {
            args = { "--nocapture" },
          },
        },
      }
    end,
    init = function()
      require("core.utils").load_mappings "neotest"
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    main = "render-markdown",
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_theme = "light"
    end,
    keys = {
      {
        "<leader>mp",
        "<cmd>MarkdownPreviewToggle<cr>",
        ft = "markdown",
        desc = "Markdown preview toggle",
      },
    },
  },
}

return plugins
