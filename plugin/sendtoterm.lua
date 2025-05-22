local commands = require("sendtoterm").commands
local command_info = {
  { "Sendtoterm", commands.send, commands.send_opts },
  { "SendtotermSet", commands.set, commands.set_opts },
  { "SendtotermAdd", commands.add, commands.add_opts },
  { "SendtotermClear", commands.clear, commands.clear_opts },
  { "SendtotermZNext", commands.znext, commands.znext_opts },
  { "SendtotermZPrev", commands.zprev, commands.zprev_opts },
  { "SendtotermAutorun", commands.autorun, commands.autorun_opts },
}

for _, cmd in ipairs(command_info) do
  local name, func, opts = unpack(cmd)
  vim.api.nvim_create_user_command(name, func, opts)
end
