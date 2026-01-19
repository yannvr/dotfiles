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
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "tabs",
          always_show_bufferline = true,
          show_buffer_close_icons = false,
          show_close_icon = false,
          separator_style = "slant",
        },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    cmd = {
      "LualineNotices",
      "LualineTheme",
      "LualineThemes",
      "LualineThemeToggle",
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local base_options = {
        icons_enabled = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
      }

      local function apply_theme(theme)
        require("lualine").setup({
          options = vim.tbl_extend("force", base_options, { theme = theme }),
        })
      end

      local themes = { "palenight", "auto" }
      vim.g.lualine_theme_index = 1

      apply_theme(themes[vim.g.lualine_theme_index])

      local function get_theme_names()
        local names = {}
        local theme_files = vim.api.nvim_get_runtime_file("lua/lualine/themes/*.lua", true)
        for _, path in ipairs(theme_files) do
          local name = vim.fn.fnamemodify(path, ":t:r")
          if name ~= "" then
            table.insert(names, name)
          end
        end
        table.insert(names, "auto")
        table.sort(names)
        return names
      end

      local function starts_with(str, prefix)
        return str:sub(1, #prefix) == prefix
      end

      vim.api.nvim_create_user_command("LualineThemeToggle", function()
        vim.g.lualine_theme_index = (vim.g.lualine_theme_index % #themes) + 1
        apply_theme(themes[vim.g.lualine_theme_index])
      end, {})

      vim.api.nvim_create_user_command("LualineTheme", function(opts)
        apply_theme(opts.args)
      end, {
        nargs = 1,
        complete = function(arg_lead, _, _)
          local results = {}
          for _, name in ipairs(get_theme_names()) do
            if arg_lead == "" or starts_with(name, arg_lead) then
              table.insert(results, name)
            end
          end
          return results
        end,
      })

      vim.api.nvim_create_user_command("LualineThemes", function()
        local names = get_theme_names()
        if #names == 0 then
          vim.notify("No lualine themes found", vim.log.levels.WARN)
          return
        end
        vim.notify(table.concat(names, "\n"), vim.log.levels.INFO)
      end, {})

      vim.keymap.set("n", "<leader>lt", "<cmd>LualineThemeToggle<CR>", { silent = true })
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
