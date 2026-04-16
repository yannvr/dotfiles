-- All plugins are defined here
return {
  -- Colorscheme
  { "kaicataldo/material.vim", lazy = false, priority = 1000 },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },

  -- Snippets
  {
    "Shougo/neosnippet.vim",
    dependencies = { "Shougo/neosnippet-snippets" },
    event = "InsertEnter",
    config = function()
      vim.g["neosnippet#enable_completed_snippet"] = 1
      vim.g["neosnippet#enable_preview"] = 1
    end,
  },

  -- Navigation
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          persisted = {
            layout_config = {
              width = 0.55,
              height = 0.55,
            },
          },
        },
      })

      pcall(telescope.load_extension, "persisted")
    end,
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    cmd = { "Files", "GFiles", "Buffers", "Ag" },
  },
  { "jlanzarotta/bufexplorer", cmd = { "BufExplorer" } },
  { "moll/vim-bbye", cmd = { "Bdelete", "Bwipeout" } },

  -- Editing
  { "tpope/vim-surround", event = "VeryLazy" },
  { "tpope/vim-commentary", event = "VeryLazy" },
  { "tpope/vim-fugitive", lazy = false },
  {
    "NeogitOrg/neogit",
    cmd = { "Neogit" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "sindrets/diffview.nvim",
    },
    config = function()
      require("neogit").setup({
        integrations = {
          telescope = true,
          diffview = true,
        },
      })
    end,
  },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "junegunn/vim-easy-align", event = "VeryLazy" },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end,
  },
  { "rhysd/conflict-marker.vim", event = "VeryLazy" },
  { "osyo-manga/vim-over", event = "VeryLazy" },

  -- UI (load eagerly — airline must hook into tabline at startup)
  {
    "vim-airline/vim-airline",
    dependencies = { "vim-airline/vim-airline-themes" },
    lazy = false,
  },

  -- Coding
  { "editorconfig/editorconfig-vim", event = "VeryLazy" },
  { "mattn/emmet-vim", ft = "html" },
  { "simnalamburt/vim-mundo", cmd = { "MundoToggle" } },
  { "elzr/vim-json", ft = "json" },
  { "groenewege/vim-less", ft = "less" },

  -- Languages
  { "pangloss/vim-javascript", ft = "javascript" },
  { "leafgarland/typescript-vim", ft = "typescript" },
  { "posva/vim-vue", ft = "vue" },
  { "mxw/vim-jsx", ft = "javascript" },

  -- GitHub Copilot
  { "github/copilot.vim", event = "InsertEnter" },

  -- Sessions
  {
    "olimorris/persisted.nvim",
    lazy = false,
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("persisted").setup({
        autoload = false,
        on_autoload_no_session = function()
          -- Opening a fresh project without a stored session should feel silent.
        end,
        telescope = {
          reset_prompt_after_deletion = true,
        },
        use_git_branch = false,
        should_save = function()
          local buffers = vim.tbl_filter(function(buf)
            if vim.bo[buf].buftype ~= "" then
              return false
            end
            return vim.api.nvim_buf_get_name(buf) ~= ""
          end, vim.api.nvim_list_bufs())

          return #buffers > 0
        end,
      })
    end,
  },

  -- Powerline Fonts
  { "powerline/fonts", lazy = true },
}
