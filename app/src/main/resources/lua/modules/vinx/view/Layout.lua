local _M = {}

local context = activity
local bind = luajava.bindClass
local instanceOf = luajava.instanceof
local Number = tonumber 
local matches = string.match
local sub = string.sub
local ConstTable = table.const
local insert = table.insert
local metrics = context.resources.displayMetrics
local density = metrics.density
local scaledDensity = metrics.scaledDensity
local xdpi = metrics.xdpi
local loadbitmap = require "loadbitmap"

local ScaleType  = bind "android.widget.ImageView$ScaleType"
local ViewGroup  = bind "android.view.ViewGroup"
local View       = bind "android.view.View"
local TypedValue = bind "android.util.TypedValue"
local ContextThemeWrapper = bind "androidx.appcompat.view.ContextThemeWrapper"
local ViewStubCompat      = bind "androidx.appcompat.widget.ViewStubCompat"

local PagerAdapter
pcall(function()
  PagerAdapter = PagerAdapter or bind "github.daisukiKaffuChino.LuaPagerAdapter"
end)
--pcall(function()
--  PagerAdapter = PagerAdapter or bind "github.daisukiKaffuChino.LuaPagerAdapter"
--end)

_G.Include = ConstTable {}

luajava.ids = luajava.ids or { id = 0x7f000000 }
local ids = luajava.ids
local scaleTypeEnum = ScaleType.values()

-- Compatible with .aly
table.insert(package.searchers, function(path)
  local alypath=package.path:gsub("%.lua;",".aly;")
  local path, msg = package.searchpath(path, alypath)
  if msg then
    return msg
  end
  local f=io.open(path)
  local s=f:read("*a")
  f:close()
  if string.sub(s,1,4)=="\27Lua" then
    return assert(loadfile(path)),path
   else
    --return assert(loadstring("return "..s, path:match("[^/]+/[^/]+$"),"bt")),path
    local f,st=loadstring("return "..s, path:match("[^/]+/[^/]+$"),"bt")
    if st then
      error(st:gsub("%b[]",path,1),0)
    end
    return f,st
  end
end)

table.insert(package.searchers, function(path)
  local alyxPath = package.path:gsub("%.lua;", ".alyx;")
  local path, msg = package.searchpath(path, alyxPath)
  if msg then return msg end
  return assert(loadfile(path)), path
end)

_M.import = function(path)
  local alyxPath = package.path:gsub("%.lua;", ".alyx;")
  local path, msg = package.searchpath(path, alyxPath)
  if msg then return msg end
  return loadfile(path)()
end

local CONSTANTS_MEASUREMENT = {
  match_parent = -1,
  fill_parent  = -1,
  wrap_content = -2,
    
  match = -1,
  fill  = -1,
  wrap  = -2,
}

local CONSTANTS_GRAVITY = ConstTable {
  axis_clip                        = 8,
  axis_pull_after                  = 4,
  axis_pull_before                 = 2,
  axis_specified                   = 1,
  axis_x_shift                     = 0,
  axis_y_shift                     = 4,
  bottom                           = 80,
  center                           = 17,
  center_horizontal                = 1,
  center_vertical                  = 16,
  clip_horizontal                  = 8,
  clip_vertical                    = 128,
  display_clip_horizontal          = 16777216,
  display_clip_vertical            = 268435456,
  fill                             = 119,
  fill_horizontal                  = 7,
  fill_vertical                    = 112,
  horizontal_gravity_mask          = 7,
  left                             = 3,
  no_gravity                       = 0,
  relative_horizontal_gravity_mask = 8388615,
  relative_layout_direction        = 8388608,
  right                            = 5,
  start                            = 8388611,
  top                              = 48,
  vertical_gravity_mask            = 112,
  "end"                            = 8388613,
}

local CONSTANTS = {
  -- orientation
  vertical   = 1,
  horizontal = 0,
  
  -- layout_collapseMode
  pin      = 1,
  parallax = 2,
  
  -- layout_scrollFlags
  noScroll             = 0,
  scroll               = 1,
  exitUntilCollapsed   = 2,
  enterAlways          = 4,
  enterAlwaysCollapsed = 8,
  snap                 = 16,
  snapMargins          = 32,
  
  -- visibility
  visible   = 0,
  invisible = 4,
  gone      = 8,
  
  scaleType = ConstTable {
    matrix       = 0,
    fitXY        = 1,
    fitStart     = 2,
    fitCenter    = 3,
    fitEnd       = 4,
    center       = 5,
    centerCrop   = 6,
    centerInside = 7,
  },
  
  relativeRules = ConstTable {
    layout_above                    = 2,
    layout_alignBaseline            = 4,
    layout_alignBottom              = 8,
    layout_alignEnd                 = 19,
    layout_alignLeft                = 5,
    layout_alignParentBottom        = 12,
    layout_alignParentEnd           = 21,
    layout_alignParentLeft          = 9,
    layout_alignParentRight         = 11,
    layout_alignParentStart         = 20,
    layout_alignParentTop           = 10,
    layout_alignRight               = 7,
    layout_alignStart               = 18,
    layout_alignTop                 = 6,
    layout_alignWithParentIfMissing = 0,
    layout_below                    = 3,
    layout_centerHorizontal         = 14,
    layout_centerInParent           = 13,
    layout_centerVertical           = 15,
    layout_toEndOf                  = 17,
    layout_toLeftOf                 = 0,
    layout_toRightOf                = 1,
    layout_toStartOf                = 16
  }
}


local UNITS = ConstTable {
  px = 0,
  dp = 1,
  sp = 2,
  pt = 3,
  mm = 5,
  "in" = 4
}

local UNITS_CONVERTER = ConstTable {
  px = function(v)
    return v
  end,
  dp = function(v)
    return v * density + 0.5
  end,
  sp = function(v)
    return v * scaledDensity + 0.5
  end,
  pt = function(v)
    return xdpi * value * 0.013888889
  end,
  mm = function(v)
    return xdpi * value * 0.03937008
  end,
  "in" = function(v)
    return xdpi * value
  end,
  "%w" = function(v)
    return v / 100 * activity.width
  end,
  "%h" = function(v)
    return v / 100 * activity.height
  end
}


local IGNORED_ATTRS = ConstTable {
  id = 0,
  viewId = 0,
  style = 0,
  theme = 0,
  layout_width = 0,
  layout_height = 0,

  padding = 0,  
  paddingLeft = 0,
  paddingRight = 0,
  paddingTop = 0,
  paddingBottom = 0,
  paddingStart = 0,
  paddingEnd = 0,
  paddingVertical = 0,
  paddingHorizontal = 0,
  
  layout_margin = 0,
  layout_marginLeft = 0,
  layout_marginRight = 0,
  layout_marginTop = 0,
  layout_marginBottom = 0,
  layout_marginVertical = 0,
  layout_marginHorizontal = 0,
  
  layoutParams = 0,
  base = 0,
  meta = 0,
  let = 0,
}

local customAttrs = {}

local function throw(baseStr, value)
  error(baseStr:format(value), -1)
end

local function measure(value)  
  local unitConverter = UNITS_CONVERTER[sub(value, -2, -1)]
  if unitConverter then
    return unitConverter(sub(value, 1, -3))
  end
end

local function getSpec(value)
  if type(value) == "string" then
    return CONSTANTS_MEASUREMENT[value] or measure(value)
   else
    return value
  end
end

local function toConstant(value, t)
  if type(value) == "number" then return value end   
  local ret = 0
  for n in (value.."|"):gmatch("(.-)|") do
    local s = t[n]
    if t[n] then
      ret = ret | s
     else
      return nil
    end
  end
  return ret
end


local function setAttribute(view, k, v, params)
  local valueType = type(v)

  if k == "layout_weight" then
    params.weight = v
   elseif k == "layout_gravity" then
    params.gravity = toConstant(v, CONSTANTS_GRAVITY)

   elseif k == "layout_marginStart" then
    params.setMarginStart(measure(v) or v)
   elseif k == "layout_marginEnd" then
    params.setMarginEnd(measure(v) or v)

   elseif k == "minHeight" then
    view.setMinimumHeight(measure(v))
   elseif k == "minWidth" then
    view.setMinimumWidth(measure(v))

   elseif (CONSTANTS.relativeRules[k] && v) then
    params.addRule(CONSTANTS.relativeRules[k])
   elseif CONSTANTS.relativeRules[k] then
    params.addRule(CONSTANTS.relativeRules[k], ids[v])

   elseif k == "textSize" then
    if Number(v) then  
      view.setTextSize(UNITS.px, v)
     else  
      local n = sub(v, 1, -3)
      local unit = sub(v, -2, -1)
      if unit then
        view.setTextSize(UNITS[unit], Number(n))
      end
    end

   elseif k == "textStyle" then


   elseif k == "textAppearance" then
    view.setTextAppearance(context, v)

   elseif k == "ellipsize" then
  --  view.setEllipsize(TruncateAt[string.upper(v)])

   elseif k == "url" then
    view.loadUrl(v)

   elseif k == "src" then
    _M.loadImage(view, v)

   elseif k == "scaleType" then
    view.setScaleType(scaleTypeEnum[CONSTANTS.scaleType[v]] or v)

   elseif k == "background" then

   elseif (k == "password" && v) then
    view.setInputType(0x81)
    
   elseif k == "tag" then
    view.setTag(v)
   elseif k == "text" then
    view.setText(v)     
   elseif k == "title" then
    view.setTitle(v)
   elseif k == "subtitle" then
    view.setSubtitle(v)
   elseif k == "hint" then
    view.setHint(v)
   elseif k == "summary" then
    view.setSummary(v)
   
   elseif k == "pages" then
    local list = ArrayList()
    for _, j in ipairs(v) do
      list.add(_M.load(j))
    end
    view.setAdapter(PagerAdapter(list))
    
   elseif k == "pagesWithTitle" then
    local list = ArrayList()
    local titles =  ArrayList()
    for _, j in pairs(v) do
      list.add(_M.load(j[2]))
      titles.add(j[1])
    end
    view.setAdapter(PagerAdapter(list, titles))    
    
   elseif k == "gravity" then
    view.setGravity(toConstant(v, CONSTANTS_GRAVITY) or v)
    
   elseif k == "orientation" then
    view.setOrientation(CONSTANTS[v] or v)
    
   elseif k == "layout_collapseMode" then
    params.setCollapseMode(CONSTANTS[v] or v)
    
   elseif k == "layout_behavior" then
  -- print(view.layoutParams)
    params.setBehavior(v)
    
   elseif k == "layout_scrollFlags" then
    params.setScrollFlags(toConstant(v, CONSTANTS) or v)
   
   elseif k == "behavior_peekHeight" then
    if params.behavior then
      params.behavior.setPeekHeight(measure(v) or 0)
     else
      task(1, function()
        params.behavior.setPeekHeight(measure(v) or 0)
      end)
    end
    
   elseif k == "layout_anchor" then
    params.setAnchorId(ids[v])
   
   elseif k == "layout_anchorGravity" then
    params.anchorGravity = toConstant(v, CONSTANTS_GRAVITY) or v
    
   else
    if customAttrs[k] then
      customAttrs[k](view, v, params)
     elseif valueType == "table" then
      local setter = "set"..k:gsub("^(%w)", string.upper)
      view[setter](table.unpack(v))
     else
      if matches(k, "layout_") then
        if valueType == "string" then
          v = measure(v) or toConstant(v, CONSTANTS)
        end
        params[k:gsub("layout_", "")] = v
       else
        local setter = "set"..k:gsub("^(%w)", string.upper)
        if valueType == "string" then
          v = measure(v) or toConstant(v, CONSTANTS) or v
        end
        view[setter](v)
      end
    end
  end
end


local function initView(viewConstructor, t, parent)
  local view  
  local base = t.base
  if instanceOf(viewConstructor, View) then
    view = viewConstructor
   elseif t.style or t.theme or (base && base.style) then
    view = viewConstructor(
      ContextThemeWrapper(context, t.theme or t.style or base.style),
      nil, t.style or base.style
    )
   else
    view = viewConstructor(context)
  end
  
  local params
  if t.layoutParams then
    params = t.layoutParams
   else
    params = ViewGroup.LayoutParams(
      getSpec(t.layout_width or (base and base.layout_width) or -2),
      getSpec(t.layout_height or (base and base.layout_height) or -2)
    )  
    if parent then
      params = parent.LayoutParams(params)
    end
  end

  local margin = t.layout_margin
  local marginLeft = t.layout_marginLeft
    or t.layout_marginHorizontal or margin
  local marginTop = t.layout_marginTop
    or t.layout_marginVertical or margin
  local marginRight = t.layout_marginRight
    or t.layout_marginHorizontal or margin
  local marginBottom = t.layout_marginBottom
    or t.layout_marginVertical or margin

  if (marginLeft || marginTop
   || marginRight || marginBottom) then
    params.setMargins(
      getSpec(marginLeft or 0),
      getSpec(marginTop or 0),
      getSpec(marginRight or 0),
      getSpec(marginBottom or 0)
    )
  end


  local padding = t.padding
  local paddingLeft = t.paddingLeft
    or t.paddingHorizontal or padding
  local paddingTop = t.paddingTop
    or t.paddingVertical or padding
  local paddingRight = t.paddingRight
    or t.paddingHorizontal or padding
  local paddingBottom = t.paddingBottom
    or t.paddingVertical or padding

  if (paddingLeft || paddingTop
   || paddingRight || paddingBottom) then
    view.setPadding(
      getSpec(paddingLeft or 0),
      getSpec(paddingTop or 0),
      getSpec(paddingRight or 0),
      getSpec(paddingBottom or 0)
    )
  end

  if (t.paddingStart || t.paddingEnd) then
    view.setPaddingRelative(
      getSpec(t.paddingStart or padding or 0),
      getSpec(paddingTop or 0),
      getSpec(t.paddingEnd or padding or 0),
      getSpec(paddingBottom or 0))
  end
  
  
  return view.setLayoutParams(params), params
end


local function load(t, env, parent)
  local view
  local params
  local env = env or _G

  if type(t) == "string" then
    t = require(t)
   elseif type(t) ~= "table" then
    throw("[Layout.load] Error at: %s \n\tThe first argument of the method must be a layout-table or string! ", t)
  end
  
  :: construct ::
  local viewConstructor = t[1]
  if !viewConstructor then
    throw("[Layout.load] Error at: %s \n\tThe first value of the layout-table must be a View Class, check your imported packages.", dump(t))
   elseif type(viewConstructor) == "table" then
    if viewConstructor.__call then
      viewConstructor = viewConstructor.__call
     elseif viewConstructor == Include then
      if (t.condition && !t.condition()) then
        return ViewStubCompat(activity, nil)
      end
      if t.init then
        return load(t.layout, env, parent)
       else
        t = require(t.layout)
        goto construct
      end
    end
  end


  local id = t.id
  local viewId = t.viewId
  local view, params = initView(viewConstructor, t, parent)
  if id then
    rawset(env, id, view)
    if viewId then
      ids[id] = viewId
      view.setId(viewId)
     else
      local idIndex = ids.id
      ids.id = idIndex + 1
      ids[id] = idIndex
      view.setId(idIndex)
    end
  end
 
  if t.base then
    for k, v in pairs(t.base) do
      t[k] = t[k] or v
    end
  end
 
  for k, v in pairs(t) do
    if IGNORED_ATTRS[k] or Number(k) then
      continue     
     else
      local e, s = pcall(setAttribute, view, k, v, params)
      if !e then
        local a, du = pcall(dump, t)
        print(du, view.parent, s, k, v)
      end      
    end
  end
  
  for k, v in ipairs(t) do
    if k == 1 then continue end
    view.addView(load(v, env, view.class))
  end
  
  if (t.base && t.base.let) then
    t.base.let(view)
  end

  return view
end



local function convertConstants(s)
  local t
  if type(s) == "string" then
    t = require(s)
    package.loaded[s] = nil
   elseif type(s) ~= "table" then
    throw("[Layout.load] Error at: %s \n\tThe first argument of the method must be a layout-table or string! ", t)
   else
    t = s
  end
  
  for k, v in pairs(t) do
    if k == 1 then
      continue
     elseif Number(k) then
      t[k] = convertConstants(v)
     elseif k == "base" then
      for j, i in pairs(v) do
        t[j] = t[j] or i
      end
      t[k] = nil
     else
      if type(v) == "string" then
      t[k] = measure(v)
        or toConstant(v, CONSTANTS)
        or toConstant(v, CONSTANTS_GRAVITY)
        or v
      else t[k] = v end
    end
  end
  
  return t
end


_M.loadImage = function(view, value)
  view.setImageBitmap(loadbitmap(value))
end


_M.apply = function(arg1, arg2)
  local t = arg2 or arg1
  local view = arg2 and arg1 or arg1[1]
  local params = view.layoutParams
  
  local margin = t.layout_margin
  local marginLeft = t.layout_marginLeft
    or t.layout_marginHorizontal or margin
  local marginTop = t.layout_marginTop
    or t.layout_marginVertical or margin
  local marginRight = t.layout_marginRight
    or t.layout_marginHorizontal or margin
  local marginBottom = t.layout_marginBottom
    or t.layout_marginVertical or margin

  if (marginLeft || marginTop
   || marginRight || marginBottom) then
    params.setMargins(
      getSpec(marginLeft or 0),
      getSpec(marginTop or 0),
      getSpec(marginRight or 0),
      getSpec(marginBottom or 0)
    )
  end

  local padding = t.padding
  local paddingLeft = t.paddingLeft
    or t.paddingHorizontal or padding
  local paddingTop = t.paddingTop
    or t.paddingVertical or padding
  local paddingRight = t.paddingRight
    or t.paddingHorizontal or padding
  local paddingBottom = t.paddingBottom
    or t.paddingVertical or padding

  if (paddingLeft || paddingTop
   || paddingRight || paddingBottom) then
    view.setPadding(
      getSpec(paddingLeft or 0),
      getSpec(paddingTop or 0),
      getSpec(paddingRight or 0),
      getSpec(paddingBottom or 0)
    )
  end

  if (t.paddingStart || t.paddingEnd) then
    view.setPaddingRelative(
      getSpec(t.paddingStart or padding or 0),
      getSpec(paddingTop or 0),
      getSpec(t.paddingEnd or padding or 0),
      getSpec(paddingBottom or 0))
  end
  
  
  for k, v in pairs(t) do
    if IGNORED_ATTRS[k] or Number(k) then
      continue  
     else   
      setAttribute(view, k, v, params)
    end
  end
end

_M.addAttributeResolver = function(k, v)
  customAttrs[k] = v
end

_M.addAttributeResolvers = function(t)
  for k, v in pairs(t) do
    customAttrs[k] = v
  end
end

_M.Internal = {
  CONSTANTS_MEASUREMENT = CONSTANTS_MEASUREMENT,
  IGNORED_ATTRS = IGNORED_ATTRS,
  UNITS_CONVERTER = UNITS_CONVERTER,
  CONSTANTS_GRAVITY = CONSTANTS_GRAVITY,
  UNITS = UNITS,
  toConstant = toConstant,
  getSpec = getSpec,
  measure = measure,
  initView = initView,
  setAttribute = setAttribute
}

_M.initLayout = convertConstants
_M.load = load
return setmetatable(_M, _M)