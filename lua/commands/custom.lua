-- ~/.config/nvim/lua/commands/custom.lua

-- Search for build.bat file in current and parent directories
function RunBuildBat()
  local start_dir = vim.fn.getcwd()

  while start_dir ~= '' do
    local build_bat = start_dir .. '\\build.bat'
    if vim.fn.filereadable(build_bat) == 1 then
      vim.cmd('cd ' .. start_dir)
      print('Found build.bat in: ' .. start_dir)
      vim.cmd '!call build.bat'
      return
    end
    local parent_dir = start_dir:gsub('[^\\/]+$', '') -- Move up one directory
    if parent_dir == start_dir then
      break -- Exit the loop if at root directory
    end
    start_dir = parent_dir
  end

  print 'build.bat not found in the directory tree.'
end

-- Search for build directory and launch main.exe (modified based on previous advice)
function RunDevEnv()
  local start_dir = vim.fn.getcwd()
  local build_dir
  local project_name = vim.fn.fnamemodify(start_dir, ':t') -- Assumes project name is current directory name

  while start_dir ~= '' do
    -- Look for the standard .NET build output path
    local potential_build_dir = start_dir .. '/bin/Debug/net8.0' -- Adjust target framework if needed
    if vim.fn.isdirectory(potential_build_dir) == 1 then
      build_dir = potential_build_dir
      break -- Exit the loop if build directory is found
    end
    local parent_dir = start_dir:gsub('[^\\/]+$', '') -- Move up one directory
    if parent_dir == start_dir then
      break -- Exit the loop if at root directory
    end
    start_dir = parent_dir
  end

  if build_dir then
    vim.cmd('cd ' .. build_dir)
    print('Found build directory: ' .. build_dir)
    local main_dll = build_dir .. '/' .. project_name .. '.dll'
    if vim.fn.filereadable(main_dll) == 1 then
      print('Launching: ' .. main_dll)
      vim.cmd '!dotnet run' -- Or '!dotnet ' .. main_dll
    else
      print('main.dll not found in the build directory. Ensure your project is built.')
    end
  else
    print 'Build output directory not found in the directory tree. Run `dotnet build` first.'
  end
end

-- Export functions to global scope (good practice for keymaps to find them)
_G.RunDevEnv = RunDevEnv
_G.RunBuildBat = RunBuildBat -- Renamed from SearchBuildBat based on your function name

-- Create a custom command to open PowerShell
vim.api.nvim_create_user_command('PowerShell', function()
  vim.cmd 'terminal powershell.exe'
end, { nargs = 0, desc = 'Open PowerShell terminal' })

-- Create a quicker version of the PowerShell command
vim.api.nvim_create_user_command('Pow', function()
  vim.cmd 'terminal powershell.exe'
end, { nargs = 0, desc = 'Open PowerShell terminal (short)' })

-- Create a custom command to open CMD
vim.api.nvim_create_user_command('Cmd', function()
  vim.cmd 'terminal cmd.exe'
end, { nargs = 0, desc = 'Open CMD terminal' })
