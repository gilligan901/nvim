-- ~/.config/nvim/init.lua

-- Set <space> as the leader key (MUST be before lazy.nvim setup)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- Ensure Mason's bin directory is in PATH for Neovim (important for tools like csharpier)
-- This is a good place for it, as it needs to be set early.
local mason_bin = vim.fn.stdpath 'data' .. '/mason/bin'
if vim.loop.fs_stat(mason_bin) then
  vim.env.PATH = mason_bin .. ':' .. vim.env.PATH
end

-- Fix for transparent background with gruvbox (if needed, although you have it as an autocmd)
vim.g.gruvbox_transparent_bg = 1
vim.cmd [[
autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE
]]

-- Load Core Neovim Settings
require 'core.options'
require 'core.keymaps'
require 'core.autocommands'
require 'commands.custom' -- Your RunDevEnv, RunBuildBat functions and custom commands

-- Install and Configure Lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)
vim.opt.diffopt:append 'context:99999' -- This specific option can stay here or move to options.lua

-- Configure and Install Plugins via lazy.nvim
-- The 'plugins' directory will contain all plugin definitions
require('lazy').setup({
  { import = 'plugins' }, -- This line imports all plugin files from the 'plugins' directory
}, {
  ui = {
    -- If you have a Nerd Font, set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
