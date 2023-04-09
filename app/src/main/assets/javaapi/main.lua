require "import"
import "android.widget.*"
import "android.view.*"
import "android.app.*"
import "android.os.Build"
import "android.content.*"
import "android.text.SpannableString"
import "android.text.style.ForegroundColorSpan"
import "android.animation.ObjectAnimator"
import "android.view.animation.DecelerateInterpolator"
import "android.animation.Animator$AnimatorListener"
import "android.view.ViewGroup$LayoutParams"
import "com.google.android.material.textfield.TextInputEditText"
import "com.google.android.material.textfield.TextInputLayout"
import "jpairs"
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
primaryOnColor=themeUtil.ColorOnPrimary
secondaryColor=themeUtil.ColorSecondary
tertiaryc=themeUtil.ColorTertiary

activity.getWindow()
.setStatusBarColor(primaryColor)
.setNavigationBarColor(primaryColor)

class = require "modules.class"
OutlinedTextInputLayout=class{
  name="material.OutlinedTextInputLayout",
  extends=TextInputLayout,
  constructor=function(super,context,attrs,defStyle)
    defStyle=MDC_R.style.Widget_Material3_TextInputLayout_OutlinedBox
    return super(luajava.bindClass"androidx.appcompat.view.ContextThemeWrapper"(context,defStyle),attrs,defStyle)
    .setBoxBackgroundMode(2)
  end,
  fields={
    boxCornerRadius=0,
  },
  methods={
    getBoxCornerRadius=function(view)
      return view.boxCornerRadius
    end,
    setBoxCornerRadius=function(view,radius)
      view.boxCornerRadius=radius
      view.setBoxCornerRadii(radius,radius,radius,radius)
      return view
    end,
  },
}
OutlinedTextInputEditText=class{
  name="material.OutlinedTextInputEditText",
  extends=TextInputEditText,
  constructor=function(super,context,attrs,defStyle)
    return super(OutlinedTextInputLayout(context).context)
  end,
}

import "layout"
--沉浸栏背景色、标题背景色、主背景色
co={primaryColor,onbackgroundc,primaryOnColor}
local st = require("socket")
import "eee/ee"
activity.setContentView(layout)
ta=require "android"
vl=luajava.luadir.."/android.lua"

luadir=...

function fz(a)
  if a:find("无法获取") then
    print(a)
    return
  end
  activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(a)
  local aa=a.."已复制"
  Toast.makeText(activity,aa, Toast.LENGTH_LONG).show()
end


function 外部dex类()--eee/libs目录下dex
  --外部dex类不写入类库
  import "java.io.File"
  import "dalvik.system.DexFile"
  --local a=activity.getPackageCodePath()o_path.."/
  local aa=luadir.."/libs/"
  local bb
  --目录文件列表
  xpcall(function()
    bb=luajava.astable(File(aa).listFiles())
    end,function()
    bb=luajava.astable(File(activity.getLuaDir("/eee/libs")).listFiles())
  end)
  --dex文件列表
  local cc={}
  --dex类列表
  local tab = {}
  --过滤文件夹和其它文件
  for i=1,#bb do
    if not bb[i].isDirectory() and tostring(bb[i]):match(".*%.(.*)")=="dex" then
      table.insert(cc,bb[i])
    end
  end

  if #cc >=1 then
    local a = st.gettime()
    for i=1,#cc do
      local dexFile=DexFile(tostring(cc[i]))
      local classNames=dexFile.entries()
      while(classNames.hasMoreElements())
        local name = classNames.nextElement();
        if not table.find(tab,name)then
          table.insert(tab,name)
        end
      end
    end
    --print("dex类解析\n耗时"..string.format("%.3f",(st.gettime()-a)).."秒")
  end

  return tab
end



clist.onItemLongClick=function(l,v)
  fz(v.Text)
  return true
end

clist.onItemClick=function(l,v)
  activity.newActivity("eee",{v.Text,ss,co})
  return true
end

function 列表(t,s)
  local ar=ArrayAdapter(activity,17367043)
  if s then
    ar.clear()
    for k,v in ipairs(t) do
      local aa,bb= utf8.find(v:lower():gsub([[%$]],[[.]]),s,1,true)
      ar.add(SpannableString(v).setSpan(ForegroundColorSpan(primaryColor),aa-1 ,bb,34))
    end
   else
    ar.clear()
    for k,v in ipairs(t) do
      ar.add(v)
    end
  end
  clist.setAdapter(ar)

end

edit.addTextChangedListener{

  onTextChanged=function(a,b,c,d)
    local a=tostring(a)
    if a:len()<=2 and ((b==0 and c ==1 and d==0) or (b==0 and c==0 and d==1))then
      return
    end

    local int = tonumber(a)
    if int and #a == 3 then
      edit.Text = ""
      指令集(int)
      return
    end

    --[[添加新类--
    if #a >= 1 and pcall(function()import(a)end) and not table.find(ta,a)then
      table.insert(ta,a)
      table.insert(clisttab,a)
      列表(clisttab)
      io.open(vl,"w"):write(dump(ta)):close()
      edit.Hint = "共计"..#clisttab.."类"
      print("已自动添加新类")
    end]]
    --+--
    local s=a:gsub([[%$]],[[.]]):lower()
    local t={}

    if s:len() < 2 then
      列表(clisttab)
     else
      for k,v in ipairs(clisttab) do
        if v:lower():gsub([[%$]],[[.]]):find(s,1,true) then
          table.insert(t,v)
        end
      end
      列表(t,s)
    end
  end
}



--自带类表
local baseclass=ta
--dex类表
local dexclass = 外部dex类()
--合并类表
local mergeclass = tabMerge(baseclass,dexclass)

function listClass(int)
  int = tostring(int)
  switch(int)
   case "111"
    return baseclass
   case "222"
    return dexclass
   case "333"
    return mergeclass
   default
    return mergeclass
  end
end

function 列表切换(int,bool)
  clisttab =listClass(int)
  列表(clisttab)
  edit.Text = ""
  editlay.Hint = "共计"..#clisttab.."类"
  if bool then--初始化时不显示提示
    print "列表切换完成"
  end
end

列表切换(333)--初始化列表

function onResult(a,b)
  edit.Text=b
  edit.setSelection(b:len())
end


--[[
function 菜单()
  local cdf = loadlayout(
  {
    AbsoluteLayout;
    background="#A33D7BFF";
    layout_height="216dp";
    layout_width="80dp";
    id="cdf",
    x=tv2.x+60,
    y=80
  }
  )

  ll.addView(cdf)

  cds={}
  local cdname={"指令集","菜单二","菜单三","菜单四","菜单五"}
  for i=1,5 do

    local cd = loadlayout(
    {
      TextView;
      textSize="21sp";
      text=cdname[i];
      id="cd"..i;
      textColor="#FFFFFFFF";
      background="#FF009989";
      x=tv2.x -50,
      Visibility=8;
    }
    )
    table.insert(cds,cd)
    ll.addView(cd)
  end
end
]]

--[[
        在搜索框输入数字指令以执行对应功能。
        指令集:
        111 > 显示内置类库列表
        222 > 显示外置dex类列表
        333 > 显示全部列表
        444 > 内置类库重复类清除
        555 > 内置类库校验        
        ]]

function 内裤校验(t)
  local int = 0
  local iny = 0
  local talen= #t

  local ti=Ticker()
  ti.Period=0
  ti.onTick=function()
    int = int + 1

    if int >= talen then
      ti.stop()
      if iny >= 1 then
        print("已清除"..iny.."无效类")
        io.open(vl,"w"):write(dump(ta)):close()
      end
      --tv1.Text = "安卓API浏览器"
    end

    local ss =ta[int]
    if ss then
      --tv1.Text = "进度("..int.."/"..talen..") 败类("..iny..")"
      if not pcall(function()luajava.bindClass(ss)end)then
        table.remove(ta,int)
        iny = iny + 1
      end
    end

  end
  ti.start()
end

function 重复清除(t)
  local tab = table.unique(t,true)
  table.sort(tab)
  io.open(vl,"w"):write(dump(tab)):close()
  print("已清除( "..(#ta-#tab).." )重复类")
end


function 指令集(int)
  int = tostring(int)
  switch(int)
   case "111"
    列表切换(int,true)
   case "222"
    列表切换(int,true)
   case "333"
    列表切换(int,true)
   case "444"
    重复清除(ta)
   case "555"
    内裤校验(ta)
  end
end

--[[
安卓浏览器重制版

搜索时在结果列表中高亮显示搜索的字符。

二级列表分类显示，可以更便捷的浏览到想要的类别。

搜索内容不限大小写，搜索过程中符号“$” 符号可视为 “.”，

二级列表中搜索“ set、get、add、is”等常用方法时默认名前面加“.”，
以更准确的定位到期望搜索内容。

去除异常方法显示。

简化部分过长且无实际阅览价值的前缀名，
例:
java.lang.String → String
 android.view.View → View
 ......
 2.6更新内容
 1、修复读取外部dex时报错
 2、修复类列表过长时点击列表闪退
 3、增加输入框指令集
 4、选中查询时如果选中的是一个完整类名时跳转到类浏览界面,反之则返回到类名搜索界面。
 
  2.5更新内容
  1、新增可读取外部dex类，将dex放入eee\libs文件夹内即可。
  2、新增类列表搜索栏输入新的类时自动存入类库。
  3、Spinner优化
  
 2.4更新内容
 1、方法栏增加Spinner控件，可根据public类型筛选目标方法。
 2、优化多item时进去响应速度。
 
 2.3更新内容
 1、优化+修复bug。
 
 2.2更新内容
 1、将父类继承栏更名为继承关系，加入子类与父类类名。
 2、修复一个本类方法显示简化的判断错误。
 3、打开继承关系栏时自动添加新的类名到类表。

 2.1更新内容
1、支持含有中文的类名
2、搜索时输入或删除第1个字节时不执行搜索事件，
避免单字节时匹配到过多不期望的搜索结果和减少卡顿
3、优化选中查询时光标处于查询内容后
4、快捷搜索增加boolean关键词(搜索时输入bo即可)，
将快捷搜索限于公有方法列表。
4、其它调整
]]


--by:执笔画妳

