local _M = {}

string.toNumber = tonumber

_M.NORMAl_NUMBERS = {
  "一", "二", "三", "四", "五",
  "六", "七", "八", "九"
}

_M.NORMAL_UNITS = {
  "", "十", "百", "千", "万",
  "十", "百", "千", "亿",
  "十", "百", "千", "兆",
  "十", "百", "千", "京", -- 大概不会有人数字大到需要用更大的吧（）
}

_M.CAPITAL_NUMBERS = {
  "壹", "贰", "叁", "肆", "伍",
  "陆", "柒", "捌", "玖"
}

_M.CAPITAL_UNITS = {
  "", "拾", "佰", "仟", "万",
  "拾", "佰", "仟", "亿",
  "拾", "佰", "仟", "兆",
  "拾", "佰", "仟", "京",
}

_M.convertWithoutUnits =
function(num, capital, useCircleZero)
  if (type(num) ~= "number" and !tonumber(num)) then
    error(num.." is not a number! ", 2)
  end
    
  local NUMBERS = capital and
    _M.CAPITAL_NUMBERS or _M.NORMAl_NUMBERS
  NUMBERS[0] = useCircleZero and "〇" or "零"
 
  local result = ""
  local str = tostring(num)
  local len = str:len()  
  local hasZero = false

  for i = 1, len do
    local n = str:sub(i, i):toNumber()
    result = result..NUMBERS[n]    
  end
  return result
end

_M.convert = function(num, capital)
  if (type(num) ~= "number" and !tonumber(num)) then
    error(num.." is not a number! ", 2)
  end
  
  local NUMBERS = capital and
    _M.CAPITAL_NUMBERS or _M.NORMAl_NUMBERS
  local UNITS = capital and
    _M.CAPITAL_UNITS or _M.NORMAL_UNITS

  local result = ""
  local str, decimal = tostring(num):match(
     "(%d+)%.?(%d-)$")
  local len = str:len()  
  local hasZero = false

  for i = 1, len do
    local n = str:sub(i, i):toNumber()
    local p = len - i + 1
    if (n > 0 and hasZero == true) then --连续多个零只显示一个
      result = result.."零"
      hasZero = false
    end

    if (p % 4 == 2 and n == 1) then --十位数如果是首位则不显示一十这样的
      if len > p then
        result = result..NUMBERS[n]
      end
      result = result..UNITS[p]
 
     elseif n > 0 then 
      result = result..NUMBERS[n]..UNITS[p]
     
     elseif n == 0 then
      if p % 4 == 1 then --个位是零则补单位
        result = result..UNITS[p]
       else
        hasZero = true
      end
    end
  end

  if str == "0" then
    result = "零"
  end

  if decimal ~= "" then
    result = result.."点"..
      _M.convertWithoutUnits(decimal, capital)
  end

  return result
end

return _M