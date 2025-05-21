---@class CustomModule
local M = {}

---@return string
M.get_lines = function(line_start, line_end)
  local lines = vim.fn.getline(line_start, line_end)
  return table.concat(lines, "\n")
end

M.get_visual_selection = function()
  local line_start = vim.fn.getpos("'<")[2]
  local column_start = vim.fn.getpos("'<")[3]
  local line_end = vim.fn.getpos("'>")[2]
  local column_end = vim.fn.getpos("'>")[3]
  local lines = vim.fn.getline(line_start, line_end)
  -- change last line to cut off column_end
  lines[#lines] = string.sub(lines[#lines], 1, column_end)
  -- change first line to cut off column_start
  lines[1] = string.sub(lines[1], column_start)
  return table.concat(lines, "\n")
end

M.get_visual_selection_unless_first_and_last_lines = function(line_start, line_end) 
  if line_start == 1 and line_end == vim.fn.line("$") then
    -- TODO: if in visual selection by character mode and the first and last
    -- lines are selected (but not all characters), then should return get_visual_selection().
    -- Unfortunately I can't figure out a way of detecting this. mode()/getmode() return 'n' when using a command.
    return M.get_lines(line_start, line_end)
  else
    return M.get_visual_selection()
  end
end

M.get_text_from_command_arg = function(arg)
  local text
  if arg.args ~= "" then
    text = arg.args
  elseif arg.range == 0 then
    text = vim.api.nvim_get_current_line()
  else
    -- note -- range can be 0, 1, 2 -- "number of items in the range" --
    -- not sure what to do about 1 (open-ended/open-started range???)
    text = M.get_visual_selection_unless_first_and_last_lines(arg.line1, arg.line2)
  end

  local text
  if arg.args ~= "" then
    text = arg.args
  elseif arg.range == 0 then
    text = vim.api.nvim_get_current_line()
  else
    -- note -- range can be 0, 1, 2 -- "number of items in the range" --
    -- not sure what to do about 1 (open-ended/open-started range???)
    -- inspect arg:
    -- this handles "%" (and maybe also :<2,4>Sendtoterm)
    text = M.get_visual_selection_unless_first_and_last_lines(arg.line1, arg.line2)
  end

  -- add newline if there isn't one:
  -- maybe not working, maybe always adding \n
  if not text:match("\n$") then
    text = text .. "\n" -- seems like this was sending an extra enter sometimes? can't remember
  end

  return text
end

return M
