local split = require('core/util/string/split')

local array = split.split('one.two.three', split.EXPR_DOT)
assert('one, two, three' == table.concat(array, ', '))
