local _M = {}

_M.sp2px = function(i)
  return TypedValue.applyDimension(
  TypedValue.COMPLEX_UNIT_SP, i,
  activity.Resources.DisplayMetrics
  )
end

_M.dp2px = function(i)
  local scale = activity.getResources().getDisplayMetrics().density
  return Math.round(i * scale)
end

_M.isNightMode = function()
  _,Re=xpcall(function()
    local Configuration=luajava.bindClass"android.content.res.Configuration"
    currentNightMode = activity.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK
    return currentNightMode == Configuration.UI_MODE_NIGHT_YES--夜间模式启用
    end,function()
    return false
  end)
  return Re
end

return _M