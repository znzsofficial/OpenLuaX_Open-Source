require "import"
local bindClass = luajava.bindClass
local View         = bindClass "android.view.View"
local LinearLayout = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local TextView     = bindClass "androidx.appcompat.widget.AppCompatTextView"

local Builder = luajava.bindClass "androidx.appcompat.app.AlertDialog$Builder"
local ColorStateList = luajava.bindClass "android.content.res.ColorStateList"
local Typeface = luajava.bindClass "android.graphics.Typeface"
local COMPAT_R = luajava.bindClass "androidx.appcompat.R"
local MaterialShapeDrawable = luajava.bindClass "com.google.android.material.shape.MaterialShapeDrawable"
local MaterialButtonHelper = luajava.bindClass "com.google.android.material.button.MaterialButtonHelper"
local ViewCompat = luajava.bindClass "androidx.core.view.ViewCompat"
local ShapeAppearanceModel = luajava.bindClass "com.google.android.material.shape.ShapeAppearanceModel"
local loadlayout = require "loadlayout"
--local DEFAULT_TITLE_TYPEFACE = Typeface.DEFAULT_BOLD


local Button = require("vinx.material.dialog.MaterialDialog$Button")
local ActionLayout = require("vinx.material.dialog.MaterialDialog$ActionLayout")
local MaterialButton = Button.createButton

local dp2px = function(i)
  return activity.Resources.DisplayMetrics.density 
    * i + 0.5
end

local function TODO()
  error("One or more unimplemented properties are called. ", 0)
end
 
local TYPEFACE = Typeface.create("sans-serif-medium", 0)
local LAYOUT = {
  LinearLayout,
  paddingTop = "24dp",
  orientation = "vertical",
  {
    TextView,
    layout_width = "match",
    layout_height = "wrap",
    paddingStart = "24dp",
    paddingEnd = "24dp",
    textColor = 0xff000000,
    textSize = "20sp",
    typeface = TYPEFACE,
  },
  {
    TextView,
    layout_width = "match",
    layout_height = "wrap",
    paddingTop = "16dp",
    paddingStart = "24dp",
    paddingEnd = "24dp",
    paddingBottom = "20dp",
    textSize = "16sp",
    lineHeight = "22sp",
  },
}

local LAYOUT_BUTTON_FULLWIDTH = {

}

local VISIBLE = View.VISIBLE
local MARGIN = activity.Width > dp2px(600) 
  and dp2px(24) or dp2px(16)
local MAX_WIDTH = dp2px(560)
local MIN_WIDTH = dp2px(280)
local INCREMENT = dp2px(56)
-- The width is lower than the container width and is a multiple of 56dp.
local WIDTH = (activity.Width - MARGIN) // INCREMENT * INCREMENT

-- Min width is 280dp
if (activity.Width > MIN_WIDTH && WIDTH < MIN_WIDTH) then
  WIDTH = MIN_WIDTH
 -- If the container width is lower than 280dp, fill the container.
 elseif activity.Width < MIN_WIDTH then
  WIDTH = activity.Width
end
-- Max width is 560dp
local WIDTH = WIDTH > MAX_WIDTH and MAX_WIDTH or WIDTH
local BUTTON_MAX_WIDTH = (WIDTH - dp2px(24)) / 2

local RADIUS = dp2px(4)
local BACKGROUND = MaterialShapeDrawable(
  ShapeAppearanceModel())
.setFillColor(ColorStateList.valueOf(0xffffffff))
.setCornerSize(RADIUS)
--print(WIDTH)

local _M = {}
_M.POSITIVE = 1
_M.NEUTRAL = 0
_M.NEGATIVE = -1

_M.BUTTON_TEXT = 0
_M.BUTTON_OUTLINE = 1
_M.BUTTON_COLORED = 2

_M.MODE_NORMAL = 0
_M.MODE_STACK = 1
_M.MODE_FULLWIDTH = 2

local _Builder = {}

local function measureWidth(view)
  local w = View.MeasureSpec.makeMeasureSpec(0,
    View.MeasureSpec.UNSPECIFIED)
  return view.measure(w, 0).MeasuredWidth
end

local function checkForMode(t, text)
  if (measureWidth(MaterialButton(activity).setText(text)) 
   >= BUTTON_MAX_WIDTH) then
    t.layoutMode = _M.MODE_STACK
   else
    t.layoutMode = t.layoutMode or _M.MODE_NORMAL
  end
end

-- i: MaterialDialog$Builder
local function setAttributes(i, t)
  for k, v in pairs(t) do
    switch k do
     case "title"
      i:setTitle(v)
     case "message"
      i:setMessage(v) 

     -- Positive Button
     case "positiveButtonText"
      i.positiveButton.setVisibility(VISIBLE)
      i.positiveButton.setText(v)
     case "positiveButtonType"
      i:setPositiveButtonType(v)
     case "positiveButtonTint"
      i.positiveButtonType = t.positiveButtonType
      i:setPositiveButtonTint(v)
     case "positiveButtonTextColor"
      TODO()
     case "positiveButtonBackgroundColor"
      TODO()
     case "positiveButtonRippleColor"
      TODO()

     -- Negative Button
     case "negativeButtonText"
      i.negativeButton.setVisibility(VISIBLE)
      i.negativeButton.setText(v)
     case "negativeButtonType"
      i:setNegativeButtonType(v)
     case "negativeButtonTint"
      i.negativeButtonType = t.negativeButtonType
      i:setNegativeButtonTint(v)
     case "negativeButtonTextColor"
      TODO()
     case "negativeButtonBackgroundColor"
      TODO()
     case "negativeButtonRippleColor"
      TODO()

     -- Neutral Button
     case "neutralButtonText"
      i.neutralButton.setVisibility(VISIBLE)
      i.neutralButton.setText(v)
     case "neutralButtonType"
      i:setNeutralButtonType(v)
     case "neutralButtonTint"
      i.neutralButtonType = t.neutralButtonType
      i:setNeutralButtonTint(v)
     case "neutralButtonTextColor"
      TODO()
     case "neutralButtonBackgroundColor"
      TODO()
     case "neutralButtonRippleColor"
      TODO()

     case "onButtonClick"
      table.insert(i.onButtonClickListeners, v)

     case "fullWidthButton"
      TODO()
    end
  end 
end


--print(measureWidth(Button.createButton(this)))

function _Builder:setCornerRadius(r)
  self.window.setBackgroundDrawable(BACKGROUND)
  local lp = self.window.attributes
  lp.width = WIDTH
  self.window.setDimAmount(0.32)
  self.window.setElevation(dp2px(24))
  self.window.setAttributes(lp)
end

function _Builder:setTitle(str)
  self.titleView.setText(str)
end

function _Builder:setMessage(str)
  self.messageView.setText(str)
end


function _Builder:setPositiveButtonTint(color)
  Button.setButtonTint(self.positiveButton,
    self.positiveButtonType or _M.BUTTON_TEXT,
    color or 0xff6200ee)
end

function _Builder:setNegativeButtonTint(color)
  Button.setButtonTint(self.negativeButton,
    self.negativeButtonType or _M.BUTTON_TEXT,
    color or 0xff6200ee)
end

function _Builder:setNeutralButtonTint(color)
  Button.setButtonTint(self.neutralButton,
    self.neutralButtonType or _M.BUTTON_TEXT,
    color or 0xff6200ee)
end


function _Builder:setPositiveButtonType(i)
  self.positiveButtonType = i
end

function _Builder:setNegativeButtonType(i)
  self.negativeButtonType = i
end

function _Builder:setNeutralButtonType(i)
  self.neutralButtonType = i
end



_Builder.__call = function(self, t)
  local mRootView = loadlayout(LAYOUT)
  self.titleView = mRootView.getChildAt(0)
  self.messageView = mRootView.getChildAt(1)
  self.onButtonClickListeners = {}

  checkForMode(self, t.positiveButtonText)
  checkForMode(self, t.negativeButtonText)
  checkForMode(self, t.neutralButtonText)

  local _view  
  switch self.layoutMode do
   case _M.MODE_NORMAL
    _view, self.positiveButton, self.negativeButton,
      self.neutralButton = ActionLayout.createNormalLayout()
   case _M.MODE_STACK
    _view, self.positiveButton, self.negativeButton,
      self.neutralButton = ActionLayout.createStackLayout()
  end
  mRootView.addView(_view)

  local dialog = Builder(this)
  .setView(mRootView, 0, 0, 0, 0)

  setAttributes(self, t)
  dialog = dialog.create()

  self.positiveButton.onClick = function()
    for k, v in ipairs(self.onButtonClickListeners) do
      v(_M.POSITIVE)
    end
    dialog.dismiss()
  end

  self.negativeButton.onClick = function()
    for k, v in ipairs(self.onButtonClickListeners) do
      v(_M.NEGATIVE)
    end
    dialog.dismiss()
  end

  self.neutralButton.onClick = function()
    for k, v in ipairs(self.onButtonClickListeners) do
      v(_M.NEUTRAL)
    end
    dialog.dismiss()
  end


  dialog.show()
  _Builder.setCornerRadius(dialog, dp2px(4))
  return dialog
end

_M.Builder = setmetatable(_Builder, _Builder)

return setmetatable(_M, _M)