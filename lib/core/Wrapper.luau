local Wrapper = {
}

function Wrapper:unwrap_array(array: table)
  local result = Meta:array {}
  for _, item in self.array do
    result[#result + 1] = item:unwrap()
  end
  return result
end

return Wrapper