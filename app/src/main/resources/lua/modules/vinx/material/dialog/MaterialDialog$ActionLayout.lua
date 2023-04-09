local _M = {}

local bindClass      = luajava.bindClass
local FrameLayout    = bindClass "android.widget.FrameLayout"
local LinearLayout   = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local TextView       = bindClass "androidx.appcompat.widget.AppCompatTextView"
local loadlayout     = require "loadlayout"

local Button         = require "vinx.material.dialog.MaterialDialog$Button"
local MaterialButton = Button.createButton


local LAYOUT_BUTTON_NORMAL = {
  FrameLayout,
  layout_width = "match",
  layout_height = "wrap",
  padding = "4dp",
  {
    MaterialButton,
    layout_height = "36dp",
    layout_margin = "4dp",
    visibility = "gone"
  },
  {
    LinearLayout,
    layout_gravity = "end",
    {
      MaterialButton,
      layout_height = "36dp",
      layout_margin = "4dp",
      visibility = "gone"
    },
    {
      MaterialButton,
      layout_height = "36dp",
      layout_margin = "4dp",
      visibility = "gone"
    }
  }
}

local LAYOUT_BUTTON_STACK = {
  LinearLayout,
  layout_width = "match",
  layout_height = "wrap",
  padding = "4dp",
  gravity = "end",
  orientation = "vertical",
  {
    MaterialButton,
    layout_height = "wrap",
    layout_marginTop = "-2dp",
    layout_marginBottom = "-2dp",
    layout_marginStart = "4dp",
    layout_marginEnd = "4dp",
    insetTop = "6dp",
    insetBottom = "6dp",
    gravity = "center|end",
    visibility = "gone"
  },
  {
    MaterialButton,
    layout_height = "wrap",
    layout_marginTop = "-2dp",
    layout_marginBottom = "-2dp",
    layout_marginStart = "4dp",
    layout_marginEnd = "4dp",
    insetTop = "6dp",
    insetBottom = "6dp",
    gravity = "center|end",
    visibility = "gone"
  },
  {
    MaterialButton,
    layout_height = "wrap",
    layout_marginTop = "-2dp",
    layout_marginBottom = "-2dp",  
    layout_marginStart = "4dp",
    layout_marginEnd = "4dp",
    insetTop = "6dp",
    insetBottom = "6dp",
    gravity = "center|end",
    visibility = "gone"
  }
}

_M.createNormalLayout = function()
  local view = loadlayout(LAYOUT_BUTTON_NORMAL)
  local mPositiveButton = view.getChildAt(1).getChildAt(1)
  local mNegativeButton = view.getChildAt(1).getChildAt(0)
  local mNeutralButton = view.getChildAt(0)
  return view, mPositiveButton, mNegativeButton, mNeutralButton 
end

_M.createStackLayout = function()
  local view = loadlayout(LAYOUT_BUTTON_STACK)
  local mPositiveButton = view.getChildAt(0)
  local mNegativeButton = view.getChildAt(1)
  local mNeutralButton = view.getChildAt(2)
  return view, mPositiveButton, mNegativeButton, mNeutralButton 
end


return _M