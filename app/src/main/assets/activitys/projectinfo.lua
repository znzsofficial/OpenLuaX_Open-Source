require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "com.google.android.material.textfield.TextInputEditText"
import "com.google.android.material.textfield.TextInputLayout"
import "com.google.android.material.materialswitch.MaterialSwitch"
import "com.google.android.material.button.MaterialButton"
import "androidx.appcompat.widget.AppCompatSpinner"
import "com.google.android.material.textview.MaterialTextView"
import "com.google.android.material.dialog.MaterialAlertDialogBuilder"


require "permission"
local layout={
  ScrollView,
  layout_width="fill";
  {
    LinearLayout;
    layout_width="fill";
    orientation="vertical";
    {
      LinearLayout;
      layout_width="fill";
      orientation="vertical";
      layout_marginLeft="16dp";
      layout_marginRight="16dp";
      {
        TextInputLayout;
        hint="名称";
        layout_width="fill";
        layout_marginTop="8dp";
        {
          TextInputEditText;
          layout_width="fill";
          layout_height="fill";
          id="appname";
          singleLine=true;
        };
      };
      {
        TextInputLayout;
        hint="版本";
        layout_width="fill";
        layout_marginTop="8dp";
        {
          TextInputEditText;
          layout_width="fill";
          layout_height="fill";
          id="appver";
          singleLine=true;
        };
      };
      {
        TextInputLayout;
        hint="Code";
        layout_width="fill";
        layout_marginTop="8dp";
        {
          TextInputEditText;
          layout_width="fill";
          layout_height="fill";
          id="appcode";
          singleLine=true;
        };
      };

      {
        TextInputLayout;
        hint="SDK";
        layout_width="fill";
        layout_marginTop="8dp";
        {
          TextInputEditText;
          layout_width="fill";
          layout_height="fill";
          id="appsdk";
          singleLine=true;
        };
      };
      {
        TextInputLayout;
        hint="关联";
        layout_width="fill";
        layout_marginTop="8dp";
        {
          TextInputEditText;
          layout_width="fill";
          layout_height="fill";
          id="path_pattern";
          singleLine=true;
        };
      };
      {
        TextInputLayout;
        hint="包名";
        layout_width="fill";
        layout_marginTop="8dp";
        {
          TextInputEditText;
          layout_width="fill";
          layout_height="fill";
          id="packagename";
          singleLine=true;
        };
      };
      {
        TextInputLayout;
        hint="key";
        layout_width="fill";
        layout_marginTop="8dp";
        {
          TextInputEditText;
          layout_width="fill";
          layout_height="fill";
          id="app_key";
          singleLine=true;
        };
      };
      {
        TextInputLayout;
        hint="渠道";
        layout_width="fill";
        layout_marginTop="8dp";
        {
          TextInputEditText;
          layout_width="fill";
          layout_height="fill";
          id="app_channel";
          singleLine=true;
        };
      };
      {
        TextInputLayout;
        hint="作者";
        layout_width="fill";
        layout_marginTop="8dp";
        {
          TextInputEditText;
          layout_width="fill";
          layout_height="fill";
          id="developer";
          singleLine=true;
        };
      };
      {
        TextInputLayout;
        hint="描述";
        layout_width="fill";
        layout_marginTop="8dp";
        {
          TextInputEditText;
          layout_width="fill";
          layout_height="fill";
          id="description";
          singleLine=true;
        };
      };
    };
    {
      LinearLayout;
      orientation="horizontal";
      layout_width="fill";
      {
        MaterialTextView;
        text="主题";
        textSize="16sp";
        layout_marginLeft="16dp";
      };
      {
        AppCompatSpinner;
        id="tlist";
      };
    };
    {
      MaterialSwitch;
      id="debugmode";
      text="调试";
      padding="16dp";
      layout_width="fill";
      textSize="16sp";
    };
    {
      MaterialButton;
      text="更改权限";
      id="btn",
      layout_width="fill";
      layout_margin="16dp";
    };
  };

}

activity.setTitle('工程属性')
MDC_R=luajava.bindClass"com.google.android.material.R"
activity.theme=MDC_R.style.Theme_Material3_DynamicColors_DayNight
activity.setContentView(loadlayout(layout))

--plist=ListView(activity)
--[[
dlg=MaterialAlertDialogBuilder(activity)

dlg.title="更改权限"
--dlg.view=plist
dlg.setPositiveButton("确定",nil)]]
btn.onClick=function()
  --dlg.show()
  local checkedList={}
  for index,content in ipairs(ps) do
    table.insert(checkedList,not not(pcs[content]))
  end
  MaterialAlertDialogBuilder(this)
  .setTitle("更改权限")
  .setMultiChoiceItems(pss,checkedList,function(dialog,which,isChecked)
    checkedList[which+1]=isChecked
  end)
  .setPositiveButton("关闭",function()
    --table.clear(rs)
    for index,content in ipairs(ps) do
      pcs[content]=checkedList[index]
      --[[
      if checkedList[index] then
        
        --table.insert(rs,content)
      end]]
    end
  end)
  .show()
end

projectdir=...
luaproject=projectdir.."/init.lua"
app={}
loadfile(luaproject,"bt",app)()
appname.Text=app.appname or "OpenLua"
appver.Text=app.appver or "1.0"
appcode.Text=app.appcode or "1"
appsdk.Text=app.appsdk or "15"
path_pattern.Text=app.path_pattern or ""
packagename.Text=app.packagename or "com.openlua"
developer.Text=app.developer or ""
description.Text=app.description or ""
debugmode.Checked=app.debugmode==nil or app.debugmode
app_key.Text=app.app_key or ""
app_channel.Text=app.app_channel or ""

--plist.ChoiceMode=ListView.CHOICE_MODE_MULTIPLE;
pss={}
ps={}
for k,v in pairs(permission_info) do
  table.insert(ps,k)
end
table.sort(ps)

for k,v in ipairs(ps) do
  table.insert(pss,permission_info[v])
end

--adp=ArrayListAdapter(activity,android.R.layout.simple_list_item_multiple_choice,String(pss))
--plist.Adapter=adp
--rs=app.user_permission or {}

pcs={}
for k,v in ipairs(app.user_permission or {}) do
  pcs[v]=true
end
--[=[
checked={}
for k,v in ipairs(ps) do
  table.insert(checked,pcs[v] or false)
  --[[
  if pcs[v] then
    plist.setItemChecked(k-1,true)
  end]]
end]=]
--[[
dlg.setMultiChoiceItems(String(pss), (checked), nil)
dlg=dlg.create()
--dlg.show()
plist=dlg.getListView()]]


local fs=luajava.astable(android.R.style.getFields())
local tss={"Theme"}
for k,v in ipairs(fs) do
  local nm=v.Name
  if nm:find("^Theme_") then
    table.insert(tss,nm)
  end
end

tadp=ArrayAdapter(activity,android.R.layout.simple_list_item_1, String(tss))
tlist.Adapter=tadp

for k,v in ipairs(tss) do
  if v==app.theme then
    tlist.setSelection(k-1)
  end
end

function callback(c,j)
  print(dump(j))
end

local template=[[
appname="%s"
appver="%s"
appcode="%s"
appsdk="%s"
path_pattern="%s"
packagename="%s"
theme="%s"
app_key="%s"
app_channel="%s"
developer="%s"
description="%s"
debugmode=%s
user_permission={
  %s
}
]]
local function dump(t)
  for k,v in ipairs(t) do
    t[k]=string.format("%q",v)
  end
  return table.concat(t,",\n  ")
end

function onCreateOptionsMenu(menu)
  menu.add("保存").setShowAsAction(1)
end

--rs={}
function onOptionsItemSelected(item)
  if appname.Text=="" or appver.Text=="" or packagename.Text=="" then
    Toast.makeText(activity,"项目不能为空",500).show()
    return true
  end
  --[[
  local cs=plist.getCheckedItemPositions()
  local rs={}
  for n=1,#ps do
    if cs.get(n-1) then
      table.insert(rs,ps[n])
    end
  end]]
  local rs={}
  for n=1,#ps do
    if pcs[ps[n]] then
      table.insert(rs,ps[n])
    end
  end
  local thm=tss[tlist.getSelectedItemPosition()+1]
  local ss=string.format(template,appname.Text,appver.Text,appcode.Text,appsdk.Text,path_pattern.Text,packagename.Text,thm,app_key.Text,app_channel.Text,developer.Text,description.Text,debugmode.isChecked(),dump(rs))
  local f=io.open(luaproject,"w")
  f:write(ss)
  f:close()
  Toast.makeText(activity, "已保存.", Toast.LENGTH_SHORT ).show()
  activity.result({appname.Text})
end

lastclick=os.time()-2
function onKeyDown(e)
  local now=os.time()
  if e==4 then
    if now-lastclick>2 then
      Toast.makeText(activity, "再按一次返回.", Toast.LENGTH_SHORT ).show()
      lastclick=now
      return true
    end
  end
end
