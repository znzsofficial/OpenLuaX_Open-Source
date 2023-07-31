local require = require
local luajava = luajava
local type=type
local string = string
local table = require "table"
local loaded = {}
local imported = {}
luajava.loaded = loaded
luajava.imported = imported
local _G = _G
local insert = table.insert
local pcall = pcall
local new = luajava.new
local debug = debug
local apply = luajava.bindClass
local dexes = {}
local _M = {}
local luacontext = activity or service
LuaActivity = apply("com.androlua.LuaActivity")
dexes = luajava.astable(luacontext.getClassLoaders())
local libs = luacontext.getLibrarys()

--增加全局固定变量
R = apply("github.znzsofficial.openlua.R")
L = activity.getOpenLuaState()

local function libsloader(path)
  local p = libs[path:match("^%a+")]
  if p then
    return assert(package.loadlib(p, "luaopen_" .. (path:gsub("%.", "_")))), p
   else
    return "\n\tno file ./libs/lib" .. path .. ".so"
  end
end

insert(package.searchers, libsloader)

local function massage_classname(classname)
  if classname:find('_') then
    classname = classname:gsub('_', '$')
  end
  return classname
end

local function bind_class(packagename)
  local res, class = pcall(apply, packagename)
  if res then
    loaded[packagename] = class
    return class
  end
end

local function import_class(packagename)
  packagename = massage_classname(packagename)
  local class = loaded[packagename] or bind_class(packagename)
  return class
end

local function bind_dex_class(packagename)
  packagename = massage_classname(packagename)
  for _, dex in ipairs(dexes) do
    local res, class = pcall(dex.loadClass, packagename)
    if res then
      loaded[packagename] = class
      return class
    end
  end
end

local function import_dex_class(packagename)
  packagename = massage_classname(packagename)
  local class = loaded[packagename] or bind_dex_class(packagename)
  return class
end

local pkgMT = {
  __index = function(T, classname)
    local ret, class = pcall(apply, rawget(T, "__name") .. classname)
    if ret then
      rawset(T, classname, class)
      return class
     else
      error(classname .. " is not in " .. rawget(T, "__name"), 2)
    end
  end
}

local function import_pacckage(packagename)
  local pkg = { __name = packagename }
  setmetatable(pkg, pkgMT)
  return pkg
end


--setmetatable(_G, globalMT)

local function import_require(name)
  local s, r = pcall(require, name)
  if not s and not r:find("no file") then
    error(r, 0)
  end
  return s and r
end

local function append(t, v)
  for _, _v in ipairs(t) do
    if _v == v then
      return
    end
  end
  t[#t+1]=v
end

local function local_import(_env, packages, package)
  local j = package:find(':')
  if j then
    local dexname = package:sub(1, j - 1)
    local classname = package:sub(j + 1, -1)
    local class = luacontext.loadDex(dexname).loadClass(classname)
    local classname = package:match('([^%.$]+)$')
    _env[classname] = class
    append(imported, package)
    return class
  end
  local i = package:find('%*$')
  if i then -- a wildcard; put into the package list, including the final '.'
    append(packages, package:sub(1, -2))
    append(imported, package)
    return import_pacckage(package:sub(1, -2))
   else
    local classname = package:match('([^%.$]+)$')
    local class = import_require(package) or import_class(package) or import_dex_class(package)
    if class then
      if class ~= true then
        --findtable(package)=class
        if type(class) ~= "table" then
          append(imported, package)
        end
        _env[classname] = class
      end
      return class
     else
      error("cannot find " .. package, 2)
    end
  end
end


local function env_import(env)
  local _env = env or {}
  local packages = {}
  local loaders = {}
  append(packages, '')
  append(packages, 'java.lang.')
  append(packages, 'java.util.')
  append(packages, 'com.androlua.')

  local function import_1(classname)
    for i, p in ipairs(packages) do
      local class = import_class(p .. classname)
      if class then
        return class
      end
    end
  end

  local function import_2(classname)
    for _, p in ipairs(packages) do
      local class = import_dex_class(p .. classname)
      if class then
        return class
      end
    end
  end

  append(loaders, import_1)
  append(loaders, import_2)

  local globalMT = {
    __index = function(T, classname)
      for i, p in ipairs(loaders) do
        local class = loaded[classname] or p(classname)
        if class then
          T[classname] = class
          return class
        end
      end
      return nil
    end
  }

  if type(_env)=="string" then
    return globalMT.__index({},_env)
  end

  setmetatable(_env, globalMT)
  for k, v in pairs(_M) do
    _env[k] = v
  end
  local import = function(package, env)
    env = env or _env
    if type(package) == "string" then
      return local_import(env, packages, package)
     elseif type(package) == "table" then
      local ret = {}
      for k, v in ipairs(package) do
        ret[k] = local_import(env, packages, v)
      end
      return ret
    end
  end
  _env.import = import

  import("loadlayout", _env)
  import("loadbitmap", _env)
  import("loadmenu", _env)
  return _env
end


function _M.compile(name)
  append(dexes, luacontext.loadDex(name))
end


function _M.enum(e)
  return function()
    if e.hasMoreElements() then
      return e.nextElement()
    end
  end
end

function _M.each(o)
  local iter = o.iterator()
  return function()
    if iter.hasNext() then
      return iter.next()
    end
  end
end

local NIL = {}
setmetatable(NIL, { __tostring = function() return "nil" end })

function _M.dump(o)
  local t = {}
  local _t = {}
  local _n = {}
  local space, deep = string.rep(' ', 2), 0
  local function _ToString(o, _k)
    if type(o) == ('number') then
      t[#t+1]=o
     elseif type(o) == ('string') then
      t[#t+1]=string.format('%q', o)
     elseif type(o) == ('table') then
      local mt = getmetatable(o)
      if mt and mt.__tostring then
        t[#t+1]=tostring(o)
       else
        deep = deep + 2
        t[#t+1]='{'

        for k, v in pairs(o) do
          if v == _G then
            insert(t, string.format('\r\n%s%s\t=%s ;', string.rep(space, deep - 1), k, "_G"))
           elseif v ~= package.loaded then
            if tonumber(k) then
              k = string.format('[%s]', k)
             else
              k = string.format('[\"%s\"]', k)
            end
            insert(t, string.format('\r\n%s%s\t= ', string.rep(space, deep - 1), k))
            if v == NIL then
              insert(t, string.format('%s ;',"nil"))
             elseif type(v) == ('table') then
              if _t[tostring(v)] == nil then
                _t[tostring(v)] = v
                local _k = _k .. k
                _t[tostring(v)] = _k
                _ToString(v, _k)
               else
                insert(t, tostring(_t[tostring(v)]))
                t[#t+1]=';'
              end
             else
              _ToString(v, _k)
            end
          end
        end
        insert(t, string.format('\r\n%s}', string.rep(space, deep - 1)))
        deep = deep - 2
      end
     else
      insert(t, tostring(o))
    end
    t[#t+1]=';'
    return t
  end

  t = _ToString(o, '')
  return table.concat(t)
end


function _M.printstack()
  local stacks = {}
  for m = 2, 16 do
    local dbs = {}
    local info = debug.getinfo(m)
    if info == nil then
      break
    end
    stacks[#stacks+1]=dbs
    dbs.info = info
    local func = info.func
    local nups = info.nups
    local ups = {}
    dbs.upvalues = ups
    for n = 1, nups do
      local n, v = debug.getupvalue(func, n)
      if v == nil then
        v = NIL
      end
      if string.byte(n) == 40 then
        if ups[n] == nil then
          ups[n] = {}
        end
        insert(ups[n], v)
       else
        ups[n] = v
      end
    end

    local lps = {}
    dbs.localvalues = lps
    lps.vararg = {}
    --lps.temporary={}
    for n = -1, -255, -1 do
      local k, v = debug.getlocal(m, n)
      if k == nil then
        break
      end
      if v == nil then
        v = NIL
      end
      insert(lps.vararg, v)
    end
    for n = 1, 255 do
      local n, v = debug.getlocal(m, n)
      if n == nil then
        break
      end
      if v == nil then
        v = NIL
      end
      if string.byte(n) == 40 then
        if lps[n] == nil then
          lps[n] = {}
        end
        insert(lps[n], v)
       else
        lps[n] = v
      end
      --insert(lps,string.format("%s=%s",n,v))
    end
  end
  print(dump(stacks))
  -- print("info="..dump(dbs))
  -- print("_ENV="..dump(ups._ENV or lps._ENV))
end


if activity then
  function _M.print(...)
    local buf = {}
    for n = 1, select("#", ...) do
      buf[#buf+1]=tostring(select(n, ...))
    end
    local msg = table.concat(buf, "\t\t")
    activity.sendMsg(msg)
  end
end


function _M.getids()
  return luajava.ids
end

local LuaAsyncTask = apply("com.androlua.LuaAsyncTask")
local LuaThread = apply("com.androlua.LuaThread")
local LuaTimer = apply("com.androlua.LuaTimer")
local Object = apply("java.lang.Object")


local function setmetamethod(t, k, v)
  getmetatable(t)[k] = v
end

local function getmetamethod(t, k, v)
  return getmetatable(t)[k]
end


local getjavamethod = getmetamethod(LuaThread, "__index")
local function __call(t, k)
  return function(...)
    if ... then
      t.call(k, Object { ... })
     else
      t.call(k)
    end
  end
end

local function __index(t, k)
  local s, r = pcall(getjavamethod, t, k)
  if s then
    return r
  end
  local r = __call(t, k)
  setmetamethod(t, k, r)
  return r
end

local function __newindex(t, k, v)
  t.set(k, v)
end

local function checkPath(path)
  if path:find("^[^/][%w%./_%-]+$") then
    if not path:find("%.lua$") then
      path = string.format("%s/%s.lua", activity.luaDir, path)
     else
      path = string.format("%s/%s", activity.luaDir, path)
    end
  end
  return path
end

function _M.thread(src, ...)
  if type(src) == "string" then
    src = checkPath(src)
  end
  local luaThread
  if ... then
    luaThread = LuaThread(activity or service, src, true, Object { ... })
   else
    luaThread = LuaThread(activity or service, src, true)
  end
  luaThread.start()
  --setmetamethod(luaThread,"__index",__index)\
  --setmetamethod(luaThread,"__newindex",__newindex)
  return luaThread
end

function _M.task(src, ...)
  local args = { ... }
  local callback = args[select("#", ...)]
  args[select("#", ...)] = nil
  local luaAsyncTask = LuaAsyncTask(activity or service, src, callback)
  luaAsyncTask.executeOnExecutor(LuaAsyncTask.THREAD_POOL_EXECUTOR, args)
  return luaAsyncTask
end

function _M.timer(f, d, p, ...)
  local luaTimer = LuaTimer(activity or service, f, Object { ... })
  if p == 0 then
    luaTimer.start(d)
   else
    luaTimer.start(d, p)
  end
  return luaTimer
end

--[[local os_mt = {}
os_mt.__index = function(t, k)
    local _t = {}
    _t.__cmd = (rawget(t, "__cmd") or "") .. k .. " "
    setmetatable(_t, os_mt)
    return _t
end
os_mt.__call = function(t, ...)
    local cmd = t.__cmd .. table.concat({ ... }, " ")
    local p = io.popen(cmd)
    local s = p:read("a")
    p:close()
    return s
end
setmetatable(os, os_mt)
]]
env_import(_G)

local luajava_mt = {}
luajava_mt.__index = function(t, k)
  local b, ret = xpcall(function()
    return apply((rawget(t, "__name") or "") .. k)
  end,
  function()
    local p = {}
    p.__name = (rawget(t, "__name") or "") .. k .. "."
    setmetatable(p, luajava_mt)
    return p
  end)
  rawset(t, k, ret)
  return ret
end
setmetatable(luajava, luajava_mt)

return env_import