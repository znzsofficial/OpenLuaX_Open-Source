return function(config)
  local clazz = config.extends or Object
  local constructor = config.constructor or function(super, ...)
    return super(...)
  end
  local fields = config.fields or {}
  local methods = config.methods or {}
  local overrides = config.overrides or {}
  local name = config.name
  
  return setmetatable({}, {
    __call = function(t, ...)
      local obj = constructor(clazz, ...) or clazz(...)
      local oldMt = getmetatable(obj)
      local mt = {}
      for k, v in pairs(oldMt) do
        mt[k] = v
      end
      local ___tostring = mt.__tostring
      local function index(self, key, hasParam, ...)
        debug.setmetatable(self, oldMt)
        local r
        if hasParam then
          r = self[key](...)
         else
          r = self[key]
        end
        debug.setmetatable(self, mt)
        return type(r) == "function" and function(...)
          return index(self,key,true,...)
        end or r
      end
      
      mt.__index=function(self,key)
        if fields[key] then
          return fields[key]
        end
        if overrides[key] then
          return function(...)
            overrides[key](self,index(self,key),...)
          end
        end
        if methods[key] then
          return function(...)
            methods[key](self,...)
          end
        end
        return index(self,key)
      end
      
      mt.__newindex=function(self,key,val)
        if fields[key] then
          fields[key]=val
          return
        end
        debug.setmetatable(self,oldMt)[key]=val
        debug.setmetatable(self,mt)
      end
      mt.__tostring=function(self)
        local s=___tostring(self)
        s=s:match("(@.+)") or s:match("({.+})")
        return (name or tostring(clazz):sub(7))..s
      end
      mt.__type=function(self)
        return "userdata"
      end
      return debug.setmetatable(obj,mt)
    end,
    
    __index=function(t,key)
      return clazz[key]
    end,
    __tostring=function(t)
      return name and "class "..name or tostring(clazz)
    end,
    __type=function(t)
      return tostring(t)
    end
  })
end