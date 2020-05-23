--- API for manipulating and working with vectors.
--
-- It is assumed that all tables passed to these functions are numerically
-- indexed and have a length of at least one, referring to `{x}`, otherwise the
-- behavior of the functions is considered undefined.
local vector = {
  --- Asserts that the provided value is a valid vector table.
  --
  -- @param v
  assert = function(v)
    assert(vector.is(v))
  end,

  --- Returns whether the provided value is a valid vector table.
  --
  -- @param v
  is = function(v)
    if not (type(v) == 'table') then
      return false
    end
    if #v == 0 then
      return false
    end
    for _, n in ipairs(v) do
      if not (type(n) == 'number') then
        return false
      end
    end
    return true
  end,

  --- Returns the zero vector, or {0, ... n}
  zero = function(n)
    if n == 1 then
      return {0}
    end
    if n == 2 then
      return {0, 0}
    end
    if n == 3 then
      return {0, 0, 0}
    end
    assert(n > 0)
    local result = {}
    for _ = n, 1, -1 do
      table.insert(result, 0)
    end
    return result
  end,

  --- Returns the negation of the provided vector.
  --
  -- @param v
  negate = function(v)
    local copy = {table.unpack(v)}
    for i, n in ipairs(copy) do
      copy[i] = -n
    end
    return copy
  end,

  --- Returns the result of the provided vector scaled multiplied by a value s
  --
  -- @param v Vector
  -- @param s Another vector a scalar (number)
  scale = function(v, s)
    local copy = {table.unpack(v)}
    for i, n in ipairs(copy) do
      copy[i] = n * s
    end
    return copy
  end,

  --- Returns the result of adding vectors a and b
  --
  -- @param a Vector
  -- @param b Vector
  add = function(a, b)
    assert(#a == #b)
    local copy = {table.unpack(a)}
    for i, n in ipairs(copy) do
      copy[i] = n + b[i]
    end
    return copy
  end,

  --- Returns the result of subtracting vectors a by b
  --
  -- @param a Vector
  -- @param b Vector
  subtract = function(a, b)
    assert(#a == #b)
    local copy = {table.unpack(a)}
    for i, n in ipairs(copy) do
      copy[i] = n - b[i]
    end
    return copy
  end,

  --- Returns the length or mangitude of a vector v.
  --
  -- @param v Vector
  length = function(v)
    local result = 0
    for _, n in ipairs(v) do
      result = result + n * n
    end
    return math.sqrt(result)
  end,

  --- Returns a vector v normalized, or a vector that points in the same direction.
  --
  -- This ends up returning just the *direction* of the vector.
  --
  -- @param v Vector
  normalize = function(v)
    local length = vector.length(v)
    return vector.scale(v, 1 / length);
  end,

  --- Returns the distance between two vectors.
  --
  -- @param a Vector
  -- @param b Vector
  distance = function(a, b)
    local result = 0
    assert(#a == #b)
    for i, _ in ipairs(a) do
      local d = a[i] - b[i]
      result = result + d * d
    end
    return math.sqrt(result)
  end,

  --- Returns the dot (inner, cummulative) product of vectors a and b.
  --
  -- The result is the projection as a one-dimensional vector (scalar). The sign
  -- of the dot product can also give a rough classification of the relative
  -- directions of the two vectors, where `a^` * `b` tells us which half-space
  -- `b` lies in.
  --
  -- @param a Vector
  -- @param b Vector
  dot = function(a, b)
    local result = 0
    assert(#a == #b)
    for i, _ in ipairs(a) do
      local d = a[i] * b[i]
      result = result + d
    end
    return result
  end,

  --- Returns how `x` is considered "facing" of `p`, direction `v`.
  --
  -- If the resulting value is < 0, it is considered "behind", > 0 it is
  -- considered "in front", and = 0 it is considered parallel (neither).
  --
  -- @param p Point
  -- @param v Vector (Direction)
  -- @param x Point
  facing = function(p, v, x)
    return vector.dot(v, vector.subtract(x, p))
  end,

  --- Returns the angle (in radians) that `x` is considered for `p`, `v`.
  --
  -- Also known as `cos Θ`.
  --
  -- @param p Point
  -- @param v Vector (Direction)
  -- @param x Point
  --
  -- @see angle.field_of_view
  -- @usage
  -- local a = angle.field_of_view(90)
  -- local p = {-3, 4}
  -- local v = {5, -2}
  -- print(vector.facing_angle(p, v, {0, 0}) >= a)
  facing_angle = function(p, v, x)
    --          v ∙ (x - p)
    -- cos Θ =  -----------
    --          ║v║ ║x - p║
    local facing = vector.facing(p, v, x)
    local magnitude_of_v = vector.length(v)
    local difference_of_x_and_p = vector.subtract(x, p)
    local mangitude_of_difference = vector.length(difference_of_x_and_p)
    local r = magnitude_of_v * mangitude_of_difference
    return facing / r
  end,

  --- Returns the cross (outer, yields a vector) products of 3D vectors a and b.
  --
  -- The result is a vector that is perpindicular to the original two vectors.
  --
  -- @param a Vector (3D)
  -- @param b Vector (3D)
  cross = function(a, b)
    assert(#a == 3)
    assert(#b == 3)
    local x = a[2] * b[3] - a[3] * b[2]
    local y = a[3] * b[1] - a[1] * b[3]
    local z = a[1] * b[2] - a[2] * b[1]
    return {x, y, z}
  end
}

local angle = {
  --- Returns the field of view projection of angle `a` (in degrees).
  --
  -- @param a Angle (Degrees)
  field_of_view = function(a)
    local radians = a / 2 * math.pi / 180
    return math.cos(radians)
  end,
}

return {
  vector = vector,
  angle = angle,
}
