local Meta = {
}

function Meta:array(array)
  setmetatable(array, array_mt)
  return array
end

function Meta:table(array)
  setmetatable(array, {})
  return array
end

return Meta