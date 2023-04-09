local p={
  "com.open.lua.widget.LuaView",
  "com.open.lua.widget.PhotoView",
  "com.open.lua.widget.LuaFrameLayout",
  "com.open.lua.widget.LuaLinearLayout",
  "com.open.lua.widget.LuaRelativeLayout",
  "com.open.lua.widget.ElasticListView",

  "com.open.lua.util.LuaRC4",
  "com.open.lua.util.LuaFile",
  "com.open.lua.util.LuaJson",
  "com.open.lua.util.LuaString",
  "com.open.lua.util.LuaHandler",
  "com.open.lua.util.LuaWallpaper",

  "github.daisukiKaffuChino.CustomViewPager",
  "github.daisukiKaffuChino.ExtendedEditText",
  "github.daisukiKaffuChino.LuaPagerAdapter",
  "github.daisukiKaffuChino.LuaCustRecyclerAdapter",
  "github.daisukiKaffuChino.LuaCustRecyclerHolder",
  "github.daisukiKaffuChino.LuaMaterialDialog",
  "github.daisukiKaffuChino.NoScrollGridView",
  "github.daisukiKaffuChino.NoScrollListView",
  "github.daisukiKaffuChino.utils.LuaReflectionUtil",
  "github.daisukiKaffuChino.utils.LangUtils",
  "github.daisukiKaffuChino.utils.LuaAppDefender",
  "github.daisukiKaffuChino.utils.LuaLunarCalendar",
  "github.daisukiKaffuChino.utils.LuaThemeUtil",
  "github.daisukiKaffuChino.AdapterCreator",
  "github.daisukiKaffuChino.LuaFileTabView",
  "github.daisukiKaffuChino.utils.GlideRoundTransform",

  "github.znzsofficial.NoScrollGridLayout",
  "vinx.ripplelua.LuaRecyclerViewHolder",
  "vinx.ripplelua.LuaRecyclerAdapter", 
  
  "androidx.annotation.*" ;
  "androidx.appcompat.*" ;
  "androidx.appcompat.app.*" ;
  "androidx.appcompat.content.*" ;
  "androidx.appcompat.content.res.*" ;
  "androidx.appcompat.graphics.*" ;
  "androidx.appcompat.graphics.drawable.*" ;
  "androidx.appcompat.text.*" ;
  "androidx.appcompat.view.*" ;
  "androidx.appcompat.view.menu.*" ;
  "androidx.appcompat.widget.*" ;
  "androidx.arch.*" ;
  "androidx.arch.core.*" ;
  "androidx.arch.core.internal.*" ;
  "androidx.arch.core.util.*" ;
  "androidx.asynclayoutinflater.*" ;
  "androidx.asynclayoutinflater.view.*" ;
  "androidx.cardview.*" ;
  "androidx.cardview.widget.*" ;
  "androidx.collection.*" ;
  "androidx.constraintlayout.*";
  "androidx.constraintlayout.widget.*";
  "androidx.coordinatorlayout.*" ;
  "androidx.coordinatorlayout.widget.*" ;
  "androidx.core.*" ;
  "androidx.core.accessibilityservice.*" ;
  "androidx.core.app.*" ;
  "androidx.core.content.*" ;
  "androidx.core.content.pm.*" ;
  "androidx.core.content.res.*" ;
  "androidx.core.database.*" ;
  "androidx.core.database.sqlite.*" ;
  "androidx.core.graphics.*" ;
  "androidx.core.graphics.drawable.*" ;
  "androidx.core.hardware.*" ;
  "androidx.core.hardware.display.*" ;
  "androidx.core.hardware.fingerprint.*" ;
  "androidx.core.internal.*" ;
  "androidx.core.internal.view.*" ;
  "androidx.core.math.*" ;
  "androidx.core.net.*" ;
  "androidx.core.os.*" ;
  "androidx.core.provider.*" ;
  "androidx.core.text.*" ;
  "androidx.core.text.util.*" ;
  "androidx.core.util.*" ;
  "androidx.core.view.*" ;
  "androidx.core.view.accessibility.*" ;
  "androidx.core.view.animation.*" ;
  "androidx.core.view.inputmethod.*" ;
  "androidx.core.widget.*" ;
  "androidx.cursoradapter.*" ;
  "androidx.cursoradapter.widget.*" ;
  "androidx.customview.*" ;
  "androidx.customview.view.*" ;
  "androidx.customview.widget.*" ;
  "androidx.documentfile.*" ;
  "androidx.documentfile.provider.*" ;
  "androidx.drawerlayout.*" ;
  "androidx.drawerlayout.widget.*" ;
  "androidx.fragment.*" ;
  "androidx.fragment.app.*" ;
  "androidx.gridlayout.*";
  "androidx.gridlayout.widget.*";
  "androidx.interpolator.*" ;
  "androidx.interpolator.view.*" ;
  "androidx.interpolator.view.animation.*" ;
  "androidx.legacy.*" ;
  "androidx.legacy.app.*" ;
  "androidx.legacy.content.*" ;
  "androidx.legacy.coreui.*" ;
  "androidx.legacy.coreutils.*" ;
  "androidx.legacy.widget.*" ;
  "androidx.lifecycle.*" ;
  "androidx.loader.*" ;
  "androidx.loader.app.*" ;
  "androidx.loader.content.*" ;
  "androidx.localbroadcastmanager.*" ;
  "androidx.localbroadcastmanager.content.*" ;
  "androidx.print.*" ;
  "androidx.recyclerview.*" ;
  "androidx.recyclerview.widget.*" ;
  "androidx.slidingpanelayout.*" ;
  "androidx.slidingpanelayout.widget.*" ;
  "androidx.swiperefreshlayout.*" ;
  "androidx.swiperefreshlayout.widget.*" ;
  "androidx.transition.*" ;
  "androidx.vectordrawable.*" ;
  "androidx.vectordrawable.graphics.*" ;
  "androidx.vectordrawable.graphics.drawable.*" ;
  "androidx.versionedparcelable.*" ;
  "androidx.viewpager.*" ;
  "androidx.viewpager.widget.*" ;
  "com.google.*" ;
  "com.google.android.*" ;
  "com.google.android.material.*" ;
  "com.google.android.material.animation.*" ;
  "com.google.android.material.appbar.*" ;
  "com.google.android.material.behavior.*" ;
  "com.google.android.material.bottomappbar.*" ;
  "com.google.android.material.bottomnavigation.*" ;
  "com.google.android.material.bottomsheet.*" ;
  "com.google.android.material.button.*" ;
  "com.google.android.material.canvas.*" ;
  "com.google.android.material.card.*" ;
  "com.google.android.material.chip.*" ;
  "com.google.android.material.circularreveal.*" ;
  "com.google.android.material.circularreveal.cardview.*" ;
  "com.google.android.material.circularreveal.coordinatorlayout.*" ;
  "com.google.android.material.drawable.*" ;
  "com.google.android.material.expandable.*" ;
  "com.google.android.material.floatingactionbutton.*" ;
  "com.google.android.material.internal.*" ;
  "com.google.android.material.materialswitch.*";
  "com.google.android.material.math.*" ;
  "com.google.android.material.navigation.*" ;
  "com.google.android.material.resources.*" ;
  "com.google.android.material.ripple.*" ;
  "com.google.android.material.shadow.*" ;
  "com.google.android.material.shape.*" ;
  "com.google.android.material.snackbar.*" ;
  "com.google.android.material.switchmaterial.*";
  "com.google.android.material.stateful.*" ;
  "com.google.android.material.textview.*";
  "com.google.android.material.progressindicator.*";
  "com.google.android.material.tabs.*" ;
  "com.google.android.material.textfield.*" ;
  "com.google.android.material.theme.*" ;
  "com.google.android.material.transformation.*" ;
}

for k,v pairs(p)
  import(v)
end