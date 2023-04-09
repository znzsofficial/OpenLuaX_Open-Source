require "utf8"

local find = utf8.find
local sub = utf8.sub
local insert = table.insert

table.slice = function(t, first, last, step)
  local sliced = {}
  for i = first or 1, last or #t, step or 1 do
    sliced[#sliced + 1] = t[i]
  end
  return sliced
end

string.split = function(str, regex, limit)
  local limit = limit or 0
  local index = 1
  local matchLimited = limit > 0
  local matchList = {}
  
  local start, ends = find(str, regex)
  -- Add segments before each match found
  while start ~= nil do
    if (not matchLimited || #matchList < limit) then
      if (index == 1 && index == start && start == ends) then
        -- no empty leading substring included for zero-width match
        -- at the beginning of the input char sequence.
        start, ends = find(str, regex, ends + 1)
        index = 2
        continue
      end
      local match = sub(str, index, start - 1)
      if match ~= "" then
        insert(matchList, match)
      end
      index = ends + 1
     elseif #matchList == limit - 1 then -- last one
      local match = sub(str, index, #str)
      insert(matchList, match)
      index = ends + 1
    end
    start, ends = find(str, regex, ends + 1)
  end
  -- If no match was found, return this
  --[[if (index == 1)
  --  return {}
  end]]

  if (!matchLimited || #matchList < limit)
    local match = sub(str, index, #str)
    if match ~= "" then
      insert(matchList, match)
    end
  end 

  -- Construct result
  local resultSize = #matchList
  if limit == 0 then
    while (resultSize > 0 && matchList[resultSize - 1]=="") do
      resultSize = resultSize - 1
    end
  end
  return table.slice(matchList, 1, resultSize)
end