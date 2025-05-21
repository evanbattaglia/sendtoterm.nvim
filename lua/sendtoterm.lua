-- main module file
local module = require("sendtoterm.module")

---@class MyModule
local M = {}

---@param args Config?
-- you can define your setup function here. Usually configurations can be merged, accepting outside params and
-- you can also put some validation here for those.
M.setup = function(args)
  -- M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.commands = module.commands

return M
