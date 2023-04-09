import "mods.vinx.material.menu.PopupMenuUtils"

local Snackbar = luajava.bindClass "com.google.android.material.snackbar.Snackbar"
local function snack(content)
  Snackbar.make(mContent,tostring(content),Snackbar.LENGTH_SHORT).setAnchorView(ps_bar).show()
end

local _M={}

_M.setTab=function(path)

  --智商封印 tab设置
  tabTable[path] = tabTable[path] or {}
  if not tabTable[path].showed
    local tab=mTab.newTab()
    local pathName=path:match(".*/(.*)")
    -- 使用正则表达式匹配
    local pattern = "^" .. app_root_pro_dir .. "(.*)/"
    local subfolder = string.match(path, pattern).."/"
    local projectName = subfolder:match("/(.-)/")
    local _subfolder = subfolder:match("/(.+)")

    tab.setText(pathName)

    local view=tab.view
    view.onLongClick=function(v)
      local popupMenu=PopupMenu(activity,v)
      local menu=popupMenu.getMenu()
      if tabtitle then
        PopupMenuUtils.setHeaderTitle(popupMenu, _subfolder)
      end
      menu.add("关闭当前").onMenuItemClick=function(a)
        if mTab.getTabCount() == 1 then
          snack("为避免文件被异常清空，不再允许关闭最后一个文件")
         else
          for i in pairs(tabTable) do
            local _o = tabTable[i].o
            if _o == tab
              tabTable[i].showed=nil
              tabTable[i]=nil
              mTab.removeTab(_o)
            end
          end
          --[[if mTab.getTabCount()==0
          mTitle.Text="未打开工程"
          mSubTitle.Text="未打开文件"
          mLuaEditor.Text=""
          task(10,function()
            updataList(app_root_pro_dir)
          end)
        end]]
        end
      end
      menu.add("关闭其他").onMenuItemClick=function(a)
        if mTab.getTabCount() == 1 then
          snack("没有其他的了😡")
         else
          for i in pairs(tabTable) do
            local _o = tabTable[i].o
            if _o ~= tab
              tabTable[i].showed=nil
              tabTable[i]=nil
              mTab.removeTab(_o)
            end
          end
        end
      end
      --[[menu.add("关闭全部").onMenuItemClick=function(a)
        for i in pairs(tabTable) do
          local _o = tabTable[i].o
          tabTable[i].showed=nil
          tabTable[i]=nil
          mTab.removeTab(_o)
        end
        if mTab.getTabCount()==0
          mTitle.Text="未打开工程"
          mSubTitle.Text="未打开文件"
          mLuaEditor.Text=""
          task(10,function()
            updataList(app_root_pro_dir)
          end)
        end
      end]]
      menu1 = menu.addSubMenu("复制")
      menu1.add("文件名").onMenuItemClick=function()
        activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(pathName)
      end
      menu1.add("项目名").onMenuItemClick=function()
        activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(projectName)
      end
      menu1.add("完整路径").onMenuItemClick=function()
        activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(path)
      end
      popupMenu.show()
      return true
    end

    tabTable[path].o=tab
    --首次打开文件时tab还没有tag这个字段，所以直接捕获异常
    tabTable[path].o.tag=path

    tabTable[path].showed=true
    --mTab.addTab(tab,0)
    mTab.addTab(tab,mTab.getTabCount())
    tab.select()
   else
    --if tabTable[path].o == mTab.getTabAt(mTab.getSelectedTabPosition())
    --snack("已经打开"..tostring(tabTable[path].o))
    --else
    tabTable[path].o.select()
    --end
  end
end

return _M