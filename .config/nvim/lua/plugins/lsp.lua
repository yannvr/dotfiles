return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Setup Mason to automatically install LSP servers
      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_installation = true
      })

      -- Configure LSP servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Setup keymaps when an LSP connects to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }

          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        end,
      })

      -- Configure Lua language server using Neovim 0.11+ API to avoid deprecated lspconfig framework
      -- See :help lspconfig-nvim-0.11
      local ok, lua_server = pcall(require, "lspconfig.server_configurations.lua_ls")
      if ok and lua_server and lua_server.default_config then
        local default_config = lua_server.default_config
        local merged = vim.tbl_deep_extend("force", default_config, {
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
            },
          },
        })
        -- Start for Lua buffers
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "lua",
          group = vim.api.nvim_create_augroup("LuaLspStart", { clear = true }),
          callback = function()
            vim.lsp.start(vim.lsp.config(merged))
          end,
        })
      end
    end,
  },
}
