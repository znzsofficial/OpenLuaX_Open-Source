require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "com.myopicmobile.textwarrior.common.*"
import "com.google.android.material.progressindicator.CircularProgressIndicator"
import "android.content.*"
import "layout2"
local rs
local classes=require "android"
activity.setTitle('需要导入的类')
local MDC_R=luajava.bindClass"com.google.android.material.R"
activity.theme=MDC_R.style.Theme_Material3_DynamicColors_DayNight
activity.setContentView(loadlayout(layout2))

function fiximport(path)
  local table = table
  local classes=require "android"
  local searchpath=path:gsub("[^/]+%.lua","?.lua;")..path:gsub("[^/]+%.lua","?.aly;")
  local cache={}
  function checkclass(path,ret)
    if cache[path] then
      return
    end
    cache[path]=true
    local f=io.open(path)
    local str=f:read("a")
    f:close()
    if not str then
      return
    end
    for s,e,t in str:gfind("import \"([%w%.]+)\"") do
      local p=package.searchpath(t,searchpath)
      if p then
        checkclass(p,ret)
      end
    end
    local lex=LuaLexer(str)
    local buf={}
    local last=nil
    while true do
      local t=lex.advance()
      if not t then
        break
      end
      if last~=LuaTokenTypes.DOT and t==LuaTokenTypes.NAME then
        local text=lex.yytext()
        buf[text]=true
      end
      last=t
    end
    table.sort(buf)

    for k,v in pairs(buf) do
      k="[%.$]"..k.."$"
      for a,b in ipairs(classes) do
        if string.find(b,k) then
          if cache[b]==nil then
            ret[#ret+1]=b
            cache[b]=true
          end
        end
      end
    end
  end
  local ret={}
  checkclass(path,ret)

  return String(ret)
end

dir,path=...
--path=luajava.luapath
list=ListView(activity)
list.ChoiceMode=ListView.CHOICE_MODE_MULTIPLE;
task(fiximport,path,function(v)
  rs=v
  adp=ArrayListAdapter(activity,android.R.layout.simple_list_item_multiple_choice,v)
  list.Adapter=adp
  activity.setContentView(list)
end)
--Toast.makeText(activity,"正在分析。。。",1000).show()
function onCreateOptionsMenu(menu)
  menu.add("反选").setShowAsAction(1)
  menu.add("复制").setShowAsAction(1)
end

local cm=activity.getSystemService(Context.CLIPBOARD_SERVICE)

function onOptionsItemSelected(item)
  if item.Title=="复制" then
    local buf={}

    local cs=list.getCheckedItemPositions()
    local buf={}
    for n=0,#rs-1 do
      if cs.get(n) then
        table.insert(buf,string.format("import \"%s\"",rs[n]))
      end
    end

    local str=table.concat(buf,"\n")
    local cd = ClipData.newPlainText("label", str)
    cm.setPrimaryClip(cd)
    Toast.makeText(activity,"已复制的剪切板",1000).show()
   elseif item.title=="反选" then
    for n=0,#rs-1 do
      list.setItemChecked(n,not list.isItemChecked(n))
    end
  end
end
