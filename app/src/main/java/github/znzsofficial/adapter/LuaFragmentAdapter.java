package github.znzsofficial.adapter;

import android.view.View;
import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.viewpager2.adapter.FragmentStateAdapter;
import com.androlua.LuaActivity;
import com.androlua.LuaFragment;

public class LuaFragmentAdapter extends FragmentStateAdapter {

  public Creator creator;
  private LuaActivity mContext;

  public LuaFragmentAdapter(@NonNull LuaActivity context, @NonNull Creator inter) {
    super(context.getSupportFragmentManager(), context.getLifecycle());
    mContext = context;
    creator = inter;
  }

  @Override
  public Fragment createFragment(int position) {
    try {
      // 根据位置返回对应的 Fragment
      return creator.createFragment(position);
    } catch (Exception e) {
      e.printStackTrace();
      if (mContext != null) {
        mContext.sendError("FragmentAdapter", e);
      }
      return new LuaFragment(new View(mContext));
    }
  }

  @Override
  public int getItemCount() {
    try {
      // 返回 Fragment 的数量
      return (int) creator.getItemCount();
    } catch (Exception e) {
      e.printStackTrace();
      if (mContext != null) {
        mContext.sendError("FragmentAdapter", e);
      }
      return 0;
    }
  }

  public interface Creator {
    Fragment createFragment(int i);

    long getItemCount();
  }
}
