local _M={}

_M.getUpdateLog=function()
  local log = [[
1.5.2
修复布局助手
小改了一下ExtendedEditText
移除旧LuaMaterialDialog
  
1.5.1 fix
LuaAdapter使用Glide加载图片
修复一个bug
优化文件列表显示
  
1.5.0
更新依赖
新增 LuaFragmentAdapter
修复 Logcat 异常
 
1.4.9
修复bin.lua无法处理DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION的问题
一些性能优化
  
1.4.8
优化import和loadlayout
  
1.4.7
优化 导入分析和java浏览器
修复一个bug
  
1.4.6
更新LuaDiffRecyclerAdapter
优化部分页面
  
1.4.5
loadlayout应该能正常用了
减少了一些没必要的默认导包
  
1.4.4
修复loadlayout
src和background以/开头时才会从当前luadir加载图片(划掉

1.4.3
修复CrashHandler
  
1.4.2
更新LuaThemeUtil
修复一个bug
优化java浏览器布局

1.4.1
迁移LuaFragment和LuaPreferenceFragment到AndroidX
优化java浏览器
  
1.4.0
试图修复一些bug
更新依赖
  
1.3.9
新增杰西的LuaMaterialDialog
  
1.3.8
移除对SimpLua的检测
优化一些文件操作
更新依赖

1.3.7
更新 Rawio->1.0.2
润了
  
1.3.6 fix
新增 两个Compat主题并作为默认主题
修复 若干bug
移除SplashScreen依赖，因为用不到😥
移除RippleHelper

1.3.5
修bug...

1.3.4
回退 上个版本对LuaActivity的修改
回退 使用旋律的rawio
回退 移除标签栏关闭全部选项
修复 若干bug
为了保证数据安全了属于是😭
  
1.3.3
修改 LuaActivity
新增 AppTheme_Material3_DynamicColors主题
回退了一点对loadlayout的修改

1.3.2
优化 文件列表效率
新增 LuaFileSystem库(1.8.0)(感谢@MostBlack)
修改 进一步迁移LuaActivity到AndroidX
  
1.3.1
新增 LuaLayoutInflater(RippleLua)
移除 LuaActivity的Xposed检测
移除 ScreenCaptureActivity
修改 CrashHandler,日志保存到私有目录(实验性)
修改 Welcome实现(稍微)
修改 getLuaState -> getOpenLuaState
更新 Rawio 1.0.1(@Most Black)

1.3.0
更新 MDC,Glide,一些AndroidX组件
优化 loadlayout

1.2.9
更新了一下AndroidX
CrashLogViewer崩了好几个版本居然没人发现
  
1.2.8
修复 若干bug
优化 loadlayout(注意减少了几个默认导入控件)
增加 不使用glide的oldloadlayout(需要手动导入)

1.2.7
修复 一个bug
小改了一下import和loadlayout
移除了重复的class和Layout模块

1.2.6
主要是设置更新...
loadlayout使用Glide加载src和background
  
1.2.5
忘了更新了什么了...
增加了一个设置
布局助手新增若干控件
  
1.2.4
更新 Java浏览器
优化 布局助手
  
1.2.3
修复 TextInputLayout指针错位
修复 若干bug
新增 class模块(方便我自己用)
优化 工程查找效率
优化 文件列表
  
1.2.2
当前打开工程跟随tab
突然发现so一直没换5022的(
java浏览器加载libs文件夹内dex(好像问题很大)
修复了几个bug

1.2.1
打包时编译alyx和luax文件
更换java浏览器(修改自@执笔画妳)
一些细节修改

1.2.0
更新RippleLua库
修了一点点问题
  
1.1.9
新增Layout,jpairs模块(RippleLua+)
移除autotheme
支持更多文件格式
Java浏览器+0.1%

1.1.8
一些感知不强的改动

1.1.7
新增TypefaceSpanCompat(vinx)
新增LuaDiffRecyclerAdapter(dingyi)
修改LuaActivity
移除百度统计

1.1.6
新增ReOpenLua主题
LuaActivity新增switchDayNight方法
  
1.1.5
尝试使用Glide加载文件列表图片(无效)
完善标签栏
新Java浏览器进度推进了一点点
修改com.open.lua.widget.PhotoView
  
1.1.4
优化文件列表效率

1.1.3
同下👇

1.1.2
修复若干Bug
继续完善标签栏

1.1.1
完善标签栏操作

1.1
勉强实现TabLayout标签栏
强行解决new.lua弹窗

1.0.6
调整侧边栏布局

1.0.5
布局调整
新增LuaRecyclerAdapter(RippleLua+)

1.0.4
修改LuaEditor(隐藏报错提示,更换字体)

1.0.3
修复 若干Bug
  
1.0.2
继续修bug

1.0.1
修复 若干Bug

1.0
初版

依赖：
Material 1.9.0
AppCompat 1.7.0-alpha02
Glide 4.15.1
zip4j 2.11.5
  ]]
  return log
end

_M.getIntroduction=function()
  local int=[[       基于AndroLua+ 5.0.22修改，此项目已迁移到AndroidX和AppCompat，替换更多Jetpack组件，一些过时的非标准库已被移除，请自行寻找替代方案。
       OpenLuaX+内置最新AppCompat库与MDC，内置主题见Java浏览器。
       致谢AndroLuaX+(杰西)，ReOpenLua+(智乃)，OpenLua+(yuxuan)开源项目
       @智商封印official
       用户使用协议：请勿编写恶意软件损害他人，本软件作者不对使用本软件造成的任何直接或间接损失负责。继续使用表示您同意上述协议。

]]
  return int
end

return _M