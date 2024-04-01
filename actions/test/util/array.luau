local Meta = require('core/Meta')

local array = {
  1,2,3
}

print(json:stringify({
  array = Meta:array { 1, 2, 3 },
  table = Meta:table { one = 1, two = 2, three = 3 },
  empty_table = Meta:table {},
  empty_array = Meta:array {},
  casted_array = Meta:array { one = 1, two = 2, three = 3 }, -- removes map entries
}))
