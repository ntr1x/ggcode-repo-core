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

return {
  spread = spread,
}
