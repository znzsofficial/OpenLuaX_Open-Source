require "import"
import "android.widget.*"
import "android.view.*"
import "android.app.*"
import "android.graphics.drawable.ColorDrawable"
import "android.net.Uri"
import "rawio"

theme = ...
import ("themes."..theme)
activity.setTitle('Lua参考文档')
MDC_R=luajava.bindClass"com.google.android.material.R"
activity.theme=MDC_R.style.Theme_Material3_DynamicColors_DayNight

activity.getSupportActionBar()
.setDisplayShowHomeEnabled(true)
.setDisplayHomeAsUpEnabled(true)
activity.getWindow()
.setStatusBarColor(状态栏背景色)
.setNavigationBarColor(状态栏背景色)

function onOptionsItemSelected(m)
switch m.getItemId() do
   case android.R.id.home
    activity.finish()
  end
end

activity.setContentView(loadlayout({
  LinearLayout;
  layout_width="-1";
  layout_height="-1";
  orientation="vertical";
  {
    LuaWebView;
    id="WebView";
    layout_width="-1";
    layout_height="-1";
    BackgroundColor=背景色,
  };
}))

WebView.loadUrl(activity.getLuaDir() .. "/luadoc/manual.html")

WebView.setWebViewClient({
  onPageFinished = function(view,url)
    function isNightMode()
      local configuration = activity.getResources().getConfiguration();
      return configuration.uiMode+1==configuration.UI_MODE_NIGHT_YES or configuration.uiMode-1==configuration.UI_MODE_NIGHT_YES or configuration.uiMode==configuration.UI_MODE_NIGHT_YES
    end
    if isNightMode() then
      local WebSettings=luajava.bindClass"android.webkit.WebSettings"
      WebView.getSettings().setForceDark(WebSettings.FORCE_DARK_ON) end
  end
})

WebView.onLongClick = function()
  return true
end