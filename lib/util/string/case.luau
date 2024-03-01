local function snakeToCamel(input)
  return string.gsub(input, "_(.)", string.upper)
end

local function snakeToPascal(input)
  return string.gsub("_"..input, "_(.)", string.upper):sub(1)
end

local function snakeToKebab(input)
  return string.gsub(input, "(_)", "-")
end

local function snakeToProp(input)
  return string.gsub(input, "(_)", ".")
end

local function propToPath(input)
  return string.gsub(input, "(.)", "/")
end

local function propToSnake(input)
  return string.gsub(input, "(.)", "_")
end

return {
  snakeToCamel = snakeToCamel,
  snakeToPascal = snakeToPascal,
  snakeToKebab = snakeToKebab,
  snakeToProp = snakeToProp,

  propToPath = propToPath,
  propToSnake = propToSnake,
}
