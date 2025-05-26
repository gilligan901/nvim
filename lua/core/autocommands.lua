-- ~/.config/nvim/lua/core/autocommands.lua

-- [[ Basic Autocommands ]]
-- See `:help lua-guide-autocommands`

-- Autocmd for remote connections, disabling oil.nvim and forcing netrw
vim.api.nvim_create_autocmd({ 'BufReadPre', 'FileReadPre' }, {
  pattern = { 'scp://*', 'sftp://*', 'ssh://*' },
  callback = function(ev)
    -- Disable oil.nvim for this buffer
    vim.b[ev.buf].oil_disable = true
    -- Force netrw for remote files
    vim.g.loaded_oil = 1
  end,
})

-- Highlight when yanking (copying) text
-- Try it with `yap` in normal mode
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- CustomDiff autocommand (originally in VimEnter)
vim.api.nvim_create_augroup('CustomDiff', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = 'CustomDiff',
  callback = function()
    vim.cmd [[
      hi DiffAdd NONE
      hi DiffDelete NONE
      hi DiffChange NONE
    ]]
  end,
})

-- Fugitive FileType autocmd
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'fugitive',
  callback = function()
    -- Restore Ctrl+h/l navigation in fugitive buffers
    vim.keymap.set('n', '<C-h>', '<C-w>h', { buffer = true })
    vim.keymap.set('n', '<C-l>', '<C-w>l', { buffer = true })
  end,
})

-- Terminal autocommands
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('cutom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.opt.signcolumn = 'no'
  end,
})
