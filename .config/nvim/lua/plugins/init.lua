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
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    cmd = { "Files", "GFiles", "Buffers", "Ag" },
  },
  { "jlanzarotta/bufexplorer", cmd = { "BufExplorer" } },
  { "moll/vim-bbye", cmd = { "Bdelete", "Bwipeout" } },

  -- Editing
  { "tpope/vim-surround", event = "VeryLazy" },
  { "tpope/vim-commentary", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "junegunn/vim-easy-align", event = "VeryLazy" },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
      -- Integration with nvim-cmp
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

  -- UI
  {
    "vim-airline/vim-airline",
    dependencies = { "vim-airline/vim-airline-themes" },
    event = "VeryLazy",
    config = function()
      vim.g.airline_powerline_fonts = 1
      vim.g.airline_theme = "badwolf"
    end,
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

  -- Finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Telescope" },
  },

  -- Session Management (named sessions with Telescope picker)
  {
    "jedrzejboczar/possession.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      require("possession").setup({
        autosave = {
          current = true,          -- autosave current session on exit
          tmp = false,
          tmp_name = "tmp",
        },
        -- keep default paths; possession uses stdpath('data')/possession
      })
    end,
  },

  -- Powerline Fonts
  { "powerline/fonts", lazy = true },
}
