local enums = {}
enums.__index = enums

local enum = function(t)
  local e = setmetatable({}, enums)
  e.table = t
  return e
end

function enums:each(fn)
  for _,v in ipairs(self.table) do
    fn(v)
  end
end

function enums:each_with_index(fn)
  for i,v in ipairs(self.table) do
    fn(i,v)
  end
end

function enums:select(pred)
  local t = {}
  for _,v in ipairs(self.table) do
    if pred(v) then
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

return enum
