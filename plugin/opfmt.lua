require('opfmt').init()

vim.api.nvim_create_user_command('Opfmt', function ()
  require('opfmt.internal').format(0, 'line')
end, { nargs = 0, force = true })

vim.api.nvim_create_user_command('OpfmtDebug', function ()
  require('opfmt.internal').debug(0)
end, { nargs = 0, force = true })
