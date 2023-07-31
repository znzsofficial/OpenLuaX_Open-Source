_NIL={}
function class(config)
  local cls=config.extends or Object
  local name=config.name
  return setmetatable(config.static or {},{
    __call=function(t,...)
      local args={...}
      local constructor=function(super,...)
        if table.size(args)==1 and type(args[1])=="table" and luajava.instanceof(args[1][1],cls) then
          super=function(...)
            return args[1][1]
          end
        end
        return (config.constructor or function(super,...)
          return super(...)
        end)(super,...)
      end
      local fields={}
      if config.fields then
        for k,v in pairs(config.fields) do
          fields[k]=v
        end
      end
      local methods=config.methods or {}
      local overrides=config.overrides or {}
      local obj=constructor(cls,...) or cls(...)
      local oldmt,mt=getmetatable(obj),{}
      for k,v in pairs(oldmt) do mt[k]=v end
      local ___tostring=mt.__tostring
      local function index(self,key,hasParam,...)
        debug.setmetatable(self,oldmt)
        local r
        if hasParam then
          r=self[key](...)
         else
          r=self[key]
        end
        debug.setmetatable(self,mt)
        return type(r)=="function" and function(...)
          return index(self,key,true,...)
        end or r
      end
      mt.__index=function(self,key)
        if fields[key]~=nil then
          if fields[key]==_NIL then return end
          return fields[key]
        end
        if overrides[key] then
          return function(...)
            return overrides[key](self,index(self,key),...)
          end
        end
        if methods[key] then
          return function(...)
            return methods[key](self,...)
          end
        end
        return index(self,key)
      end
      mt.__newindex=function(self,key,val)
        if fields[key]~=nil then
          if val==nil then val=_NIL end
          fields[key]=val
          return
        end
        debug.setmetatable(self,oldmt)[key]=val
        debug.setmetatable(self,mt)
      end
      mt.__tostring=function(self)
        local s=___tostring(self)
        s=s:match("(@.+)") or s:match("({.+})")
        return (name or tostring(cls):sub(7))..s
      end
      mt.__type=function(self)
        return "userdata"
      end
      debug.setmetatable(obj,mt)
      if config.init then config.init(obj) end
      return obj
    end,
    __index=function(t,key)
      return cls[key]
    end,
    __tostring=function(t)
      return name and "class "..name or tostring(cls)
    end,
    __type=function(t)
      return tostring(t)
    end
  })
end
return class