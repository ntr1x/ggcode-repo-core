local function split(str, expr)
  local fields = {}
  for field in str:gmatch(expr) do
    fields[#fields+1] = field
  end
  return fields
end

return {
  split = split,
  EXPR_DOT = '([^\.]+)',
  EXPR_COMMA = '([^,]+)',
  EXPR_COLON = '([^:]+)',
  EXPR_SLASH = '([^/]+)',
}
