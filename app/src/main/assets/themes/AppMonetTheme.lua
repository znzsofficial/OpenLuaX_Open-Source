MDC_R=luajava.bindClass"com.google.android.material.R"
activity.theme=MDC_R.style.Theme_Material3_DynamicColors_DayNight
import "github.daisukiKaffuChino.utils.LuaThemeUtil"
themeUtil=LuaThemeUtil(this)
accentColor=themeUtil.ColorAccent
errorColor=themeUtil.ColorError
outlineColor=themeUtil.ColorOutline
surfaceColor=themeUtil.ColorSurface
surfaceColorVar=themeUtil.ColorSurfaceVariant
backgroundc=themeUtil.ColorBackground
onbackgroundc=themeUtil.ColorOnBackground
primaryColor=themeUtil.ColorPrimary
secondaryColor=themeUtil.ColorSecondary
tertiaryc=themeUtil.ColorTertiary

----------------------------------------------
--AppM3Theme/MaterialYou
----------------------------------------------

状态栏背景色 = primaryColor
标题栏背景色 = 状态栏背景色
侧滑栏背景色 = backgroundc
标题文字颜色 = onbackgroundc
副标题文字颜色 = onbackgroundc
图标着色 = primaryColor
背景色 = backgroundc
编辑器背景色 = backgroundc
次主题色= tertiaryc
surfaceColorIn=状态栏背景色

BasewordColor=次主题色
--关键字
KeywordColor=secondaryColor
--注释
CommentColor=outlineColor
--变量
UserwordColor=状态栏背景色
--字符串
StringColor=errorColor

return MDC_R.style.Theme_Material3_DynamicColors_DayNight