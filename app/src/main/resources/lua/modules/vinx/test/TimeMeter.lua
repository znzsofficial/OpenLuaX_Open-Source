local System = luajava.bindClass "java.lang.System"

local _M = {
  points = {System.nanoTime()},
  callback = function(i)
    print(tostring(i / 1000).." ms")
  end
}

_M.newInstance = function(self, callback)
  local obj = table.clone(self)
  if callback then obj.callback = callback end
  return obj
end

_M.addPoint = function(self)
  local time = System.nanoTime()
  table.insert(self.points, time)
  return time
end

_M.record = function(self)
  local time = self:addPoint() - 
    (self.points[#self.points - 1])
  self.callback(time)
end

_M.callAndCount = function(func)
  assert(getmetatable(func) == _M, 
    "The static method cannot be called by an instance! ")
  local start = System.nanoTime()
  func()
  local time = System.nanoTime() - start
  self.callback(time)
  return time
end

_M.getTotalTime = function(self)
  return self.points[#self.points]
    - self.points[1]
end

setmetatable(_M, {
  __call = lambda v, callback
    -> v:newInstance(callback)
})

return _M