package com.dingyi.adapter;
import android.view.View;
import android.view.ViewGroup;
import androidx.recyclerview.widget.AsyncListDiffer;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.ListAdapter;
import androidx.recyclerview.widget.RecyclerView;
import com.luajava.LuaTable;
import java.lang.reflect.Field;
import java.util.List;

/**
 * @author dingyi
 * @time default
 */
public class LuaDiffRecyclerAdapter extends ListAdapter<LuaTable,LuaDiffRecyclerAdapter.ViewHolder> {


    public static final String TAG = "LuaDiffRecyclerAdapter";
  
    private AsyncListDiffer differ;
    
    public interface LuaInterface {
        View onCreateViewHolder(ViewGroup p1, int p2);
        void onBindViewHolder(LuaDiffRecyclerAdapter.ViewHolder p1, int p2);
        boolean areItemsTheSame(LuaTable p1, LuaTable p2);
        int getItemViewType(int p1);
        boolean areContentsTheSame(LuaTable p1, LuaTable p2);
    }

    public static class DiffUtilItemCallback extends DiffUtil.ItemCallback<LuaTable> {

        private LuaInterface interfaces;

        public DiffUtilItemCallback(LuaInterface interfaces){
            this.interfaces=interfaces;
        }

        @Override
        public boolean areItemsTheSame(LuaTable p1, LuaTable p2) {
            return interfaces.areItemsTheSame(p1,p2);
        }

        @Override
        public boolean areContentsTheSame(LuaTable p1, LuaTable p2) {
            return interfaces.areContentsTheSame(p1,p2);
        }


    }


    
    public class ViewHolder extends RecyclerView.ViewHolder {
        public ViewHolder(View view) {
            super(view);
        }
    }

    private LuaInterface interfaces;

    public LuaDiffRecyclerAdapter(LuaInterface interfaces) {
        super(new DiffUtilItemCallback(interfaces));
        this.interfaces=interfaces;
        Class parent=ListAdapter.class;
        try {
            Field field=parent.getDeclaredField("mHelper");
            field.setAccessible(true);
            differ=(AsyncListDiffer) field.get(this);
        } catch (NoSuchFieldException |IllegalAccessException e) {}
    }

    @Override
    public int getItemViewType(int position) {
        
        return interfaces.getItemViewType(position);
    }

    

    @Override
    public LuaDiffRecyclerAdapter.ViewHolder onCreateViewHolder(ViewGroup p1, int p2) {
        return new ViewHolder(interfaces.onCreateViewHolder(p1,p2));
    }

    @Override
    public void onBindViewHolder(LuaDiffRecyclerAdapter.ViewHolder p1, int p2) {
        interfaces.onBindViewHolder(p1,p2);
    }
  
    
    public List getCurrentList() {
        return differ.getCurrentList();
    }



}
