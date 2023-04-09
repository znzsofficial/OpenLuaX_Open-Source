require "import"
import "android.os.Build$VERSION"
import "android.graphics.Typeface"
import "android.text.Spannable"
import "android.text.SpannableString"
import "android.text.style.ForegroundColorSpan"
import "android.text.style.AbsoluteSizeSpan"
import "android.text.style.TypefaceSpan"
--import "github.daisukiKaffuChino.utils.LuaThemeUtil"
import "vinx.view.util.UiUtils"

import "loadlayout"

local _M = {}

_M.TITLE_ID = 99

-- 设置头部标题
_M.setHeaderTitle = function(popup, str, color)
  local str = SpannableString(str)
  .setSpan(
    ForegroundColorSpan(color),--LuaThemeUtil(activity).ColorPrimary), -- 设置颜色
    0, #str, Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
  .setSpan(
    AbsoluteSizeSpan(UiUtils.sp2px(14)), -- 微调字号
    0, #str, Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
    
  if VERSION.SDK_INT >= 29 then -- Android Q 开始可以使用 Typeface 对象
    str.setSpan(
      TypefaceSpan(Typeface.DEFAULT_BOLD),
      0, #str, Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
  end

  popup.Menu.add(_M.TITLE_ID, _M.TITLE_ID, 0, str)
  popup.Menu.setGroupEnabled(_M.TITLE_ID, false) -- 禁止点击 item
   
 --[[ import "androidx.appcompat.widget.LinearLayoutCompat"
  import "com.google.android.material.textview.MaterialTextView"
  local item = popup.mPopup.ListView.Adapter.getItem(0)
  item.setActionView(loadlayout{
    LinearLayoutCompat,
    {
      MaterialTextView,
      text="strh",
    }
  })]]
 -- item.setEnabled(false)
--  popup.mPopup.Popup.setHeight(999)
end

-- 设置字体
_M.setMenuTypeface = function(popup, typeface)
  
end

-- 加载边距协调的图标文件
_M.loadMaterializeIcon = function(path)
 
end

return _M