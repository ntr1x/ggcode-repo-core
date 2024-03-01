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

local function snakeToCamelCase(input)
  return string.gsub(input, "_(.)", string.upper)
end

local function snakeToPascalCase(input)
  return string.gsub("_"..input, "_(.)", string.upper):sub(1)
end

local function snakeToKebabCase(input)
  return string.gsub(input, "(_)", "-")
end

local function snakeToPropCase(input)
  return string.gsub(input, "(_)", ".")
end

local function propToPathCase(input)
  return string.gsub(input, "(.)", "/")
end

local function propToSnakeCase(input)
  return string.gsub(input, "(.)", "_")
end

return {
  spread = spread,

  snakeToCamelCase = snakeToCamelCase,
  snakeToPascalCase = snakeToPascalCase,
  snakeToKebabCase = snakeToKebabCase,
  snakeToPropCase = snakeToPropCase,

  propToPathCase = propToPathCase,
  propToSnakeCase = propToSnakeCase,
}
