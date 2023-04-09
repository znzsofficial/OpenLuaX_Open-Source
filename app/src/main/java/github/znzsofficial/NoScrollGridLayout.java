package github.znzsofficial;

import androidx.gridlayout.widget.GridLayout;
import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;

public class NoScrollGridLayout extends GridLayout {
  public NoScrollGridLayout(Context context) {
    super(context);
  }
    
  public NoScrollGridLayout(Context context, AttributeSet attrs) {
    super(context, attrs);
  }

  public NoScrollGridLayout(Context context, AttributeSet attrs, int defStyleAttr) {
    super(context, attrs, defStyleAttr);
  }

  @Override
  public boolean onInterceptTouchEvent(MotionEvent ev) {
    // 禁止滑动
    return false;
  }
}
