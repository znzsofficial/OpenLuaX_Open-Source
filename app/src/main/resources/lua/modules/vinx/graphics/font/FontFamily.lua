local bind = luajava.bindClass
local instanceOf = luajava.instanceof
local toTable = luajava.astable
local TypefaceBuilder   = bind "android.graphics.Typeface$CustomFallbackBuilder"
local FontBuilder       = bind "android.graphics.fonts.Font$Builder"
local FontFamilyBuilder = bind "android.graphics.fonts.FontFamily$Builder"
local File              = bind "java.io.File"

local _M = {}

local BLANK_FONT_FILE = File(activity.LuaDir, "blank.ttf")

local function loadFont(file)
  return FontFamilyBuilder(
    FontBuilder(file).build()
  ).build()
end

_M.addFont = function(self, file)
  self.builder.addCustomFallback(loadFont(file))
end

_M.setSystemFallback = function(self, name)
  self.fallbackName = name
  return self.builder.setSystemFallback(name)
end

_M.build = function(self)
  return self.builder.build()
end

_M.new = function(list)
  local self = table.clone(_M)
  self.new = nil
  self.builder = TypefaceBuilder(
    loadFont(BLANK_FONT_FILE))
 
  if not type(list) == "table" then
    list = toTable(list)
  end

  for _, v in pairs(list) do
    if instanceOf(v, File) then
      self:addFont(v)
     else
      self:addFont(File(v))
    end
  end

  if not self.fallbackName then
    self:setSystemFallback("sans")
  end
  return self
end

setmetatable(_M, {
  __call = lambda _, list: _M.new(list)
})

return _M