require "import"

local _M = {
  GET = "get",
}

_M.__call = function(self, t)
  return function(...)
    local args = {...}
    local path = t.path
    for k, v in pairs(t.param or {}) do
      path = path:gsub("\n", ""):gsub(string.format("{%s}", v),
        args[k] or t.defaultValue[k])
    end
    return {
      method = t.method,
      path = path 
    }
  end
end

return setmetatable(_M, _M)