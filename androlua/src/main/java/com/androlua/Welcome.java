package com.androlua;

import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import androidx.activity.ComponentActivity;
import com.luajava.LuaFunction;
import com.luajava.LuaState;
import com.luajava.LuaStateFactory;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

public class Welcome extends ComponentActivity {

  private boolean isUpdata;

  private LuaApplication app;

  private String luaMdDir;

  private String localDir;

  private long mLastTime;

  private long mOldLastTime;

  private boolean isVersionChanged;

  private String mVersionName;

  private String mOldVersionName;

  private ArrayList<String> permissions;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    app = (LuaApplication) getApplication();
    luaMdDir = app.f;
    localDir = app.c;
    if (checkInfo()) {
      // new UpdateTask().execute();
      ExecutorService executor = Executors.newSingleThreadExecutor();
      Handler handler = new Handler(Looper.getMainLooper());
      executor.execute(
          () -> {
            onUpdate(mLastTime, mOldLastTime);
            handler.post(
                () -> {
                  startActivity();
                });
          });
    } else {
      startActivity();
    }
  }

  public void startActivity() {
    Intent intent = new Intent(Welcome.this, Main.class);
    if (isVersionChanged) {
      intent.putExtra("isVersionChanged", isVersionChanged);
      intent.putExtra("newVersionName", mVersionName);
      intent.putExtra("oldVersionName", mOldVersionName);
    }
    startActivity(intent);
    // overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out
    //
    // );
    finish();
  }

  public boolean checkInfo() {
    try {
      PackageInfo packageInfo = getPackageManager().getPackageInfo(this.getPackageName(), 0);
      long lastTime = packageInfo.lastUpdateTime;
      String versionName = packageInfo.versionName;
      SharedPreferences info = getSharedPreferences("appInfo", 0);
      String oldVersionName = info.getString("versionName", "");
      if (!versionName.equals(oldVersionName)) {
        SharedPreferences.Editor edit = info.edit();
        edit.putString("versionName", versionName);
        edit.apply();
        isVersionChanged = true;
        mVersionName = versionName;
        mOldVersionName = oldVersionName;
      }
      long oldLastTime = info.getLong("lastUpdateTime", 0);
      if (oldLastTime != lastTime) {
        SharedPreferences.Editor edit = info.edit();
        edit.putLong("lastUpdateTime", lastTime);
        edit.apply();
        isUpdata = true;
        mLastTime = lastTime;
        mOldLastTime = oldLastTime;
        return true;
      }
    } catch (PackageManager.NameNotFoundException e) {
      e.printStackTrace();
    }
    File mainfile = new File(app.getLuaPath("main.lua"));
    if (mainfile.exists() && mainfile.isFile()) { // 不能按exists判断，因为文件可能是文件夹
      return false;
    }
    return true;
  }

  private void onUpdate(long lastTime, long oldLastTime) {

    LuaState L = LuaStateFactory.newLuaState();
    L.openLibs();
    try {
      if (L.LloadBuffer(LuaUtil.readAsset(Welcome.this, "update.lua"), "update") == 0) {
        if (L.pcall(0, 0, 0) == 0) {
          LuaFunction func = L.getFunction("onUpdate");
          if (func != null) func.call(mVersionName, mOldVersionName);
        }
        ;
      }

    } catch (Exception e) {
      // e.printStackTrace();
    }

    try {
      // LuaUtil.rmDir(new File(localDir),".lua");
      // LuaUtil.rmDir(new File(luaMdDir),".lua");
      unApk("assets", localDir);
      unApk("lua", luaMdDir);
      // unZipAssets("main.alp", extDir);
    } catch (IOException e) {
      sendMsg(e.getMessage());
    }
  }

  private void sendMsg(String message) {
    // TODO: Implement this method

  }

  private ZipFile zipFile;
  private String destPath;

  public void unApk(String dir, String extDir) throws IOException {
    ArrayList<String> dirtest = new ArrayList<String>();
    ExecutorService threadPool =
        Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors());
    int i = dir.length() + 1;
    this.destPath = extDir;
    zipFile = new ZipFile(getApplicationInfo().publicSourceDir);
    Enumeration<? extends ZipEntry> entries = zipFile.entries();
    ArrayList<ZipEntry> inzipfile = new ArrayList<ZipEntry>();
    while (entries.hasMoreElements()) {
      ZipEntry zipEntry = entries.nextElement();
      String name = zipEntry.getName();
      if (name.indexOf(dir) != 0) continue;
      String path = name.substring(i);
      String fp = extDir + File.separator + path;
      if (!zipEntry.isDirectory()) {
        inzipfile.add(zipEntry);
        dirtest.add(fp + File.separator);
        continue;
      }
      File file = new File(fp);
      if (!file.exists()) {
        file.mkdirs();
      }
    }
    Iterator<ZipEntry> iter = inzipfile.iterator();
    while (iter.hasNext()) { // 文件处理
      ZipEntry zipEntry = iter.next();
      String name = zipEntry.getName();
      String path = name.substring(i);
      String fp = extDir + File.separator + path;
      Iterator<String> watchiter = dirtest.iterator();
      boolean find = false;
      while (watchiter.hasNext()) {
        String dirtestwatchn = watchiter.next();
        if (fp.startsWith(dirtestwatchn)) {
          find = true;
          break;
        }
      }
      if (find) continue;
      threadPool.execute(new FileWritingTask(zipEntry, path));
    }
    threadPool.shutdown();
    try {
      threadPool.awaitTermination(Long.MAX_VALUE, TimeUnit.NANOSECONDS);
    } catch (InterruptedException e) {
      e.printStackTrace();
      throw new RuntimeException("WelcomeMTUnzip: ExecutorService was interrupted.");
    }
    zipFile.close();
  }

  private class FileWritingTask implements Runnable {
    private final ZipEntry zipEntry;
    private final String path;

    FileWritingTask(ZipEntry zipEntry, String path) {
      this.zipEntry = zipEntry;
      this.path = path;
    }

    @Override
    public void run() {
      File file = new File(destPath + File.separator + path);
      if (file.exists() && file.isDirectory()) { // 保证文件写入，文件夹就算了……
        LuaUtil.rmDir(file);
      }
      File parentFile = file.getParentFile();
      if (!parentFile.exists()) {
        parentFile.mkdirs();
      }
      if (parentFile.isDirectory()) {
        try {
          InputStream inputStream = zipFile.getInputStream(this.zipEntry);
          OutputStream outputStream = new FileOutputStream(file);
          byte[] buffer = new byte[2048];
          int n;
          while ((n = inputStream.read(buffer)) >= 0) {
            outputStream.write(buffer, 0, n);
          }
          outputStream.close();
        } catch (IOException e) {
          e.printStackTrace();
          throw new RuntimeException(
              "WelcomeMTUnzip: unzip error at file " + file.getAbsolutePath() + ".");
        }
      } else {
        throw new RuntimeException(
            "WelcomeMTUnzip: ParentFile( path = \""
                + parentFile.getAbsolutePath()
                + "\" ) is not a directory, the application can't write the File( name = \""
                + file.getName()
                + "\" ) in a file.");
      }
    }
  }
}
