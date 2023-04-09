local _M = {}

local bindClass = luajava.bindClass
local MDC_R               = bindClass "com.google.android.material.R"
local MaterialButton      = bindClass "com.google.android.material.button.MaterialButton"
local ColorStateList      = bindClass "android.content.res.ColorStateList"
local Color               = bindClass "android.graphics.Color"
local ANDROID_R           = bindClass "android.R"
local ContextThemeWrapper = bindClass "androidx.appcompat.view.ContextThemeWrapper"


local function dp2px(i)
  return activity.Resources.DisplayMetrics.density 
    * i + 0.5
end

local function setColorAlpha(color, alpha)
  local color = Color.valueOf(color)
  return Color.argb(color.alpha() * alpha, color.red(),
    color.green(), color.blue())
end


local STYLE = MDC_R.style.Widget_MaterialComponents_Button_TextButton_Dialog
local ENABLED = ANDROID_R.attr.state_enabled
local PRESSED = ANDROID_R.attr.state_pressed
local FOCUSED = ANDROID_R.attr.state_focused
local HOVERED = ANDROID_R.attr.state_hovered
local COLOR_DISABLED_BACKGROUND = setColorAlpha(0xff000000, 0.12)
local COLOR_DISABLED_TEXT = setColorAlpha(0xff000000, 0.38)

local BUTTON_TEXT = 0
local BUTTON_OUTLINE = 1
local BUTTON_COLORED = 2

function _M.setButtonTextColor(button, color)
  local list = ColorStateList(
    {{ENABLED}, {}},
    {color, COLOR_DISABLED_TEXT}
  ) 
  button.setTextColor(list)
end


function _M.setButtonBackgroundColor(button, color)
  local list = ColorStateList(
    {{ENABLED}, {}},
    {color, COLOR_DISABLED_BACKGROUND}
  ) 
  button.setSupportBackgroundTintList(list)
end


function _M.setButtonRippleColor(button, color)
  local list = ColorStateList(
    {
      {PRESSED}, {FOCUSED, HOVERED},
      {FOCUSED}, {HOVERED}, {}
    },
    {
      setColorAlpha(color, 0.24),
      setColorAlpha(color, 0.4),
      setColorAlpha(color, 0.4),
      setColorAlpha(color, 0.4),
      setColorAlpha(color, 0.24)
    }
  )
  button.setRippleColor(list)
end


function _M.setButtonTint(button, type, color)
  switch type do
   case BUTTON_TEXT
    _M.setButtonBackgroundColor(button, 0)
    _M.setButtonRippleColor(button, color)
    _M.setButtonTextColor(button, color)
   case BUTTON_OUTLINE
    _M.setButtonBackgroundColor(button, 0)
    _M.setButtonRippleColor(button, color)
    _M.setButtonTextColor(button, color)
    button.setStrokeWidth(dp2px(1))
    button.setStrokeColor(ColorStateList.valueOf(0xffe0e0e0))
   case BUTTON_COLORED
    _M.setButtonBackgroundColor(button, color)
    _M.setButtonRippleColor(button, 0xffffffff)
    _M.setButtonTextColor(button, 0xffffffff)
  end
end


function _M.createButton(context)
  local view = MaterialButton(
    ContextThemeWrapper(context, STYLE),
    nil, STYLE)
  view.setInsetTop(0)
  view.setInsetBottom(0)
  view.setSingleLine(false)
  view.setAllCaps(true)
  _M.setButtonBackgroundColor(view, 0)
  _M.setButtonRippleColor(view, 0xff6200ee)
  _M.setButtonTextColor(view, 0xff6200ee)
  return view
end

return _M

--return setmetatable(_M, _M)