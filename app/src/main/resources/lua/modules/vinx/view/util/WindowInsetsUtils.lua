require "import"
import "androidx.core.view.ViewCompat"
import "androidx.core.view.WindowCompat"
import "androidx.core.graphics.ColorUtils"

local window = activity.Window
local controller = ViewCompat.getWindowInsetsController(
  activity.findViewById(android.R.id.content))

_M = {}

_M.setLightStatusBar = function(bool)
  controller.setAppearanceLightStatusBars(bool)
end

_M.setStatusBarColor = function(color)
  window.setStatusBarColor(color)
  if ColorUtils.calculateLuminance(color) >= 0.5 then
    _M.setLightStatusBar(true)
   else
    _M.setLightStatusBar(false)
  end
end

_M.setNavigationBarColor = function(color)
  window.setNavigationBarColor(color)
end

_M.setDecorFitsSystemWindows = function(bool)
  WindowCompat.setDecorFitsSystemWindows(window, bool)
end

_M.getStatusBarHeight = function()
  local id = this.Resources.getIdentifier(
    "status_bar_height", "dimen", "android")
  return this.Resources.getDimensionPixelSize(id)
end

return _M