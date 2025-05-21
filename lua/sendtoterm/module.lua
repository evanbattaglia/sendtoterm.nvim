local util = require("sendtoterm.util")

---@class CustomModule
local M = {}

M.term_job_ids = {}

---@return string
M.send_to_zellij_pane = function(text, next_or_prev)
  vim.fn.system("zellij-send-to-" .. next_or_prev .. " " .. vim.fn.shellescape(text))
end

M.send_to_term_or_zellij_pane = function(text)
  if M.term_job_ids == "znext" then
    M.send_to_zellij_pane(text, "next")
    return
  elseif M.term_job_ids == "zprev" then
    M.send_to_zellij_pane(text, "prev")
    return
  elseif not M.term_job_ids or #(M.term_job_ids) == 0 then
    print("No terminal job id set. Run :SendtotermSet in the terminal you want to send to, or :SendtotermZNext or SendtotermZPrev to send to the next or previous zellij pane.")
    return
  end

  -- loop over all terminal job ids:
  for _, term_job_id in ipairs(M.term_job_ids) do
    vim.api.nvim_chan_send(term_job_id, text)
  end
end

M.commands = {}

M.commands.set = function ()
  print("Set terminal job id to " .. vim.inspect(vim.b.terminal_job_id) .. ", was: " .. vim.inspect(M.term_job_ids))
  M.term_job_ids = {vim.b.terminal_job_id}
end
M.commands.set_opts = {
  desc = "Set terminal job id"
}

M.commands.add = function ()
  table.insert(M.term_job_ids, vim.b.terminal_job_id)
  print("Term job ids now: " .. vim.inspect(M.term_job_ids))
end
M.commands.add_opts = {
  desc ="Add the current terminal job id to the list of terminal job ids",
}

M.commands.clear = function()
  print("Clearing terminal job ids, was: " .. vim.inspect(M.term_job_ids))
  M.term_job_ids = {}
end
M.commands.clear_opts = {
  desc ="Clear the terminal job id",
}

M.commands.znext = function()
  M.term_job_ids = "znext"
  print("Set terminal job id to znext")
end
M.commands.znext_opts = {
  desc ="Send to the next zellij pane",
}

M.commands.zprev = function()
  M.term_job_ids = "zprev"
  print("Set terminal job id to zprev")
end
M.commands.zprev_opts = {
  desc ="Send to the previous zellij pane",
}

M.commands.send = function(arg)
  local text = util.get_text_from_command_arg(arg)
  M.send_to_term_or_zellij_pane(text)
end
M.commands.send_opts = {
  desc = "Run a command in terminal (set terminal job id with set/add/znext/zprev)",
  range = "%",
  nargs = "?",
}

M.commands.autorun = function(arg)
  local job_id = vim.b.terminal_job_id
  local command = arg.args

  if command == nil or command == '' then
    command = vim.fn.input("Enter a command to run on save (use {} or {:?} for path): ")
  end
  local pattern = vim.fn.input("Enter a pattern to match files to run this command on: ")

  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = pattern,
    group = vim.api.nvim_create_augroup("autorun", {clear = true}),
    callback = function(ev)
      local cmd = command
      cmd = cmd:gsub("{}", vim.fn.expand("%:t"))
      cmd = cmd:gsub("{:%?}", vim.fn.expand("%:p"))
      if command ~= '' then
        M.send_to_term_or_zellij_pane(cmd .. "\n")
      end
    end
  })

  if command == '' then
    print("Autorun " .. (command == '' and "cleared" or "set"))
  end
end
M.commands.autorun_opts = {
  desc = "Run a command in this terminal whenever a file is saved. Optional argument: the command (don't quote it)",
  nargs = "?",
}

return M
