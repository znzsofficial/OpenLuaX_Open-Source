require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "java.io.*"
import "mods.InitMainPop"
import "mods.Strings"
import "mods.InitTab"

import "android.content.pm.PackageManager"
import "android.animation.LayoutTransition"
import "android.graphics.drawable.ColorDrawable"
import "android.view.inputmethod.EditorInfo"
import "android.text.TextUtils"
import "android.util.TypedValue"

import "com.open.lua.util.LuaFile"
import "com.google.android.material.dialog.MaterialAlertDialogBuilder"
import "com.google.android.material.card.MaterialCardView"
import "com.google.android.material.bottomsheet.BottomSheetDialog"
import "com.google.android.material.bottomsheet.BottomSheetBehavior"
import "com.google.android.material.tabs.TabLayout"
import "com.google.android.material.textfield.TextInputLayout"
import "com.google.android.material.textfield.TextInputEditText"
import "com.google.android.material.internal.ScrimInsetsFrameLayout"
import "com.google.android.material.divider.MaterialDivider"
import "com.google.android.material.textview.MaterialTextView"
import "com.google.android.material.materialswitch.MaterialSwitch"
import "androidx.appcompat.widget.AppCompatImageView"
import "androidx.appcompat.widget.LinearLayoutCompat"
import "androidx.coordinatorlayout.widget.CoordinatorLayout"
import "androidx.appcompat.widget.PopupMenu"
import "androidx.core.view.GravityCompat"
import "androidx.drawerlayout.widget.DrawerLayout"
import "androidx.appcompat.widget.AppCompatSeekBar"

import "android.graphics.PorterDuffColorFilter"
import "android.graphics.PorterDuff"
import "android.content.Context"
import "github.daisukiKaffuChino.LuaFileTabView"
import "bin"
import "console"
--jpairs = require "jpairs"
class = require "modules.class"
loadlayout = require "oldloadlayout"
local lfs = require "lfs"
local rawio = require "rawio"
import "android.graphics.Typeface"
MDC_R=luajava.bindClass"com.google.android.material.R"
defType=File(activity.getLuaDir().."/font/default.ttf")


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

----------------------初始化参数-----------------------------------
pcall(dofile,activity.getLuaDir().."/config/default.lua")

pcall(dofile,activity.getLuaDir().."/config/lua_project.lua")

--pcall(dofile,activity.getLuaDir().."/config/lua_theme.lua")

pcall(dofile,activity.getLuaDir().."/config/last_history.lua")

pcall(dofile,activity.getLuaDir().."/config/config.lua")


--主题
last_theme = "AppMonetTheme"

--最后打开的文件的路径
last_file_path = last_file_path or app_root_lua

--最后打开的文件的光标位置
last_file_cursor = last_file_cursor or 0

--最后打开文件的目录
last_dir_path = last_file_path:match("^(.-)[^/]+$")

--最后打开的工程目录
last_pro_path = last_pro_path

--历史记录表
last_history = last_history or {}

tabTable={}
--LuaEditor配置
--errMsg = errMsg

newfont = newfont
tabtitle = tabtitle

-----------------------------------------------------------------

if newfont
  codeTypeFace=Typeface.createFromFile(File(activity.getLuaDir().."/font/code2.ttf"))
 else
  codeTypeFace=Typeface.createFromFile(File(activity.getLuaDir().."/font/code.ttf"))
end

--设置主题

APP_THEME = import("themes."..last_theme)

this.setTheme(APP_THEME)

this.getWindow()
.setStatusBarColor(状态栏背景色)
.setNavigationBarColor(状态栏背景色)

activity.getSupportActionBar().hide()

--ripple
circleRippleRes = TypedValue()
activity.getTheme().resolveAttribute(android.R.attr.selectableItemBackgroundBorderless, circleRippleRes, true)

rippleRes = TypedValue()
activity.getTheme().resolveAttribute(android.R.attr.selectableItemBackground, rippleRes, true)

local Snackbar = luajava.bindClass "com.google.android.material.snackbar.Snackbar"
local function snack(content)
  Snackbar.make(mContent,tostring(content),Snackbar.LENGTH_SHORT).setAnchorView(ps_bar).show()
end
--显示界面布局

import "alys.main_layout"

import "alys.list_item"

activity.setContentView(loadlayout(main_layout))

--配置编辑器主题

mLuaEditor
.setBasewordColor(BasewordColor)
.setKeywordColor(KeywordColor)
.setCommentColor(CommentColor)
.setUserwordColor(UserwordColor)
.setStringColor(StringColor)
.setBackground(ColorDrawable(编辑器背景色))
--.enableNonPointing(nonPoint)
--.enableDrawingErrMsg(errMsg)
.setTypeface(codeTypeFace)

--初始化文件选择器

mLuaAdapter = LuaAdapter(activity,list_item)

mList.setAdapter(mLuaAdapter)

mTab.setTabGravity(TabLayout.GRAVITY_START)

--动态申请所有权限

function ApplicationAuthority()

  local mAppPermissions = ArrayList()

  local mAppPermissionsTable = luajava.astable(activity.getPackageManager().getPackageInfo(activity.getPackageName(),PackageManager.GET_PERMISSIONS).requestedPermissions)

  for k,v in pairs(mAppPermissionsTable) do

    mAppPermissions.add(v)

  end

  local size = mAppPermissions.size()

  local mArray = mAppPermissions.toArray(String[size])

  activity.requestPermissions(mArray,0)

end

ApplicationAuthority()



--权限申请回调

onRequestPermissionsResult=function(r,p,g)

end


--写入文件内容并保存

function write(path, str)

  local ok = rawio.iowrite(path,str)

  if not ok then

    --[[
    if not path == luajava.luaextdir.."new.lua"
      Toast.makeText(activity, "保存失败." .. path, Toast.LENGTH_SHORT ).show()
    end]]

  end

  return str

end


--读取文件内容显示到编辑器

function read(path)

  local str = nil

  local function _read()

    str = rawio.iotsread(path)

  end

  if pcall(_read) then

    mLuaEditor.setText(str)

    last_file_path = path

    if last_history[last_file_path] then

      mLuaEditor.setSelection(last_history[last_file_path])

    end

    InitTab.setTab(path)

    --记录历史记录,最大记录为50条

    table.insert(last_history, 1, last_file_path)

    for n = 2, #last_history do

      if n > 50 then

        last_history[n] = nil

       elseif last_history[n] == last_file_path then

        table.remove(last_history, n)

      end

    end

   else

    --error()

    return

  end

  --记录当前打开的文件为最后打开的文件到文件

  write(activity.getLuaDir().."/config/lua_project.lua", string.format("last_file_path=%q", path))

end


--保存文件和记录的信息

function save()

  last_history[last_file_path] = mLuaEditor.getSelectionEnd()

  write(activity.getLuaDir().."/config/lua_history.lua", string.format("last_history=%q", dump(last_history)))

  local str = nil

  str = rawio.iotsread(last_file_path)

  if str==nil then snack("read last path failed") end

  local src = mLuaEditor.getText().toString()

  if src ~= str then

    if TextUtils.isEmpty(src) then

      snack("当前保存的数据为空")

      write(last_file_path, src)

    end

    write(last_file_path, src)

  end

  return src

end

--软件更新回调

function onVersionChanged(n,o)

  local dlg = MaterialAlertDialogBuilder(this)

  local title = "更新" .. o .. ">" .. n

  local msg = Strings.getUpdateLog()

  if o == "" then

    title = "欢迎使用OpenLuaX+ " .. n

    msg = Strings.getIntroduction().. msg

  end

  dlg.setTitle(title)

  dlg.setMessage(msg)

  dlg.setPositiveButton("确定", nil)

  dlg.setNeutralButton("反馈问题", function()

    if pcall(function() activity.getPackageManager().getPackageInfo("com.tencent.mobileqq",0) end) then

      snack("添加好友请注明来意")

      local url="mqqapi://card/show_pslcard?src_type=internal&source=sharecard&version=1&uin=1071723770"

      activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))

     else


      snack("请先安装QQ")

    end

  end)

  dlg.show()

end

-- 智商封印
mTab.addOnTabSelectedListener(TabLayout.OnTabSelectedListener{
  onTabUnselected=function(tab)
    --Tab没有被选择事件
    save()
  end;
  onTabSelected=function(tab)
    --tab.setContentDescription("");
    --Tab被选择事件
    local dir = tab.tag
    local name = dir:match(app_root_pro_dir.."/(.-)/")
    mFileSubTitle.setText(dir)
    mTitle.setText(name)
    mSubTitle.setText(dir)
    read(tab.tag)
    task(10,function()
      updataList(File(dir).getParent())
    end)
  end;
  onTabReselected=function(tab)
    --local view=tab.view
    --Tab被再次选择事件
    local dir = tab.tag
    local name = dir:match(app_root_pro_dir.."/(.-)/")
    mFileSubTitle.setText(dir)
    mTitle.setText(name)
    mSubTitle.setText(dir)
    task(10,function()
      updataList(File(dir).getParent())
    end)
  end;
})




--侧滑栏按钮点击事件

mMenu.onClick=function()

  mDraw.openDrawer(3)

end



--运行按钮点击事件

mPlay.onClick=function()

  local pro = mTitle.Text

  if pro=="未打开工程" then

    snack("没有打开工程")

   else

    save()

    local main = app_root_pro_dir.."/"..mTitle.Text.."/".."main.lua"

    activity.newActivity(main)

  end

end



mUndo.onClick=function()

  mLuaEditor.undo()

end



mRedo.onClick=function()

  mLuaEditor.redo()

end

InitMainPop.init()

mMore.onClick=function()

  InitMainPop.show()

end







local 搜索关键字 = ""

local 搜索关键字结果 = {}

local 搜索关键字位置 = 1

local 搜索关键字长度 = 0

mArrow_x.onClick=function()

  if mSearchEdit.Text==nil or mSearchEdit.Text=="" then

    snack("请输入关键字")

    return

  end

  --判断是否是上次的搜索的关键字
  if mSearchEdit.Text == 搜索关键字 then

    --判断搜索有没有内容
    if (#搜索关键字结果) == 0 then

      snack("结果为空")

      return

     else

      --定位关键字下一个位置
      搜索关键字位置 = 搜索关键字位置 + 1

    end

    if 搜索关键字位置 < (#搜索关键字结果) then

      local first = 搜索关键字结果[搜索关键字位置][0]

      mLuaEditor.setSelection(first,搜索关键字长度)

     elseif 搜索关键字位置 == (#搜索关键字结果) then

      local first = 搜索关键字结果[搜索关键字位置][0]

      mLuaEditor.setSelection(first,搜索关键字长度)

      搜索关键字位置 = 0

     elseif 搜索关键字位置 > (#搜索关键字结果) then

      搜索关键字位置 = 1

      local first = 搜索关键字结果[搜索关键字位置][0]

      mLuaEditor.setSelection(first,搜索关键字长度)

    end

   else

    --重新搜索并定位第一个关键字
    搜索关键字 = mSearchEdit.Text

    搜索关键字位置 = 1

    搜索关键字长度 = utf8.len(搜索关键字)

    搜索关键字结果 = luajava.astable(LuaString.gfind(mLuaEditor.Text,搜索关键字))

    if (#搜索关键字结果)==0 then

      snack("什么都没有")

     else

      local first = 搜索关键字结果[搜索关键字位置][0]

      mLuaEditor.setSelection(first,搜索关键字长度)

    end

  end


end



mArrow_s.onClick=function()

  if mSearchEdit.Text==nil or mSearchEdit.Text=="" then

    snack("请输入关键字")

    return

  end

  --判断是否是上次的搜索的关键字
  if mSearchEdit.Text == 搜索关键字 then

    --判断搜索有没有内容
    if (#搜索关键字结果) == 0 then

      snack("结果为空")

      return

     else

      --定位关键字下一个位置
      搜索关键字位置 = 搜索关键字位置 - 1

      if 搜索关键字位置 == -1 then

        if (#搜索关键字结果) == 1 then

          搜索关键字位置 = 1

         elseif (#搜索关键字结果) > 1 then

          搜索关键字位置 = #搜索关键字结果 - 1

        end

      end

    end

    if 搜索关键字位置 > 0 then

      local first = 搜索关键字结果[搜索关键字位置][0]

      mLuaEditor.setSelection(first,搜索关键字长度)

     elseif 搜索关键字位置 == 0 then

      搜索关键字位置 = #搜索关键字结果

      local first = 搜索关键字结果[搜索关键字位置][0]

      mLuaEditor.setSelection(first,搜索关键字长度)

    end

   else

    snack("瞎按上键？")

  end


end














function onResume()

  --打开init.lua时候,调整工程属性,回来的时候重新读取文件
  if ends(mSubTitle.Text,"init.lua") then

    read(mSubTitle.Text)

  end

  save()

end





function onCreate()

  if last_file_path==app_root_lua then

    return

   else

    open(last_file_path)

    last_file_cursor = last_file_cursor or 0

    if last_file_cursor < mLuaEditor.getText().length() then

      mLuaEditor.setSelection(last_file_cursor)

    end

  end

end



--查找alp工程的弹窗
function alpFindDialog_show()

  import "alys.alp_find"

  import "alys.alp_find_item"

  alpFindDialog = BottomSheetDialog(activity)

  alpFindDialogAly = loadlayout(alp_find)

  alpFindDialog.setContentView(alpFindDialogAly)

  alpFindDialog.getWindow().setBackgroundDrawable(ColorDrawable(0x00000000))

  local p = alpFindDialog.getWindow().getAttributes()

  p.width = activity.Width

  p.height = activity.Height * 0.8

  alpFindDialog.getWindow().setAttributes(p);

  local parent = alpFindDialogAly.getParent();

  --创建BottomSheetBehavior对象
  local mBehavior = BottomSheetBehavior.from(parent);

  --设置Dialog默认弹出高度为屏幕的0.5倍
  mBehavior.setPeekHeight(0.5 * activity.getHeight());

  alpFindDialog.show();

  local adp = LuaAdapter(activity,alp_find_item)

  list.setAdapter(adp)

  function setAdp(v)

    local n = string.sub(v,string.len(LuaFile.getParent(v))+2,-1)

    adp.add({

      malpImg = {

        src="imgs/project.png",

        colorFilter=图标着色,

      },
      malpTitle={

        text=n

      },
      malpSubTitle={

        text=v

      }

    })

  end


  function alpup()

    alp_up.setVisibility(View.GONE)

  end

  function findFile()

    require "import"

    import "java.io.File"

    --判断文件以什么结尾
    function ends(s,End)

      return End=='' or string.sub(s,-string.len(End))== End

    end

    function find(path)

      if io.info(path) then--File(path).exists() then

        if io.isdir(path) then--File(path).isDirectory() then

          local file_path_lf = File(path).listFiles()

          if(file_path_lf) then

           else

            return

          end

          local path_list = luajava.astable(file_path_lf)

          --对文件进行排序
          table.sort(path_list,function(a,b)
            local _a = io.isdir(a.AbsolutePath)
            local _b = io.isdir(b.AbsolutePath)
            return (_a~=_b and _b) or ((_a==_b) and a.Name<b.Name)
          end)

          for k,v in pairs(path_list) do

            local path0 = v.toString()

            local path1 = "/storage/emulated/0/Androlua"

            local path2 = "/storage/emulated/0/Android/data/com.tencent.mobileqq/Tencent"

            local path3 = "/storage/emulated/0/Download"

            if path0==path1 or path0==path2 or path0==path3 then

              break

            end

            find(path0)

          end

         else

          if ends(path,".alp") then

            call("setAdp",path)

          end

        end

       else

        --snack("文件夹不存在")

        return

      end

      --检查文件是否是文件夹
    end

    --优先查找常用文件夹下的alp
    --在查找sd卡下所有的alp(超级耗时)

    local path1 = "/storage/emulated/0/Androlua"

    find(path1)

    local path2 = "/storage/emulated/0/Android/data/com.tencent.mobileqq/Tencent/QQfile_recv"

    find(path2)

    local path3 = "/storage/emulated/0/Download"

    find(path3)

    local path4 = "/storage/emulated/0"

    find(path4)

    --snack("alp工程文件全部查找完毕")

    call("alpup")

  end

  thread(findFile)

  list.setOnTouchListener(View.OnTouchListener{

    onTouch=function(v,event)

      if v.canScrollVertically(-1) then

        v.requestDisallowInterceptTouchEvent(true);

       else

        v.requestDisallowInterceptTouchEvent(false);

      end

      return false;

    end

  });

  list.onItemClick=function(l,v,p,i)

    local path = v.getChildAt(1).getChildAt(1).Text

    open(path);

  end

  function LandscapeRefreshAnimation(id,w,t)

    import "android.content.Context"

    wm = activity.getSystemService(Context.WINDOW_SERVICE);

    width = wm.getDefaultDisplay().getWidth();

    import "android.view.animation.TranslateAnimation"

    Translate_up_down=TranslateAnimation(0,width+w, 0, 0)

    Translate_up_down.setDuration(t)

    Translate_up_down.setRepeatCount(-1)

    Translate_up_down.setFillAfter(true)

    id.startAnimation(Translate_up_down)

  end

  LandscapeRefreshAnimation(z,1000,1500)

end



--新建文件对话框
function new_file_dialog()

  import "alys.new_file"

  local new_file_dlg = MaterialAlertDialogBuilder(this)

  new_file_dlg.setTitle("新建文件")

  new_file_dlg.setView(loadlayout(new_file))

  new_file_dlg.setPositiveButton("新建",{

    onClick=function()

      --获取用户当前打开目录
      local path = mFileSubTitle.getText().."/"..file_name.Text

      if ends(path,".lua") then

        local lua = mFileSubTitle.getText() .."/"..file_name.Text

        LuaFile.write(lua, tcode)

        updataList()

       elseif ends(path,".aly") then

        local lua = mFileSubTitle.getText() .."/"..file_name.Text

        LuaFile.write(lua, lcode)

        updataList()

       else

        local other = mFileSubTitle.getText() .."/"..file_name.Text

        LuaFile.write(other,"")

        updataList()

      end

    end

  })

  new_file_dlg.setNegativeButton("取消", nil)

  new_file_dlg.show()

  --new_file_dlg.getButton(new_file_dlg.BUTTON_POSITIVE).setTextColor(标题文字颜色)

  --new_file_dlg.getButton(new_file_dlg.BUTTON_NEGATIVE).setTextColor(副标题文字颜色)

end



--新建文件夹
function new_folder_dialog()

  import "alys.new_folder"

  local new_folder_dlg = MaterialAlertDialogBuilder(this)

  new_folder_dlg.setTitle("新建文件夹")

  new_folder_dlg.setView(loadlayout(new_folder))

  new_folder_dlg.setPositiveButton("新建",{

    onClick=function()

      local path = mFileSubTitle.getText().."/"..folder_name.Text

      if io.isdir(path) then--File(path).isDirectory()then

        snack("文件夹已存在")

       else

        File(path).mkdir()
        --io.mkdir(path)

        updataList()

        snack("文件夹创建成功")

      end

    end

  })

  new_folder_dlg.setNegativeButton("取消", nil)

  new_folder_dlg.show()

  --new_folder_dlg.getButton(new_folder_dlg.BUTTON_POSITIVE).setTextColor(标题文字颜色)

  --new_folder_dlg.getButton(new_folder_dlg.BUTTON_NEGATIVE).setTextColor(副标题文字颜色)

end


tcode = [[
require "import"
import "android.widget.*"
import "android.view.*"

]]
pcode = [[
require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "layout"

activity.setTheme(R.style.AppTheme_Compat)
activity.setContentView(loadlayout(layout))
]]
lcode = [[
{
  LinearLayout,
  orientation="vertical",
  layout_width="fill",
  layout_height="fill",
  gravity="center",
  {
    TextView,
    text="Hello OpenLuaX+",
    id="mText",
  },
}
]]
upcode = [[
theme="Theme_Material_Light_NoActionBar"
debugmode=true
user_permission={
  "INTERNET",
  "WRITE_EXTERNAL_STORAGE",
}
]]



--判断文件以什么结尾
function ends(s,End)

  return End=='' or string.sub(s,-string.len(End))== End

end





--读取文件到LuaEditor

function open(path)

  if path == app_root_pro_dir or io.isdir(path) then--File(path).isDirectory() then

    return

  end

  if
    ends(path,".lua")

    or ends(path,".aly")

    or ends(path,".java")

    or ends(path,".txt")

    or ends(path,".json")
    --智商封印official
    or ends(path,".md")
    or ends(path,".markdown")
    or ends(path,".bak")
    or ends(path,".xml")
    or ends(path,".kt")
    or ends(path,".js")
    or ends(path,".css")
    or ends(path,".luac")
    or ends(path,".alyc")
    or ends(path,".luax")
    or ends(path,".alyx")
    or ends(path,".html")

    then

    mDraw.closeDrawer(3)

   elseif

    ends(path,".png")

    or ends(path,".jpg")

    or ends(path,".jpeg")

    or ends(path,".gif")

    then

    activity.newActivity("activitys/pic_activity",{path})

    return

   elseif ends(path,".alp") then

    imports(path)

    return

   else

    snack("暂时不支持打开该类型的文件")

    return

  end

  read(path)

  local name = (path.."/"):match(app_root_pro_dir.."/(.-)/")

  local dir = File(path).getParent();

  mFileSubTitle.setText(dir)

  mTitle.setText(name)

  mSubTitle.setText(path)

end


--导出为alp文件并分享
function ShareAndExport(pdir)

  require "import"

  import "java.util.zip.*"

  import "java.io.*"

  local function copy(input, output)

    local b = byte[2 ^ 16]

    local l = input.read(b)

    while l > 1 do

      output.write(b, 0, l)

      l = input.read(b)

    end

    input.close()

  end

  local f = File(pdir)

  local date = os.date("%y%m%d%H%M%S")

  local tmp = activity.getLuaExtDir("backup") .. "/" .. f.Name .. ".alp"

  local p = {}

  local e, s = pcall(loadfile(f.Path .. "/init.lua", "bt", p))

  if e then

    if p.mode then

      tmp = string.format("%s/%s.alp", activity.getLuaExtDir("backup"), p.appname)

     else

      tmp = string.format("%s/%s.alp", activity.getLuaExtDir("backup"), p.appname)

    end

  end

  local out = ZipOutputStream(FileOutputStream(tmp))

  local using={}

  local using_tmp={}

  function addDir(out, dir, f)

    local ls = f.listFiles()

    for n = 0, #ls - 1 do

      local name = ls[n].getName()

      if name:find("%.apk$") or name:find("%.luac$") or name:find("^%.") then

       elseif

        p.mode

        and name:find("%.lua$")

        and name ~= "init.lua"

        then

        local ff=io.open(ls[n].Path)

        local ss=ff:read("a")

        ff:close()

        for u in ss:gmatch([[require *%b""]]) do

          if using_tmp[u]==nil then

            table.insert(using,u)

            using_tmp[u]=true

          end

        end

        local path, err = console.build(ls[n].Path)

        if path then

          entry = ZipEntry(dir .. name)

          out.putNextEntry(entry)

          copy(FileInputStream(File(path)), out)

          os.remove(path)

         else

          error(err)

        end

       elseif

        p.mode

        and name:find("%.aly$")

        then

        name = name:gsub("aly$", "lua")

        local path, err = console.build_aly(ls[n].Path)

        if path then

          entry = ZipEntry(dir .. name)

          out.putNextEntry(entry)

          copy(FileInputStream(File(path)), out)

          os.remove(path)

         else

          error(err)

        end

       elseif ls[n].isDirectory() then

        addDir(out, dir .. name .. "/", ls[n])

       else

        entry = ZipEntry(dir .. name)

        out.putNextEntry(entry)

        copy(FileInputStream(ls[n]), out)

      end

    end

  end

  addDir(out, "", f)

  local ff=io.open(f.Path.."/.using","w")

  ff:write(table.concat(using,"\n"))

  ff:close()

  entry = ZipEntry(".using")

  out.putNextEntry(entry)

  copy(FileInputStream(f.Path.."/.using"), out)

  out.closeEntry()

  out.close()

  os.remove(f.Path.."/.using")

  return tmp

end







--导出工程为alp文件
function export(pdir)

  require "import"

  import "java.util.zip.*"

  import "java.io.*"

  local function copy(input, output)

    local b = byte[2 ^ 16]

    local l = input.read(b)

    while l > 1 do

      output.write(b, 0, l)

      l = input.read(b)

    end

    input.close()

  end

  local f = File(pdir)

  local date = os.date("%y%m%d%H%M%S")

  local tmp = activity.getLuaExtDir("backup") .. "/" .. f.Name .. "_" .. date .. ".alp"

  local p = {}

  local e, s = pcall(loadfile(f.Path .. "/init.lua", "bt", p))

  if e then

    if p.mode then

      tmp = string.format("%s/%s_%s_%s_%s.%s", activity.getLuaExtDir("backup"), p.appname,p.mode, p.appver:gsub("%.", "_"), date,p.ext or "alp")

     else

      tmp = string.format("%s/%s_%s_%s.%s", activity.getLuaExtDir("backup"), p.appname, p.appver:gsub("%.", "_"), date,p.ext or "alp")

    end

  end

  local out = ZipOutputStream(FileOutputStream(tmp))

  local using={}

  local using_tmp={}

  function addDir(out, dir, f)

    local ls = f.listFiles()

    for n = 0, #ls - 1 do

      local name = ls[n].getName()

      if name:find("%.apk$") or name:find("%.luac$") or name:find("^%.") then

       elseif

        p.mode

        and name:find("%.lua$")

        and name ~= "init.lua"

        then

        local ff=io.open(ls[n].Path)

        local ss=ff:read("a")

        ff:close()

        for u in ss:gmatch([[require *%b""]]) do

          if using_tmp[u]==nil then

            table.insert(using,u)

            using_tmp[u]=true

          end

        end

        local path, err = console.build(ls[n].Path)

        if path then

          entry = ZipEntry(dir .. name)

          out.putNextEntry(entry)

          copy(FileInputStream(File(path)), out)

          os.remove(path)

         else

          error(err)

        end

       elseif

        p.mode

        and name:find("%.aly$")

        then

        name = name:gsub("aly$", "lua")

        local path, err = console.build_aly(ls[n].Path)

        if path then

          entry = ZipEntry(dir .. name)

          out.putNextEntry(entry)

          copy(FileInputStream(File(path)), out)

          os.remove(path)

         else

          error(err)

        end

       elseif ls[n].isDirectory() then

        addDir(out, dir .. name .. "/", ls[n])

       else

        entry = ZipEntry(dir .. name)

        out.putNextEntry(entry)

        copy(FileInputStream(ls[n]), out)

      end

    end

  end

  addDir(out, "", f)

  local ff=io.open(f.Path.."/.using","w")

  ff:write(table.concat(using,"\n"))

  ff:close()

  entry = ZipEntry(".using")

  out.putNextEntry(entry)

  copy(FileInputStream(f.Path.."/.using"), out)

  out.closeEntry()

  out.close()

  os.remove(f.Path.."/.using")

  return tmp

end





--新建工程对话框
function new_project_dialog()

  import "alys.new_pro"

  local project_dlg = MaterialAlertDialogBuilder(this)

  project_dlg.setTitle("新建工程")

  project_dlg.setView(loadlayout(new_pro))

  for i=1,500 do

    if lfs.attributes(activity.getLuaExtPath("/project/demo"..i)).mode == "directory" then

      continue

     else

      project_appName.setText("demo"..i)

      project_packageName.setText("com.openlua.demo"..i)

      break

    end

  end

  project_dlg.setPositiveButton("确定", { onClick = function()

      local appname = project_appName.getText().toString()

      local packagename = project_packageName.getText().toString()

      local f = File(app_root_pro_dir .."/".. appname)

      if f.exists() then

        snack("工程已存在")

        return

      end

      save()

      luadir = app_root_pro_dir .."/".. appname .. "/"

      main = luadir .. "main.lua"

      alyp = luadir .. "layout.aly"

      init = luadir .. "init.lua"

      LuaFile.write(init, string.format("appname=\"%s\"\nappver=\"1.0\"\npackagename=\"%s\"\n%s", appname, packagename, upcode))

      LuaFile.write(main, pcode)

      LuaFile.write(alyp, lcode)

      open(main)

      updataList(app_root_pro_dir .."/".. appname)

    end
  })

  project_dlg.setNegativeButton("取消", nil)

  project_dlg.show()

  --project_dlg.getButton(project_dlg.BUTTON_POSITIVE).setTextColor(标题文字颜色)

  --project_dlg.getButton(project_dlg.BUTTON_NEGATIVE).setTextColor(副标题文字颜色)

end





mAdd.onClick=function()

  local pop =PopupMenu(activity,mAdds)

  local menu=pop.Menu

  if mFileSubTitle.getText()==app_root_pro_dir then

    menu.add("新建工程").onMenuItemClick=function(a)

      new_project_dialog()

    end

    menu.add("导入工程").onMenuItemClick=function(a)

      alpFindDialog_show()

    end

   else

    menu.add("文件").onMenuItemClick=function(a)

      new_file_dialog()

    end
    menu.add("文件夹").onMenuItemClick=function(a)

      new_folder_dialog()

    end
    menu.add("新建工程").onMenuItemClick=function(a)

      new_project_dialog()

    end

    menu.add("导入工程").onMenuItemClick=function(a)

      alpFindDialog_show()

    end

  end

  pop.show()

end



mAll.onClick=function()

  mLuaEditor.selectAll()

end

mCut.onClick=function()

  mLuaEditor.cut()

end

mCopy.onClick=function()

  mLuaEditor.copy()

end

mPaste.onClick=function()

  mLuaEditor.paste()

end

--[[
import "com.myopicmobile.textwarrior.android.OnSelectionChangedListener"

mLuaEditor.setOnSelectionChangedListener(OnSelectionChangedListener{

  a=function(active,s,e)

    if active then

      mSelect.setVisibility(View.VISIBLE)

     else

      mSelect.setVisibility(View.INVISIBLE)

    end

  end,

})
]]



--import "androidx.appcompat.view.ActionMode"
function onEditorSelectionChangedListener(view,status,start,end_)
  if status then
    mSelect.setVisibility(View.VISIBLE)
   else
    mSelect.setVisibility(View.INVISIBLE)
  end
end

mLuaEditor.OnSelectionChangedListener=function(status,start,end_)
  onEditorSelectionChangedListener(mLuaEditor,status,start,end_)
end


mDraw.setDrawerListener(DrawerLayout.DrawerListener{

  onDrawerOpened=function(drawerView)

    updataList()

  end

})




--符号栏
function Creat_Shortcut_Symbol_Bar(id)

  local t=

  {
    "func","(",")","[","]","{","}",

    "\"","=",":",".",",",";","_",

    "+","-","*","/","\\","%",

    "#","^","$","?","&","|",

    "<",">","~","'"

  }

  for k,v in ipairs(t) do

    Shortcut_Symbol_Item=loadlayout({

      LinearLayout,

      layout_width="40dp",

      layout_height="40dp",

      backgroundColor=surfaceColor,

      {

        MaterialTextView,

        layout_width="40dp",

        layout_height="40dp",

        gravity="center",

        textColor=surfaceColorIn,

        clickable="true",

        focusable="true",

        backgroundResource=rippleRes.resourceId,

        text=v,

        Typeface=codeTypeFace,

        onClick=function()

          if v=="func" then v="function()" end

          mLuaEditor.paste(v)

        end,

      },

    })

    id.addView(Shortcut_Symbol_Item)

  end

end

activity.getWindow().setSoftInputMode(0x10)

task(1,Creat_Shortcut_Symbol_Bar(ps_bar))




--按两次退出
参数=0

function onKeyDown(code,event)

  if string.find(tostring(event),"KEYCODE_BACK") ~= nil then

    if 参数+2 > tonumber(os.time()) then

      activity.finish()

     else

      --退出之前判断选择框是否显示
      if mDraw.isDrawerOpen(GravityCompat.START) then

        mDraw.closeDrawer(GravityCompat.START)

       elseif mSelect.getVisibility()==0 then

        mSelect.setVisibility(View.INVISIBLE)

       elseif mSearch.getVisibility()==0 then

        mSearch.setVisibility(View.INVISIBLE)

       else

        snack("再按一次返回键退出")

        参数=tonumber(os.time())

      end

    end

    return true

  end

end


--智商封印 启用filetab
filetab.addOnTabSelectedListener(LuaFileTabView.OnTabSelectedListener{
  onTabSelected=function(tab)

    task(10,function()
      updataList(filetab.getPath())
    end)

  end
})

--判断文件或者文件夹是否存在
function file_exists(path)

  local f=io.open(path,'r')

  if f~=nil then io.close(f) return true else return false end

end


--异步更新到当前目录或者更新到指定目录
function updataList(path)

  task(1,_updataList(path))

end

--更新到当前目录或者更新到指定目录
function _updataList(path)

  save()

  --判断有没有指定的目录
  if path then

    当前文件路径 = path

    --如果是文件夹则更新目录 智商封印
    if lfs.attributes(path).mode == "directory" then
      --如果不在工程文件夹内
      if not string.find(path,app_root_pro_dir)
        snack("不允许访问的路径"..path)
        filetab.setPath(app_root_pro_dir)
        StopUpdateList=true
       else
        filetab.setPath(path)
        StopUpdateList=false
      end
    end

   else

    --filetab.Visibility = 8

    --没有指定的目录的话,默认刷新当前的目录
    当前文件路径 = tostring(mFileSubTitle.getText())

    --如果默认目录被删除了,就直接更新工程根目录
    if 当前文件路径=="未打开文件" then

      当前文件路径 = app_root_pro_dir

    end

    filetab.setPath(当前文件路径)

  end

  if StopUpdateList--判断是否停止加载
   else
    StopUpdateList=false
    --判断文件夹
    if lfs.attributes(当前文件路径).mode == "directory" then

      --1.清除文件列表
      mLuaAdapter.clear()

      mLuaAdapter.notifyDataSetChanged();

      --获得当前目录文件列表

      --当前工程列表 = luajava.astable(File(当前文件路径).listFiles())

      --[[for _, v in pairs(io.ls(当前文件路径))
        table.insert(当前工程列表,当前文件路径.."/"..v)
      end]]

      --[[
      当前工程列表 = {}
      local FileList = {}
      local IndexObj = File(当前文件路径)
      local _list = IndexObj.list()
      for _, v in jpairs(_list) do
        local _path = 当前文件路径.."/"..v
        if io.isdir(_path)
          当前工程列表[#当前工程列表 + 1] = _path
         else
          FileList[#FileList + 1] = _path
        end
      end]]

      当前工程列表 = {}
      local FileList = {}
      for file in lfs.dir(当前文件路径) do
        local fullPath = 当前文件路径 .. "/" .. file
        if lfs.attributes(fullPath).mode == "directory" then
          当前工程列表[#当前工程列表 + 1] = fullPath
         else
          FileList[#FileList + 1] = fullPath
        end
      end

      table.sort(当前工程列表)
      table.sort(FileList)
      for _, v in pairs(FileList)
        当前工程列表[#当前工程列表 + 1] = v
      end
      当前工程列表["."]=nil
      当前工程列表[".."]=nil

      if (#当前工程列表) == 0 then

        mFileEnpty.setVisibility(View.VISIBLE)

       else

        mFileEnpty.setVisibility(View.INVISIBLE)

      end

      --如果为根目录
      if 当前文件路径 == app_root_pro_dir then

        mFileTitle.setText("未打开工程")

       else

        local name = (当前文件路径.."/"):match(app_root_pro_dir.."/(.-)/")

        mFileTitle.setText(name)

      end

      mFileSubTitle.setText(当前文件路径)

     else

      --先保存之前的代码,再读取当前文件
      save()

      --如果为文件格式,则读取文件,并刷新该文件所在的目录
      open(当前文件路径)

      return

    end


    if LuaFile.getParent(当前文件路径)==luajava.luaextdir then

     else

      mLuaAdapter.add({

        mItemImg = {

          src= "imgs/undo.png",

          colorFilter=图标着色,

        },
        mItemTitle ={

          text="...",

        },
        mItemSubTitle={

          tag=LuaFile.getParent(当前文件路径),

          text="返回上级目录",

        },

      })

    end

    --[[对文件进行排序
    table.sort(当前工程列表
    ,function(a,b)
      local a=File(a)
      local b=File(b)
      return (b.isDirectory() and a.isDirectory()~=b.isDirectory()) or ((a.isDirectory()==b.isDirectory()) and a.Name<b.Name)
    end)]]


    if (#当前工程列表) == 0 then



    end

    for k,v in pairs(当前工程列表) do

      v = tostring(v)

      --n = string.sub(v,string.len(mFileSubTitle.Text)+2,-1)

      n = File(v).getName();

      if n == "" or n == nil or TextUtils.isEmpty(n) then

        snack("工程名字异常,建议修改")

        n = "工程文件名字异常"

      end

      if lfs.attributes(v).mode == "directory" then --File(v).isDirectory() then

        if LuaFile.getParent(当前文件路径)==luajava.luaextdir then
          i = "imgs/project.png"
          vn="项目"
         elseif v:find("%libs$")
          i = "imgs/folder_lib.png"
          vn="库文件夹"
         elseif v:find("page")
          i = "imgs/folder_page.png"
          vn="页文件夹"
         elseif v:find("font")
          i = "imgs/folder_font.png"
          vn="字体文件夹"
         elseif v:find("%mods$") or v:find("%modules$")
          i = "imgs/folder_mods.png"
          vn="模块文件夹"
         elseif v:find("config") or v:find("setting")
          i = "imgs/folder_set.png"
          vn="设置文件夹"
         elseif v:find("sound$") or v:find("music$")
          i = "imgs/folder_sound.png"
          vn="音频文件夹"
         elseif v:find("%res$") or v:find("%imgs$") or v:find("%img$")
          i = "imgs/folder_res.png"
          vn="资源文件夹"
         else
          i = "imgs/folder.png"
          vn="文件夹"
        end

       else

        if v:find("%.lua$")
          i = "imgs/lua.png"
          if v:find("Util.lua") or v:find("Utils.lua") or v:find("utils.lua") or v:find("util.lua")
            vn="Lua 工具类"
           elseif v:find("Class.lua") or v:find("class.lua")
            vn="Lua 类"
           elseif v:find("main.lua")
            vn="程序入口"
           elseif v:find("init.lua")
            vn="项目属性"
           else
            vn="Lua 文件"
          end
         elseif v:find("%.aly$")
          i = "imgs/table.png"
          vn="AndroLua+ 布局"
         elseif v:find("%.alyc$")
          i = "imgs/table.png"
          vn="AndroLua+ 布局"
         elseif v:find("%.alyx$")
          i = "imgs/table.png"
          vn="RippleLua+ 布局"
         elseif v:find("%.luac$")
          i = "imgs/lua.png"
          vn="Luac 文件"
         elseif v:find("%.luax$")
          i = "imgs/lua.png"
          vn="Luax 文件"
         elseif v:find("%.class$")
          i = "imgs/java.png"
          vn="Class 文件"
         elseif v:find("%.java$")
          i = "imgs/java.png"
          vn="Java 文件"
         elseif v:find("%.kt$")
          i = "imgs/kotlin.png"
          vn="Kotlin 文件"
         elseif v:find("%.json$")
          i = "imgs/json.png"
          vn="JSON"
         elseif v:find("%.css$")
          i = "imgs/css.png"
          vn="css 文件"
         elseif v:find("%.txt$")
          i = "imgs/text.png"
          vn="文本"
         elseif v:find("%.ttf$")
          i = "imgs/font.png"
          vn="字体文件"
         elseif v:find("%.bak$")
          i = "imgs/file_bak.png"
          vn="备份文件"
         elseif v:find("%.xml$")
          i = "imgs/xml.png"
          vn="XML 文件"
         elseif v:find("%.html$")
          i = "imgs/html.png"
          vn="HTML 文件"
         elseif v:find("%.dex$")
          i = "imgs/zip_box.png"
          vn="Dex 文件"
         elseif v:find("%.odex$")
          i = "imgs/zip_box.png"
          vn="Odex 文件"
         elseif v:find("%.vdex$")
          i = "imgs/zip_box.png"
          vn="Vdex 文件"
         elseif v:find("%.jar$")
          i = "imgs/zip_box.png"
          vn="Jar 文件"
         elseif v:find("%.aar$")
          i = "imgs/android.png"
          vn="aar 文件"
         elseif v:find("%.markdown$") or v:find("%.md$")
          i = "imgs/markdown.png"
          vn="MarkDown 文件"
         elseif v:find("%.png$") or v:find("%.jpg$") or v:find("%.jpeg$") or v:find("%.gif$")
          i=v or "imgs/file_img.png"
          vn="图片"
         elseif v:find("%.zip$") or v:find("%.rar$") or v:find("%.7z$") or v:find("%.tar$")
          i=v or "imgs/zip_box.png"
          vn="压缩文件"
         elseif v:find("%.using$")
          i = "imgs/code.png"
          vn="项目使用中"
         elseif v:find("%.lrc$")
          i = "imgs/music.png"
          vn="歌词文件"
         elseif v:find("%.mp3$") or v:find("%.flac$") or v:find("%.wav$") or v:find("%.aac$")
          i = "imgs/music.png"
          vn="音频文件"
         elseif v:find("%license") or v:find("%LICENSE")
          i = "imgs/license.png"
          vn="许可证"
         else
          i = "imgs/file.png"
          vn=v
        end
      end

      mLuaAdapter.add({

        mItemImg = {

          src=i,

          colorFilter=图标着色,

        },
        mItemTitle ={

          text=n,

        },
        mItemSubTitle={

          text=vn,

          tag=v,

        },

      })

    end

  end --是否停止加载

end




onStop=function()

  save()


  local f = io.open(activity.getLuaDir().."/config/lua_project.lua", "wb")

  f:write(string.format("last_file_path=%q\nlast_file_cursor=%d", last_file_path, mLuaEditor.getSelectionEnd() ))

  f:close()



  local f = io.open(activity.getLuaDir().."/config/lua_history.lua", "wb")

  f:write(string.format("last_history=%s", dump(last_history)))

  f:close()

end







mList.onItemClick=function(l,view,p,i)

  --获得点击时路径
  local path = view.getChildAt(1).getChildAt(1).Tag

  --判断是打开目录还是打开文件
  updataList(path)

  return true

end



--复制文本
function CopyTheText(str)

  str=tostring(str)

  import "android.content.*"

  activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(str)

  snack("已复制")

end




--文件重命名
function rename(path,name)

  import "alys.new_rename"

  local new_file_dlg = MaterialAlertDialogBuilder(this)

  new_file_dlg.setTitle("重命名文件")

  new_file_dlg.setView(loadlayout(new_rename))

  file_name.Text = name

  new_file_dlg.setPositiveButton("重命名",{

    onClick=function()

      new_path = mFileSubTitle.getText().."/"..file_name.Text

      File(path).renameTo(File(new_path))

      updataList()

    end

  })

  new_file_dlg.setNegativeButton("取消", nil)

  new_file_dlg.show()

  --new_file_dlg.getButton(new_file_dlg.BUTTON_POSITIVE).setTextColor(标题文字颜色)

  --new_file_dlg.getButton(new_file_dlg.BUTTON_NEGATIVE).setTextColor(副标题文字颜色)

end


--项目被长按
mList.onItemLongClick=function(l,v,p,i)

  local pop =PopupMenu(activity,v)

  local menu=pop.Menu

  local path = v.getChildAt(1).getChildAt(1).tag

  local name = v.getChildAt(1).getChildAt(0).Text

  --判断工程目录
  if mFileSubTitle.Text == app_root_pro_dir then

    menu.add("删除").onMenuItemClick=function(a)

      if name==mTitle.Text then

        snack("不能删除已打开的工程")

       else

        LuaFile.delete(path)
        --Toast.makeText(this,path,Toast.LENGTH_LONG).show()
        updataList(app_root_pro_dir)

        snack("工程已删除")

      end

    end

    pop.show()

    return true

  end

  if path=="返回上级目录" then

   else

    menu.add("复制文件路径").onMenuItemClick=function(a)

      CopyTheText(path)

    end

    menu.add("删除").onMenuItemClick=function(a)

      if path==mSubTitle.Text then

        snack("不能删除已打开的文件")

       else

        if LuaFile.delete(path) then

          updataList()

          snack("文件已删除")

        end

      end


    end

    menu.add("重命名").onMenuItemClick=function(a)

      if path==mSubTitle.Text then

        snack("不能重命名当前打开文件")

       else

        rename(path,name)

      end

    end

    pop.show()

  end

  return true

end


local function adds()

  require "import"

  local classes = require "javaapi.android"

  local ms = {

    "onCreate",

    "onStart",

    "onResume",

    "onPause",

    "onStop",

    "onDestroy",

    "onActivityResult",

    "onResult",

    "onCreateOptionsMenu",

    "onOptionsItemSelected",

    "onRequestPermissionsResult",

    "onClick",

    "onTouch",

    "onLongClick",

    "onItemClick",

    "onItemLongClick",

    "onVersionChanged",

    "this",

    "android",

    "dp2px",

    "table2json",

    "json2table",

    "L",

  }

  local buf = String[#ms + #classes]

  for k, v in ipairs(ms) do

    if v=="this" or v=="L" or v=="android" then

      buf[k - 1] = v

     else

      buf[k - 1] = v.."()"

    end

  end

  local l = #ms

  for k, v in ipairs(classes) do

    buf[l + k - 1] = string.match(v, "%w+$")

  end

  return buf

end

task(adds, function(buf)

  mLuaEditor.addNames(buf)

end)

local buf={}

local tmp={}

local curr_ms=luajava.astable(LuaActivity.getMethods())

for k,v in ipairs(curr_ms) do

  v=v.getName()

  if not tmp[v] then

    tmp[v]=true

    table.insert(buf,v.."()")

  end

end

mLuaEditor.addPackage("activity",buf)

local buf={}

local tmp={}

local curr_ms=luajava.astable(LuaActivity.getMethods())

for k,v in ipairs(curr_ms) do

  v=v.getName()

  if not tmp[v] then

    tmp[v]=true

    table.insert(buf,v.."()")

  end

end

mLuaEditor.addPackage("this",buf)


function fix(c)

  local classes = require "javaapi.android"

  if c then

    local cls = {}

    c = "%." .. c .. "$"

    for k, v in ipairs(classes) do

      if v:find(c) then

        table.insert(cls, string.format("import %q", v))

      end

    end

    if #cls > 0 then

      create_import_dlg()

      import_dlg.setItems(cls)

      import_dlg.show()

    end

  end

end



function onNewIntent(intent)

  local uri = intent.getData()

  if uri and uri.getPath():find("%.alp$") then

    imports(uri.getPath():match("/storage.+") or uri.getPath())

  end

end


function getalpinfo(path,k)

  local app = {}

  loadstring(tostring(String(LuaUtil.readZip(path,"init.lua"))), "bt", "bt", app)()

  local str = string.format("名称: %s\
版本: %s\
包名: %s\
路径: %s",
  app.appname,
  app.appver,
  app.packagename,
  path
  )
  if k then
    return str
   else
    return app.mode
  end

end

function imports(path)

  local message = getalpinfo(path,true)

  local mode = getalpinfo(path,false)

  create_imports_dlg(path,"导入")

  imports_dlg.setMessage(message)

  if mode == "plugin" or path:match("^([^%._]+)_plugin") then

    create_imports_dlg(path,"导入插件")

    imports_dlg.setTitle("导入插件")

   elseif mode == "build" or path:match("^([^%._]+)_build") then

    create_imports_dlg(path,"打包安装")

    imports_dlg.setTitle("打包安装")

  end

  imports_dlg.show()

end


function create_imports_dlg(path,title)

  if imports_dlg then

    return

  end

  imports_dlg = MaterialAlertDialogBuilder(this)

  imports_dlg.setTitle("导入")

  imports_dlg.setPositiveButton("确定", {

    onClick = function()

      if alpFindDialog then

        alpFindDialog.dismiss()

      end

      --local path = imports_dlg.Message:match("路径: (.+)$")

      if title == "打包安装" then

        importx(path, "build")

        imports_dlg.setTitle("导入")

       elseif title == "导入插件" then

        importx(path, "plugin")

        imports_dlg.setTitle("导入")

       else

        importx(path)

      end

  end })

  imports_dlg.setNegativeButton("取消", nil)

end


function importx(path, tp)

  require "import"

  import "java.util.zip.*"

  import "java.io.*"

  local function copy(input, output)

    local b = byte[2 ^ 16]

    local l = input.read(b)

    while l > 1 do

      output.write(b, 0, l)

      l = input.read(b)

    end

    output.close()

  end

  local f = File(path)

  local app = {}

  loadstring(tostring(String(LuaUtil.readZip(path, "init.lua"))), "bt", "bt", app)()

  local s = app.appname or f.Name:match("^([^%._]+)")

  local out = activity.getLuaExtDir("project") .. "/" .. s

  if tp == "build" then

    out = activity.getLuaExtDir("bin/.temp") .. "/" .. s

   elseif tp == "plugin" then

    out = activity.getLuaExtDir("plugin") .. "/" .. s

  end

  local d = File(out)

  if autorm then

    local n = 1

    while d.exists() do

      n = n + 1

      d = File(out .. "-" .. n)

    end

  end

  if not d.exists() then

    d.mkdirs()

  end

  out = out .. "/"

  local zip = ZipFile(f)

  local entries = zip.entries()

  for entry in enum(entries) do

    local name = entry.Name

    local tmp = File(out .. name)

    local pf = tmp.ParentFile

    if not pf.exists() then

      pf.mkdirs()

    end

    if entry.isDirectory() then

      if not tmp.exists() then

        tmp.mkdirs()

      end

     else

      copy(zip.getInputStream(entry), FileOutputStream(out .. name))

    end

  end

  zip.close()

  function callback2(s)

    LuaUtil.rmDir(File(activity.getLuaExtDir("bin/.temp")))

    bin_dlg.hide()

    bin_dlg.Message = ""

    if s==nil or not s:find("成功") then

      create_error_dlg()

      error_dlg.Message = s

      error_dlg.show()

    end

  end

  if tp == "build" then

    bin(out)

    return out

   elseif tp == "plugin" then

    snack("导入插件 : " .. s)

    return out

  end

  luadir = out

  luapath = luadir .. "main.lua"

  open(luapath)

  snack("导入工程 : " .. luadir)

  return out

end



function create_import_dlg()

  if import_dlg then

    return

  end

  import_dlg = MaterialAlertDialogBuilder(this)

  import_dlg.Title = "可能需要导入的类"

  import_dlg.setPositiveButton("确定", nil)

  import_dlg.ListView.onItemClick = function(l, v)

    CopyTheText(v.Text)

    import_dlg.hide()

    return true

  end

end


function onActivityResult(req, res, intent)

  if res ~= 0 and intent~=nil then

    if res == 10000 then

      local alypath = intent.getStringExtra("alypath")

      open(alypath)

      mLuaEditor.format()

      return

    end

    local data = intent.getStringExtra("data")

    local _, _, path, line = data:find("\n[	 ]*([^\n]-):(%d+):")

    if path == luapath then

      xpcall(function()mLuaEditor.gotoLine(tonumber(line))end,

      function(err)

        if not activity.getSharedData("ignore_reopen_editor_debugmode_error") then

          MaterialAlertDialogBuilder(this)

          .setTitle("忽略返回值错误？")

          .setMessage("编辑器发生了一个意外。错误详情："..err.."\n点击确认不再弹出。")

          .setPositiveButton("确定", function()activity.setSharedData("ignore_reopen_editor_debugmode_error",true)end)

          .setNegativeButton("取消", nil)

          .show()

         else

          snack("捕获到错误")

        end

      end)

    end

    local classes = require "javaapi.android"

    local c = data:match("a nil value %(global '(%w+)'%)")

    if c then

      local cls = {}

      c = "%." .. c .. "$"

      for k, v in ipairs(classes) do

        if v:find(c) then

          table.insert(cls, string.format("import %q", v))

        end

      end

      if #cls > 0 then

        create_import_dlg()

        import_dlg.setItems(cls)

        import_dlg.show()

      end

    end

  end

end
