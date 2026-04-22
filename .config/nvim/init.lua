-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

-- Add lazy.nvim to runtimepath
vim.opt.rtp:prepend(lazypath)

-- Set leader key before lazy
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- Disable unused providers (suppress checkhealth noise)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

-- vim-airline globals must be set before the plugin loads
vim.g.airline_powerline_fonts = 1
vim.g.airline_theme = "badwolf"
vim.g["airline#extensions#tabline#enabled"] = 1
vim.g["airline#extensions#tabline#formatter"] = "unique_tail"

-- Configure lazy.nvim
local lazy_status, lazy = pcall(require, "lazy")
if lazy_status then
  lazy.setup("plugins", {
    change_detection = {
      notify = false,
    },
    install = {
      colorscheme = { "desert" },
    },
    rocks = {
      enabled = false,
    },
    ui = {
      border = "rounded",
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  })
end

-- Basic Neovim settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "→ ", trail = "·" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.showtabline = 2         -- Always show tab line

-- Load vim configuration files for compatibility (selectively to avoid conflicts)
-- Only load mappings and base config, skip plugin-heavy .vimrc.conf to avoid conflicts
vim.cmd('source ~/.vimrc.maps')
vim.cmd('source ~/.vimrc.conf.base')

-- Load specific settings from .vimrc.conf without plugin conflicts
vim.opt.backupdir = { "./.backup", "~/.backup", ".", "/tmp" }
vim.opt.showcmd = true
vim.opt.autowrite = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.joinspaces = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.dictionary = "/usr/share/dict/words"
vim.opt.complete:append("k")
vim.opt.hlsearch = true
vim.opt.background = "dark"
vim.opt.ignorecase = true
vim.opt.shell = "zsh"
vim.opt.wildchar = 9  -- Tab
vim.opt.wildmenu = true
vim.opt.wildmode = "full"
vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.lazyredraw = true

-- Session commands for Neovim — backed by sessions.picker + persisted.nvim file format.
-- These mirror the Vim-side commands in .vimrc.conf.base so .vimrc.maps bindings
-- (\so, \ss, \sd, \sc, \sq, \sx) work identically in both editors.
vim.api.nvim_create_user_command("SessionOpen",   function() require("sessions.picker").open_picker() end,  { desc = "Open session picker" })
vim.api.nvim_create_user_command("SessionSave",   function() require("sessions.picker").save_current() end, { desc = "Save current session" })
vim.api.nvim_create_user_command("SessionDelete", function()
  pcall(require("persisted").delete)
  vim.notify("Session deleted", vim.log.levels.INFO)
end, { desc = "Delete current session" })
vim.api.nvim_create_user_command("SessionClose",  function() pcall(require("persisted").stop) end, { desc = "Stop session tracking" })

-- Open session picker on bare nvim launch (no file args)
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("InitSessionOnStart", { clear = true }),
  callback = function()
    if vim.fn.argc() == 0 then
      vim.schedule(function()
        require("sessions.picker").open_picker()
      end)
    end
  end,
})
