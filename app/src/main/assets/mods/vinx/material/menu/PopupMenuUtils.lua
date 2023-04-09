require "import"
import{
  "android.os.Build$VERSION",
  "android.text.Spannable",
  "android.text.SpannableString",
  "android.text.style.ForegroundColorSpan",
  "android.text.style.AbsoluteSizeSpan",
  "android.text.style.TypefaceSpan",
  "mods.vinx.view.util.UiUtils"
}

local _M = {}

_M.TITLE_ID = 99

_M.setHeaderTitle = function(popup, str)
  local str = SpannableString(str)
  str.setSpan(
  ForegroundColorSpan(primaryColor), -- 设置颜色
  0, #str, Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
  str.setSpan(
  AbsoluteSizeSpan(UiUtils.sp2px(16)), -- 微调字号
  0, #str, Spannable.SPAN_EXCLUSIVE_INCLUSIVE)

  if VERSION.SDK_INT >= 29 then -- Android Q 开始可以使用 Typeface 对象
    str.setSpan(
    TypefaceSpan(Typeface.DEFAULT_BOLD),
    0, #str, Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
  end

  popup.Menu.add(_M.TITLE_ID, _M.TITLE_ID, 0, str)
  popup.Menu.setGroupEnabled(_M.TITLE_ID, false) -- 禁止点击 item
end

_M.setMenuTypeface = function(popup, typeface)

end

_M.loadMaterializeIcon = function(path)

end

return _M