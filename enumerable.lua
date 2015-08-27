local enums = {}
enums.__index = enums

local enum = function(t)
  local ty = type(t)

  if ty ~= "string" and ty ~= "table" then
    error("Wrong argument. Expected table or string. Got " .. ty .. '.')
  end

  if ty == "string" then
    local temp = {}
    for i=1,#t do
      temp[#temp+1] = string.sub(t,i,i)
    end
    t = temp
  end

  local e = setmetatable({}, enums)
  e.table = t
  return e
end

function enums:each(fn)
  for i,v in ipairs(self.table) do
    fn(v,i)
  end
end

function enums:select(pred)
  local t = {}
  for _,v in ipairs(self.table) do
    if pred(v) == true then
      t[#t+1] = v
    end
  end
  return enum(t)
end
enums.filter = enums.select

function enums:reject(pred)
  local t = {}
  for _,v in ipairs(self.table) do
    if pred(v) == false then
      t[#t+1] = v
    end
  end
  return enum(t)
end

function enums:map(fn)
  local t = {}
  for i,v in ipairs(self.table) do
    t[i] = fn(v)
  end
  return enum(t)
end

function enums:reduce(fn, init)
  local acc = init or 0
  for i,v in ipairs(self.table) do
    acc = fn(acc,v,i)
  end
  return acc
end
enums.fold = enums.reduce
enums.inject = enums.reduce

return enum
