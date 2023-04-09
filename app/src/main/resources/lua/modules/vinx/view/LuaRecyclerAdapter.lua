require "import"
local Adapter = import "vinx.ripplelua.LuaRecyclerAdapter"
local ViewHolder = import "vinx.ripplelua.LuaRecyclerViewHolder"

local insert = table.insert
local remove = table.remove
local clear = table.clear

local function LuaRecyclerAdapter(creator)
  return function(data, ...)
    local creator = Adapter.Creator {
      add = creator.add or function(self, v)
        insert(self.data, v)
        self.notifyItemInserted(self.size() - 1)
      end,

      insert = creator.insert or function(self, pos, v)
        insert(self.data, pos, v)
        self.notifyItemInserted(pos - 1)
      end,

      remove = creator.remove or function(self, pos)
        remove(self.data, pos)
        self.notifyItemRemoved(pos - 1)
      end,

      clear = creator.clear or function(self)
        clear(self.data)
        self.notifyDataSetChanged()
      end,

      size = creator.size or function(self)
        return #self.data
      end,

      getItemCount = creator.getItemCount or function(self) 
        return self.size()
      end,

      getItemViewType = creator.getItemViewType or (lambda -> 0),

      onBindViewHolder = creator.onBindViewHolder,

      onCreateViewHolder = creator.onCreateViewHolder
    }

    return Adapter(creator).setData(data)
  end
end

return LuaRecyclerAdapter