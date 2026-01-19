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
    ui = {
      border = "rounded",
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  })
end

-- Python provider setup
vim.g.python3_host_prog = '/usr/bin/python3'

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

-- Load session list on startup when no files are provided
-- This triggers the session picker from SessionManager to select from available sessions
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("InitSessionOnStart", { clear = true }),
  callback = function()
    if vim.fn.argc() == 0 then
      vim.schedule(function()
        pcall(function() require("sessions.picker").open_picker() end)
      end)
    end
  end,
})
