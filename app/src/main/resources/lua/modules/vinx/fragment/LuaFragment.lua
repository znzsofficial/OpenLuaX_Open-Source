-- create on 2022/8/14 / ikimasho
-- please fix if there's something wrong

import "android.os.Bundle"
import "androidx.fragment.app.Fragment"

local LuaFragment={}
LuaFragment.__index = LuaFragment

local function BaseFragment(t)
  return luajava.override(Fragment, t)
end

local create = function()
  local self = { interface = nil }
  self.fragment = "override the fragment"
  return setmetatable(self, LuaFragment)
end

function LuaFragment.newInstance(self)
  local bundle = Bundle()
  self.fragment = BaseFragment(self.interface)
  self.fragment.setArguments(bundle)
  return self.fragment
end

function LuaFragment.initCreator(self, creator)
  assert(type(creator) == "table", "required a table")
  -- so we override the interface here
  self.interface = {
    -- this looks so fucking ugly i dont like it
    onCreate = function(super, savedInstanceState)
      if creator.onCreate then creator.onCreate(savedInstanceState) end
      super(savedInstanceState)
    end,
    onCreateView = function(super, inflater, container, savedInstanceState)
      -- here we create our view
      if not creator.onCreateView then
        error("please override onCreateView")
       else
        return creator.onCreateView(inflater, container, savedInstanceState)
      end
      return super(inflater, container, savedInstanceState)
    end,
    onActivityCreated = function(super, savedInstanceState)
      super(savedInstanceState)
      if creator.onActivityCreated then creator.onActivityCreated(savedInstanceState) end
    end,
    onViewCreated = function(super, view, savedInstanceState)
      super(view, savedInstanceState)
      if creator.onViewCreated then creator.onViewCreated(view, savedInstanceState) end
    end,
    onViewStateRestored = function(super, savedInstanceState)
      super(savedInstanceState)
      if creator.onViewStateRestored then creator.onViewStateRestored(savedInstanceState) end
    end,
    onSaveInstanceState = function(super, outState)
      super(outState)
      if creator.onSaveInstanceState then creator.onSaveInstanceState(outState) end
    end,
    onConfigurationChanged = function(super, newConfig)
      super(newConfig)
      if creator.onConfigurationChanged then creator.onConfigurationChanged(newConfig) end
    end,
    onAttach = function(super, context)
      super(context) if creator.onAttach then creator.onAttach(context) end
    end,
    onStart = function(super)
      super() if creator.onStart then creator.onStart() end
    end,
    onResume = function(super)
      super() if creator.onResume then creator.onResume() end
    end,
    onStop = function(super)
      super() if creator.onStop then creator.onStop() end
    end,
    onDestroyView = function(super)
      super()
      if creator.onDestroyView then creator.onDestroyView() end
    end,
    onDestroy = function(super)
      super() if creator.onDestroy then creator.onDestroy() end
    end,
    onDetach = function(super)
      super() if creator.onDetach then creator.onDetach() end
    end
  }
end

return create