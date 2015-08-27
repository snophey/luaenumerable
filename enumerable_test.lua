enum = require "enumerable"

describe("enumerable test", function()
  it("should not do anything if table is empty", function()
    local fn = function(e) print "If you see this something is wrong." end
    local module = {fn=fn}
    local sp = spy.on(module, "fn")
    enum({}):each(module.fn)
    assert.spy(sp).was_not_called()
  end)

  it("shoult iterate over tables", function()
    local arr = {1,2,3,4,5}
    enum(arr):each(function(v,i)
      assert.are.equal(v,i)
    end)
  end)

  it("should iterate over strings", function()
    local ref = {'a','b','c','d'}
    enum("abcd"):each(function(v, i)
      assert.are.equal(ref[i], v)
    end)
  end)

  it("should only accept strings and tables", function()
    local num = function() enum(1) end
    local nil_ = function() enum(nil) end
    local bool = function() enum(true) end
    local user = function()
      local f = io.open("enumerable_test.lua", "r")
      f:close()
      enum(f)
    end
    assert.has_error(num, "Wrong argument. Expected table or string. Got number.")
    assert.has_error(nil_, "Wrong argument. Expected table or string. Got nil.")
    assert.has_error(bool, "Wrong argument. Expected table or string. Got boolean.")
    assert.has_error(user, "Wrong argument. Expected table or string. Got userdata.")
  end)

  it("should select all even numbers", function()
    local arr = {1,2,3,4,5,6,7,8,9,10}
    local res = enum(arr):select(function(e) return (e % 2 == 0) end).table
    assert.are.same({2,4,6,8,10}, res)
  end)

  it("should work with aliases", function()
    local arr = {1,2,3,4,5,6,7,8,9,10}
    local res = enum(arr):filter(function(e) return (e % 2 == 0) end).table
    assert.are.same({2,4,6,8,10}, res)
  end)

  it("should reject all even numbers", function()
    local arr = {1,2,3,4,5,6,7,8,9,10}
    local res = enum(arr):reject(function(e) return (e % 2 == 0) end).table
    assert.are.same({1,3,5,7,9}, res)
  end)

  it("should double all numbers", function()
    local arr = {1,2,3,4,5,6,7,8,9,10}
    local res = enum(arr):map(function(e) return e*2 end).table
    assert.are.same({2,4,6,8,10,12,14,16,18,20}, res)
  end)

  it("should add all numbers in table", function()
    local arr = {1,2,3,4,5}
    local res = enum(arr):reduce(function(acc, elem) return acc+elem end)
    assert.are.equal(1+2+3+4+5, res)
  end)

  it("should concatenate all strings in table", function()
    local strs = {"Hello", " ", "World", "!"}
    local res = enum(strs):reduce(function(acc, e) return (acc .. e) end, "")
    assert.are.equal("Hello World!", res)
  end)

  it("should check if condition is true for all elements", function()
    local arr = {10, 20, 30, 55, 13, 23.09}
    local res = enum(arr):all(function(e) return e >= 10 end)
    assert.is_true(res)
    
    arr = {1,2,3,4,5,6,7,8,9,0}
    res = enum(arr):all(function(e) return e >= 10 end)
    assert.is_false(res)
  end)

  it("should check if condition is true for at least one element", function()
    local arr = {10, 20, 30, 55, 13, 23.09, 8}
    local res = enum(arr):any(function(e) return e < 10 end)
    assert.is_true(res)

    arr = {10, 20, 30, 55, 13, 23.09}
    res = enum(arr):any(function(e) return e < 10 end)
    assert.is_false(res)
  end)

  it("should count elements that meet the requirements", function()
    local arr = {10, 20, 30, 55, 13, 23.09, 8}
    local res = enum(arr):count(function(e) return e > 20 end)
    assert.are.equal(3, res)

    arr = {"cat", "dog", "pig"}
    res = enum(arr):count(function(e) return #e >= 4 end)
    assert.are.equal(0, res)

    str = "abcdefg"
    res = enum(str):count(function(e) return e > "f" end)
    assert.are.equal(1, res)
  end)
end)
