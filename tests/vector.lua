package.path = package.path .. ';./tests/u-test/?.lua;./?.lua;'

local test = require('u-test')
local threed = require '../threed'
local vector = threed.vector

test.register_assert('equivalent', function(a, b)
  if a == b then
    return true
  end
  if not type(a) == type(b) then
    return false, 'Types ' .. type(a) .. ' and ' .. type(b) .. ' are not equal'
  end
  if type(a) == 'table' then
    if not #a == #b then
      return false, 'Expected length of ' .. #a .. ' got ' .. #b
    end
    for i, _ in pairs(a) do
      if not a[i] == b[i] then
        return false, 'Index #' .. i .. ' expected ' .. a[i] .. ' got ' .. b[i]
      end
    end
    return true
  end
  return false, 'Unsupported comparison types of ' .. a .. ' and ' .. b
end)

test.is = function()
  test.is_true(vector.is({0, 0,0 }))
  test.is_true(vector.is({-5, -10, 15}))
  test.is_false(vector.is({}))
  test.is_false(vector.is({'a', 'b', 'c'}))
  test.is_false(vector.is(0))
end

test.zero = function()
  local vector = vector.zero()
  test.equal(#vector, 3)
  test.equal(vector[1], 0)
  test.equal(vector[2], 0)
  test.equal(vector[3], 0)
end

test.negate = function()
  test.equivalent(vector.negate({0, 0, 0}), {0, 0, 0})
  test.equivalent(vector.negate({1, 3, 5}), {-1, -3, -5})
  test.equivalent(vector.negate({-1, -3, -5}), {1, 3, 5})
end

test.multiply = function()
  test.equivalent(vector.multiply({1, 2, 4}, 2), {2, 4, 8})
end

test.divide = function()
  test.equivalent(vector.divide({2, 4, 6}, 2), {1, 2, 3})
end

test.add = function()
  test.equivalent(vector.add({1, 2, 3}, {2, 3, 4}), {3, 5, 7})
end

test.subtract = function()
  test.equivalent(vector.subtract({1, 2, 3}, {2, 3, 4}), {-1, -1, -1})
end

test.length = function()
  test.equal(vector.length({5, -4, 7}), math.sqrt(90))
end
