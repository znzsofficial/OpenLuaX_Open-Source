require "import"
import "json"

local _M = {}

_M.convert = function(content)
  return json.decode(tostring(content))
end

_M.__call = function(self, ...)
  
end

return setmetatable(_M, _M)