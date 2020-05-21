--- API for manipulating and working with 3D vectors.
--
-- It is assumed that all tables passed to these functions are numerically
-- indexed and have a length of exactly three, referring to `{x, y, z}`,
-- otherwise the behavior of the functions is considered undefined.
vector = {
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
    return type(v) == 'table' and
           #v == 3 and
           type(v[1]) == 'number' and
           type(v[2]) == 'number' and
           type(v[3]) == 'number'
  end,

  --- Returns the zero vector, or {0, 0, 0}.
  zero = function()
    return {0, 0, 0}
  end,

  --- Returns the negation of the provided vector.
  --
  -- @param v
  negate = function(v)
    return {-v[1], -v[2], -v[3]}
  end,

  --- Returns the result of the provided vector v multipled by a value s
  --
  -- @param v Vector
  -- @param s Another vector or a scalar (number)
  multiply = function(v, s)
    if type(s) == 'number' then
      return {v[1] * s, v[2] * s, v[3] * s}
    end
    error('Unsupported input for "s": ' .. s)
  end,

  --- Returns the result of the provided vector v divided by a value s
  --
  -- @param v Vector
  -- @param s Another vector a scalar (number)
  divide = function(v, s)
    if type(s) == 'number' then
      return {v[1] / s, v[2] / s, v[3] / s}
    end
    error('Unsupported input for "s": ' .. s)
  end,

  --- Returns the result of adding vectors a and b
  --
  -- @param a Vector
  -- @param b Vector
  add = function(a, b)
    return {a[1] + b[1], a[2] + b[2], a[3] + b[3]}
  end,

  --- Returns the result of subtracting vectors a by b
  --
  -- @param a Vector
  -- @param b Vector
  subtract = function(a, b)
    return {a[1] - b[1], a[2] - b[2], a[3] - b[3]}
  end,

  --- Returns the length or mangitude of a vector v.
  --
  -- @param v Vector
  length = function(v)
    return math.sqrt(v[1] * v[1] + v[2] * v[2] + v[3] * v[3])
  end,
}

return {
  vector = vector
}
