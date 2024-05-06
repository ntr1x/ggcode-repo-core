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

local function snakeToTitle(input)
  local result = input:gsub("(_)", " "):gsub("%f[%a].", string.upper)
  return result
end

local function propToPath(input)
  return string.gsub(input, "([\.])", "/")
end

local function propToSnake(input)
  return string.gsub(input, "([\.])", "_")
end

local function buildFromSnakeName(name)
  return {
    name = name,
    snake_name = name,
    camel_name = case.snakeToCamel(name),
    pascal_name = case.snakeToPascal(name),
    kebab_name = case.snakeToKebab(name),
    title_name = case.snakeToTitle(name),
  }
end

return {
  snakeToCamel = snakeToCamel,
  snakeToPascal = snakeToPascal,
  snakeToKebab = snakeToKebab,
  snakeToProp = snakeToProp,
  snakeToTitle = snakeToTitle,

  propToPath = propToPath,
  propToSnake = propToSnake,
}
