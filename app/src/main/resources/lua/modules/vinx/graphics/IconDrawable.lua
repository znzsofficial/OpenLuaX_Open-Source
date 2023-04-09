require "import"
import "android.util.TypedValue"
import "android.graphics.PorterDuff"
import "android.graphics.PorterDuffColorFilter"
import "android.graphics.drawable.BitmapDrawable"
import "android.graphics.Bitmap"
import "android.graphics.Matrix"--- 获取本地图标Drawable的函数

return function(image, color, viewSizeDp)
  local colorFilter
  if color ~= "none" and color ~= 0 and color ~= nil then
    colorFilter = PorterDuffColorFilter(
      color or 0xff5f6368, PorterDuff.Mode.SRC_ATOP)
  end
  local bitmap = LuaBitmap
    .getLocalBitmap(activity.LuaDir.."/images/"..image)
  local size = bitmap.Width
  local viewSizeDp = viewSizeDp or 24
  local r = activity.Resources.DisplayMetrics
  local scale = TypedValue.applyDimension(
    TypedValue.COMPLEX_UNIT_DIP, viewSizeDp, r) / size
  local matrix = Matrix()
  matrix.postScale(scale, scale)  
 -- print(size.."/"..scale)

  local bitmap = Bitmap.createBitmap(
    bitmap, 0, 0, size, size, matrix, true)
  return BitmapDrawable(activity.Resources, bitmap)
    .setColorFilter(colorFilter)
end
