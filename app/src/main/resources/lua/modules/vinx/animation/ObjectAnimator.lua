local ObjectAnimator = luajava.bindClass "android.animation.ObjectAnimator"
local ObjectAnimatorUtils = luajava.bindClass "androidx.transition.ObjectAnimatorUtils"
local getType = type

local _M = {
  TYPE_ARGB = "argb",
  TYPE_FLOAT = "float",
  TYPE_INT = "int",
  TYPE_MULTI_FLOAT = "multiFloat",
  TYPE_MULTI_INT = "multiInt",
  TYPE_OBJECT = "object",
  TYPE_POINT_F = "pointF",
  TYPE_PROPERTY_VALUES_HOLDER = "propertyValuesHolder",

  ofArgb = ObjectAnimator["ofArgb"],
  ofFloat = ObjectAnimator["ofFloat"],
  ofInt = ObjectAnimator["ofInt"],
  ofMultiFloat = ObjectAnimator["ofMultiFloat"],
  ofMultiInt = ObjectAnimator["ofMultiInt"],
  ofPropertyValuesHolder = ObjectAnimator["ofPropertyValuesHolder"],
}

pcall(function()
  _M.ofPointF = ObjectAnimatorUtils["ofPointF"]
end)

local METHODS = {
  argb = "ofArgb", float = "ofFloat", int = "ofInt",
  multiFloat = "ofMultiFloat", multiInt = "ofMultiInt",
  object = "ofObject", pointF = "ofPointF",
  propertyValuesHolder = "ofPropertyValuesHolder"
}

_M.__call = function(self, t) 
  local type = METHODS[t.type]
  local target = t.target
  local xProperty = t.xProperty or t.property
  local yProperty = t.yProperty
  local converter = t.converter
  local evaluator = t.evaluator
  local values = t.values

  if t[1] then
    if t[5] then
      target = t[1]
      xProperty = t[2]
      converter = t[3]
      evaluator = t[4]
      values = t[5]
     elseif t[4] then
      if t.type == _M.TYPE_OBJECT then
        target = t[1]
        xProperty = t[2]
        converter = t[3]
        values = t[4]
       else 
        target = t[1]
        xProperty = t[2]
        yProperty = t[3]
        values = t[4]
      end
     elseif t[3] then
      target = t[1]
      xProperty = t[2]
      values = t[3]
     elseif t[2] then
      target = t[1]
      values = t[2]
    end
  end

  if getType(values) ~= "table" then
    values = {values}
  end 
 
  local animator

  if (converter && evaluator) then
    animator = ObjectAnimator[type]
      (target, xProperty, converter,
        evaluator, values)
 
   elseif (t.type == _M.TYPE_OBJECT &&
   (converter || evaluator)) then     
    animator = ObjectAnimator[type]
      (target, xProperty, converter or evaluator, values)

   elseif xProperty and yProperty then
    animator = ObjectAnimator[type]
      (target, xProperty, yProperty, values)

   elseif (t.type == _M.TYPE_POINT_F && xProperty) then
    animator = ObjectAnimatorUtils[type]
      (target, xProperty, values)

   elseif xProperty then
    animator = ObjectAnimator[type]
      (target, xProperty, values)

   else 
    animator = ObjectAnimator[type]
      (target, values)
  end

  for k, v in pairs(t) do
    switch k do
     case "autoCancel"
      animator.setAutoCancel(v)
     case "duration"
      animator.setDuration(v)
     case "durationScale"
      animator.setDurationScale(v)
     case "frameDelay"
      animator.setFrameDelay(v)
     case "currentFraction" 
      animator.setCurrentFraction(v)
     case "currentPlayTime" 
      animator.setCurrentPlayTime(v)
     case "evaluator" 
      if t.type ~= _M.TYPE_OBJECT then
       animator.setEvaluator(v)
      end
     case "interpolator" 
      animator.setInterpolator(v)
     case "repeatCount"
      animator.setRepeatCount(v)
     case "repeatMode"
      animator.setRepeatMode(v)
     case "startDelay"
      animator.setStartDelay(v)
     case 1, 2, 3, 4, 5, "target", "property", "xProperty",
      "yProperty", "converter", "values", "type", "start"
     default 
      error(tostring(animator)
        ..": ObjectAnimator does not support the property: "
        ..k, 0)
    end
  end

  if t.start then
    animator.start()
  end
  return animator
end

setmetatable(_M, _M)

return _M