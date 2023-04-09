require "import"
import "vinx.worknet.Call"

local _M = {}

function _M:create(api)
  local t = {}
  for k, v in pairs(api) do
    t[k] = function(_, ...)
      return Call(self, v(...))
    end
  end
  return t
end

_M.__call = function(self, t)
  local obj = table.clone(self)
  obj.baseUrl = t.baseUrl
  obj.converter = t.converter
  return obj
end

return setmetatable(_M, _M)