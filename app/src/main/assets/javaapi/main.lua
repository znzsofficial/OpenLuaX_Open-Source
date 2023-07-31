require "import"
import "android.widget.*"
import "android.view.*"
import "android.app.*"
import "android.os.Build"
import "android.content.*"
import "android.graphics.drawable.ColorDrawable"
import "android.text.SpannableString"
import "android.text.style.ForegroundColorSpan"
import "android.animation.ObjectAnimator"
import "android.view.animation.DecelerateInterpolator"
import "android.animation.Animator$AnimatorListener"
import "android.view.ViewGroup$LayoutParams"
import "com.google.android.material.textfield.TextInputEditText"
import "com.google.android.material.textfield.TextInputLayout"
import "jpairs"
local MDC_R=luajava.bindClass"com.google.android.material.R"
activity.setTheme(MDC_R.style.Theme_Material3_DynamicColors_DayNight)
import "github.daisukiKaffuChino.utils.LuaThemeUtil"
local themeUtil=LuaThemeUtil(this)
local accentColor=themeUtil.ColorAccent
local errorColor=themeUtil.ColorError
local outlineColor=themeUtil.ColorOutline
local surfaceColor=themeUtil.ColorSurface
local surfaceColorVar=themeUtil.ColorSurfaceVariant
local backgroundc=themeUtil.ColorBackground
local onbackgroundc=themeUtil.ColorOnBackground
local primaryColor=themeUtil.ColorPrimary
local primaryOnColor=themeUtil.ColorOnPrimary
local secondaryColor=themeUtil.ColorSecondary
local tertiaryc=themeUtil.ColorTertiary
local table = table
activity
.getSupportActionBar()
.setElevation(0)
.setBackgroundDrawable(ColorDrawable(backgroundc))
.setDisplayShowHomeEnabled(true)
.setDisplayHomeAsUpEnabled(true)

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
import "eee/util"
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
          tab[#tab+1]=name
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


local Executors = luajava.bindClass"java.util.concurrent.Executors"
local Handler = luajava.bindClass"android.os.Handler"
local Looper = luajava.bindClass"android.os.Looper"
local mainLooper = Looper.getMainLooper()
local handler = Handler(mainLooper)

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
      local executor = Executors.newSingleThreadExecutor()
      executor.execute(function()
          for k,v in ipairs(clisttab) do
            if v:lower():gsub([[%$]],[[.]]):find(s,1,true) then
              table.insert(t,v)
            end
          end
          handler.post(function()
              列表(t,s)
            end
          )
        end
      )
      executor.shutdown()
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

local function changeList(int,bool)
  clisttab =listClass(int)
  列表(clisttab)
  edit.Text = ""
  editlay.Hint = "共计"..#clisttab.."类"
  if bool then--初始化时不显示提示
    print "changeList完成"
  end
end

changeList(333)--初始化列表

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

function 类库校验(t)
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
    changeList(int,true)
   case "222"
    changeList(int,true)
   case "333"
    changeList(int,true)
   case "444"
    重复清除(ta)
   case "555"
    类库校验(ta)
  end
end

function onCreateOptionsMenu(menu)
  menu.add("打开").setShowAsAction(1)
end

import "com.google.android.material.dialog.MaterialAlertDialogBuilder"
import "vinx.material.textfield.MaterialTextField"

local inputlayout = {
  LinearLayout,
  orientation="vertical",
  layout_width="match",
  layout_height="match",
  paddingLeft="20dp",
  paddingTop="20dp",
  paddingRight="20dp",
  Focusable=true,
  FocusableInTouchMode=true, 
  {
    MaterialTextField,
    layout_width="fill",
    layout_height="wrap",
    textSize="12dp",
    TintColor=primaryColor,
    style=MDC_R.style.Widget_Material3_TextInputLayout_OutlinedBox,
    singleLine=true,
    id="file_name",
  },
}

function onOptionsItemSelected(m)
  if m.getItemId() == android.R.id.home
    activity.finish()
   elseif m.title=="打开" then
    local sublayout = {}
    MaterialAlertDialogBuilder(activity)
    .setTitle("请输入类名")
    .setView(loadlayout(inputlayout, sublayout))
    .setPositiveButton(android.R.string.ok, function()
  activity.newActivity("eee",{tostring(sublayout.file_name.getText()),ss,co})
    end)
    .setNegativeButton(android.R.string.cancel, nil)
    .show();
  end
end