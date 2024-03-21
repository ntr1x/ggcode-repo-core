local function spread(template)
  return function(table)
    local result = {}
    for key, value in pairs(template) do
        result[key] = value
    end
    for key, value in pairs(table) do
        result[key] = value
    end
    return result
  end
end

local function deep_copy(obj: any, seen: ({ [any]: {} })?)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end

  local s = seen or ({} :: { [any]: {} })
  local res = {}
  s[obj] = res
  for k, v in pairs(obj) do res[deep_copy(k, s)] = deep_copy(v, s) end
  return setmetatable(res, getmetatable(obj))
end

return {
  spread = spread,
  deep_copy = deep_copy,
}
