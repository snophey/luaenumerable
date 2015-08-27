local enums = {}
enums.__index = enums

--- Constructor for the enumerator object.
-- Enumerator objects act as a wrappers for tables.
-- The object contains functions for manupilating table data
-- in a functional matter. For more information and examples
-- see the specific functions.
-- @param t Table or string that is to be iterated over.
-- @return enum object
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

--- Iterate over each element of the enum and perform some actions on them.
-- @param fn Function that is to be executed on each element.
-- Function signature: fn(element, index) -> nil
function enums:each(fn)
  for i,v in ipairs(self.table) do
    fn(v,i)
  end
end

--- Selects elements from a table.
-- select generates a new enum which only contains elements for which
-- pred function returns true.
-- @param pred Predicate function. Decides which elements are selected.
-- Function signature: pred(elem) -> boolean
-- @return New enum object with elements that were selected.
-- @see enums:filter
-- @see enums:reject
function enums:select(pred)
  local t = {}
  for _,v in ipairs(self.table) do
    if pred(v) == true then
      t[#t+1] = v
    end
  end
  return enum(t)
end

--- @see enums:select
enums.filter = enums.select

--- Rejects elements of a table if the predicate returns true.
-- @param pred Predicate function. Decides which elements are dropped.
-- Function signature: pred(elem) -> boolean
-- @return New enum object with elements that were not rejected.
-- @see enums:select
function enums:reject(pred)
  local t = {}
  for _,v in ipairs(self.table) do
    if pred(v) == false then
      t[#t+1] = v
    end
  end
  return enum(t)
end

--- Executes a function on each of the table elements and replaces
-- those elements with whatever the function returns.
-- @param fn Function to be executed on each element.
-- Function signature: fn(element, index) -> [variable]
-- @return New enum object with original elements replaced by fn's return values.
function enums:map(fn)
  local t = {}
  for i,v in ipairs(self.table) do
    t[i] = fn(v)
  end
  return enum(t)
end

--- Reduces table or string to a single value.
-- Applies a function on each value of the table and accumulates
-- the return values of the function in a variable which is then returned.
-- @param fn Function that will be executed on each value.
-- Function signature: fn(
--      prev, -- The value returned by the most recent fn-call.
--      curr, -- value of the current table element
--      index, -- index of curr
-- )
-- @param init Initial value of the accumulator. 0 if no value given.
-- @return Single value that was built by calling fn on each element.
-- @see enums:fold
-- @see enums:inject
function enums:reduce(fn, init)
  local acc = init or 0
  for i,v in ipairs(self.table) do
    acc = fn(acc,v,i)
  end
  return acc
end

--- @see enums:reduce
enums.fold = enums.reduce
--- @see enums:reduce
enums.inject = enums.reduce

--- Checks if a function returns true for all elements.
-- @param fn Callback function that takes a value (and an index)
-- and returns a boolean value.
-- @return `true` if fn returned `true` for all array elements. Otherwise false.
function enums:all(fn)
  for i,v in ipairs(self.table) do
    if fn(v,i) == false then
      return false
    end
  end
  return true
end

--- Checks if a function returns true for at least one element.
-- @param fn Callback function that takes a value (and an index)
-- and returns a boolean value.
-- @return `true` if fn returned `true` at least once. Otherwise false.
function enums:any(fn)
  for i,v in ipairs(self.table) do
    if fn(v,i) == true then
      return true
    end
  end
  return false
end

--- Counts elements for which fn returns `true`.
-- @param fn Callback function that takes a value (and an index)
-- and returns a boolean value.
-- @return Number of elements for which fn returned `true`
function enums:count(fn)
  local c = 0
  for i,v in ipairs(self.table) do
    if fn(v,i) == true then
      c = c+1
    end
  end
  return c
end

return enum
