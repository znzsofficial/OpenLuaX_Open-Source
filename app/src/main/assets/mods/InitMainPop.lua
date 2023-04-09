local _M={}

local Snackbar = luajava.bindClass "com.google.android.material.snackbar.Snackbar"
local function snack(content)
  Snackbar.make(mContent,tostring(content),Snackbar.LENGTH_SHORT).setAnchorView(ps_bar).show()
end

_M.init=function()

  _M.pop =PopupMenu(activity,mMores)

  local menu=_M.pop.Menu

  menu1 = menu.addSubMenu("文件")

  menu2 = menu.addSubMenu("工程")

  menu3 = menu.addSubMenu("代码")

  menu4 = menu.addSubMenu("工具")

  menu5 = menu.addSubMenu("设置")

  menu1.add("保存").onMenuItemClick=function(a)

    save()

    snack("文件已保存")

  end

  menu1.add("编译").onMenuItemClick=function(a)

    if mSubTitle.Text=="未打开文件" then

      snack("未打开文件,不能编译")

      return

    end

    save()

    local path,str = console.build(mSubTitle.Text)

    if path then

      snack("编译完成 : " .. path)

     else

      snack("编译出错 : " .. str)

    end

  end

  menu2.add("打包").onMenuItemClick=function(a)

    if mTitle.Text=="未打开工程" then

      snack("未打开工程,不能打包")

      return

    end

    save()

    bin(app_root_pro_dir .."/".. mTitle.Text .. "/")

  end

  menu2.add("导出").onMenuItemClick=function(a)

    if mTitle.Text=="未打开工程" then

      snack("未打开工程,不能导出")

      return

    end

    save()

    p = export(app_root_pro_dir .."/".. mTitle.Text)

    snack("工程已导出")

  end


  menu2.add("导出并分享").onMenuItemClick=function(a)

    if mTitle.Text=="未打开工程" then

      snack("未打开工程,不能导出")

      return

    end

    save()

    local p = ShareAndExport(app_root_pro_dir .."/".. mTitle.Text)

    if p then

      activity.shareFile(p)

    end

  end

  menu2.add("属性").onMenuItemClick=function(a)

    if mTitle.Text=="未打开工程" then

      snack("未打开工程,不能设置属性")

      return

    end

    save()

    activity.newActivity("activitys/projectinfo", { app_root_pro_dir .."/".. mTitle.Text , })

  end

  menu3.add("代码对齐").onMenuItemClick=function(a)

    mLuaEditor.format()

  end

  menu3.add("导入分析").onMenuItemClick=function(a)

    if mTitle.Text=="未打开工程" then

      snack("未打开工程,不能导入分析")

      return

    end

    save()

    local luaproject = app_root_pro_dir.."/"..mTitle.Text

    local luapath = mSubTitle.Text

    save()

    activity.newActivity("javaapi/fiximport", { luaproject, luapath })

  end

  menu3.add("代码搜索").onMenuItemClick=function(a)

    --mSearch
    mSearch.setVisibility(View.VISIBLE)

  end

  menu3.add("代码查错").onMenuItemClick=function(a)

    local src = mLuaEditor.getText().toString()

    local path = mSubTitle.getText()

    if ends(path,".aly") then

      src = "return " .. src

    end

    local _, data = loadstring(src)

    if data then

      local _, _, line, data = data:find(".(%d+).(.+)")

      mLuaEditor.gotoLine(tonumber(line))

      snack(line .. ":" .. data)

      return true

     elseif b then

     else

      snack("没有语法错误")

    end

  end


  _menu3_ = menu3.addSubMenu("查看日志")

  _menu3_.add("Lua调试信息").onMenuItemClick=function(a)

    activity.newActivity("logcat")

  end

  _menu3_.add("Java崩溃信息").onMenuItemClick=function(a)

    activity.newActivity("activitys/crash_activity",{ last_theme })

  end

  menu3.add("Java浏览器").onMenuItemClick=function(a)

    local luaproject = app_root_pro_dir.."/"..mTitle.Text
    activity.newActivity("javaapi/main", { luaproject })

  end

  menu4.add("Lua参考文档").onMenuItemClick=function(a)

    activity.newActivity("activitys/luadoc_activity",{ last_theme })

  end

  menu4.add("布局助手").onMenuItemClick=function(a)

    save()

    local luaproject = app_root_pro_dir.."/"..mTitle.Text

    local luapath = mSubTitle.Text

    activity.newActivity("activitys/layouthelper/main", { luaproject, luapath ,last_theme })

  end

  menu4.add("取色器").onMenuItemClick=function(a)

    colorGetterLayout=
    {
      LinearLayoutCompat;
      orientation="vertical";
      layout_width="fill";
      layout_height="fill";
      gravity="center";
      {
        MaterialCardView;
        id="ColorCard";
        layout_margin="10dp";
        radius="40dp",
        elevation="0dp",
        layout_width="20%w";
        layout_height="20%w";
      };
      {
        MaterialTextView;
        layout_margin="0dp";
        textSize="12sp";
        id="ColorText";
        textColor=标题文字颜色;
      };
      {
        AppCompatSeekBar;
        id="SeekOne";
        layout_margin="15dp";
        layout_width="match";
        layout_height="wrap";
      };
      {
        AppCompatSeekBar;
        id="SeekTwo";
        layout_margin="15dp";
        layout_width="match";
        layout_height="wrap";
      };
      {
        AppCompatSeekBar;
        id="SeekThree";
        layout_margin="15dp";
        layout_width="match";
        layout_height="wrap";
      };
      {
        AppCompatSeekBar;
        id="SeekFour";
        layout_margin="15dp";
        layout_width="match";
        layout_height="wrap";
      };
    };
    --对话框View
    local colorGetter=loadlayout(colorGetterLayout)

    SeekOne.setMax(255)
    SeekTwo.setMax(255)
    SeekThree.setMax(255)
    SeekFour.setMax(255)
    SeekOne.setProgress(0xff)
    SeekTwo.setProgress(0xff)
    SeekThree.setProgress(0xff)
    SeekFour.setProgress(0xff)

    --监听
    SeekOne.setOnSeekBarChangeListener{
      onProgressChanged=function(view, i)
        updateArgb()
      end
    }

    SeekTwo.setOnSeekBarChangeListener{
      onProgressChanged=function(view, i)
        updateArgb()
      end
    }

    SeekThree.setOnSeekBarChangeListener{
      onProgressChanged=function(view, i)
        updateArgb()
      end
    }

    SeekFour.setOnSeekBarChangeListener{
      onProgressChanged=function(view, i)
        updateArgb()
      end
    }

    --更新颜色
    function updateArgb()
      local a=SeekOne.getProgress()
      local r=SeekTwo.getProgress()
      local g=SeekThree.getProgress()
      local b=SeekFour.getProgress()
      local argb_hex=(a<<24|r<<16|g<<8|b)
      ColorText.Text=string.format("%#x", argb_hex)
      ColorCard.setCardBackgroundColor(argb_hex)
    end
    --翻译进度
    local argbBuild=MaterialAlertDialogBuilder(this)
    .setView(colorGetter)
    .setTitle("取色器")
    .setPositiveButton("复制", {
      onClick=function(view)
        local a=SeekOne.getProgress()
        local r=SeekTwo.getProgress()
        local g=SeekThree.getProgress()
        local b=SeekFour.getProgress()
        local argb_hex=(a<<24|r<<16|g<<8|b)
        local argb_str=string.format("%#x", argb_hex)
        activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(argb_str)
      end
    })
    .setNegativeButton("取消",{onClick=function()end})
    local argbDialog=argbBuild.create()
    .setCanceledOnTouchOutside(false)
    function showArgbDialog()
      argbDialog.show()
      updateArgb()
    end
    showArgbDialog()
  end

  menu4.add("忽略电池优化").onMenuItemClick=function(a)
    import "android.provider.Settings"
    import "android.content.Intent"
    import "android.net.Uri"
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
      powerManager = this.getSystemService(this.POWER_SERVICE);
      hasIgnored = powerManager.isIgnoringBatteryOptimizations(this.getPackageName());
      --判断当前APP是否有加入电池优化的白名单，如果没有，弹出加入电池优化的白名单的设置对话框。
      if (hasIgnored!=true)
        intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
        intent.setData(Uri.parse("package:"..activity.getPackageName()));
        this.startActivity(intent);
       else
        snack("已授权")
      end
    end
  end

  menu4.add("申请Android/data权限").onMenuItemClick=function(a)
    import "android.content.Intent"
    import "android.net.Uri"
    import "android.provider.DocumentsContract"
    import "androidx.documentfile.provider.DocumentFile"
    uri=Uri.parse("content://com.android.externalstorage.documents/tree/primary%3AAndroid%2Fdata");
    intent=Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
    intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION|Intent.FLAG_GRANT_WRITE_URI_PERMISSION|Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION|Intent.FLAG_GRANT_PREFIX_URI_PERMISSION)
    intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI,DocumentFile.fromTreeUri(activity,uri).getUri())
    activity.startActivity(intent)
  end

  menu5.add("编辑器设置").onMenuItemClick=function(a)

    import "com.google.android.material.materialswitch.MaterialSwitch"

    mDialog=MaterialAlertDialogBuilder(this)

    .setTitle("编辑器设置")

    .setNegativeButton("取消",nil)

    mDialog.setView(loadlayout("alys.editor_setting"))

    mDialog.show()

    sw1.setChecked(newfont)
    sw2.setChecked(tabtitle)

    sw1.setOnCheckedChangeListener{
      onCheckedChanged=function(v)

        newfont=v.isChecked()

        write(activity.getLuaDir().."/config/config.lua", string.format("newfont=%q", newfont).."\n"..string.format("tabtitle=%q", tabtitle))

        if newfont
          codeTypeFace=Typeface.createFromFile(File(activity.getLuaDir().."/font/code2.ttf"))
         else
          codeTypeFace=Typeface.createFromFile(File(activity.getLuaDir().."/font/code.ttf"))
        end

        mLuaEditor.setTypeface(codeTypeFace)

      end
    }

    sw2.setOnCheckedChangeListener{
      onCheckedChanged=function(v)

        tabtitle=v.isChecked()

        write(activity.getLuaDir().."/config/config.lua", string.format("newfont=%q", newfont).."\n"..string.format("tabtitle=%q", tabtitle))

      end
    }

  end

  menu5.add("UiMode").onMenuItemClick=function(a)

    import "androidx.appcompat.app.AppCompatDelegate"

    MaterialAlertDialogBuilder(this)

    .setTitle("UiMode")

    .setItems({"跟随系统","浅色模式","深色模式"},function(d,i)

      switch i

       case 0

        save()

        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM)

        activity.overridePendingTransition(android.R.anim.fade_in,android.R.anim.fade_out)

        activity.recreate()

       case 1

        save()

        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)

        activity.overridePendingTransition(android.R.anim.fade_in,android.R.anim.fade_out)

        activity.recreate()

       case 2

        save()

        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES)

        activity.overridePendingTransition(android.R.anim.fade_in,android.R.anim.fade_out)

        activity.recreate()

      end

    end)

    .show()

  end

  menu.add("关于").onMenuItemClick=function(a)

    onVersionChanged("","")

  end

end

_M.show=function()
  _M.pop.show()
end

return _M