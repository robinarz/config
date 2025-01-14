local lfs = require "lfs"
local file = {}

file.write = function(name, contents)
  local f = assert(io.open(name, "w"), "File must be writable")
  f:write(contents)
  f:close()
end

file.exists = function(filepath)
  local attr = lfs.attributes(filepath)
  return attr ~= nil and attr.mode == "file"
end

return file
