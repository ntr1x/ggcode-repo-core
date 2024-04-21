local Meta = require('core/Meta')

local function concat(a, b)
  local result = {table.unpack(a)}
  table.move(b, 1, #b, #result + 1, result)
  return result
end

local function copy(array)
  local result = {}
  for i, item in array do
    result[i] = item
  end
  return result
end

return {
  concat = concat,
  copy = copy,
}
