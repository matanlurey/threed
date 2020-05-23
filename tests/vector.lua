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
  local v = vector.zero(3)
  test.equal(#v, 3)
  test.equal(v[1], 0)
  test.equal(v[2], 0)
  test.equal(v[3], 0)
end

test.negate = function()
  test.equivalent(vector.negate({0, 0, 0}), {0, 0, 0})
  test.equivalent(vector.negate({1, 3, 5}), {-1, -3, -5})
  test.equivalent(vector.negate({-1, -3, -5}), {1, 3, 5})
end

test.scale = function()
  test.equivalent(vector.scale({1, 2, 4}, 2), {2, 4, 8})
  test.equivalent(vector.scale({2, 4, 6}, -2), {1, 2, 3})
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

test.normalize = function()
  test.equivalent(vector.normalize({8, -3, 1/2}), {0.935, -0.350, 0.058})
end

test.distance = function()
  test.equal(vector.distance({5, 6, 2}, {-7, 11,-13}), math.sqrt(394))
  test.equal(vector.distance({7, 4, 3}, {17, 6, 2}), math.sqrt(105))
end

test.dot = function()
  test.equal(vector.dot({3, -2, 7}, {0, 4, -1}), -15)
end

test.facing = function()
  local p = {-3, 4}
  local v = {5, -2}

  test.equal(
    vector.facing(p, v, {0, 0}),
    23
  )

  test.equal(
    vector.facing(p, v, {1, 6}),
    16
  )

  test.equal(
    vector.facing(p, v, {-6, 0}),
    -7
  )

  test.equal(
    vector.facing(p, v, {-4, 7}),
    -11
  )
end

test.facing_angle = function()
  local p = {-3, 4}
  local v = {5, -2}

  test.equal(
    vector.facing_angle(p, v, {0, 0}),
    23 / (math.sqrt(29) * math.sqrt(25)) -- 0.854
  )

  test.equal(
    vector.facing_angle(p, v, {1, 6}),
    16 / (math.sqrt(29) * math.sqrt(20)) -- 0.664
  )
end

test.cross = function()
  test.equivalent(
    vector.cross(
      {1, 3, 4},
      {2, -5, 8}
    ),
    {44, 0, -11}
  )
end
