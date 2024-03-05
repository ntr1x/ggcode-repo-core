local function concat(a, b)
  local result = {table.unpack(a)}
  table.move(b, 1, #b, #result + 1, result)
  return result
end

return {
  concat = concat
}
