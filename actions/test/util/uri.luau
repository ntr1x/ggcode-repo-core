local URI = require('core/URI')

print(`Test URI:parse`)

local examples = {
  'http://localhost',
  'http://localhost:8080',
  'http://localhost:8080/path/to/route',
  'http://localhost/path/to/route',
  'http://localhost/path/to/route?foo=1&bar=2',
  'http://localhost/path/to/route?foo=1&bar=2#some',
  'http://localhost/',
  'http://username@localhost:8080/path/to/route',
  'http://username@localhost/path/to/route',
  'http://username:password@localhost:8080/path/to/route',
  'http://username:password@localhost/path/to/route',
  '//localhost/path/to/route',
  '//username:password@localhost/path/to/route',

  'https://john.doe@www.example.com:123/forum/questions/?tag=networking&order=newest#top',
  'ldap://[2001:db8::7]/c=GB?objectClass?one',
  'mailto:John.Doe@example.com',
  'news:comp.infosystems.www.servers.unix',
  'tel:+1-816-555-1212',
  'telnet://192.0.2.16:80/',
  'urn:oasis:names:specification:docbook:dtd:xml:4.1.2',
}

for i, example in examples do
  print(`  Test {i}`)
  print('    Source:', example)
  local uri = URI:parse(example)
  local result = uri:format()
  print('    Result:', result)
  print('    Details:')
  for n, v in uri do
    print(`      {n} = {v}`)
  end
  local params = uri:query_params()
  if #params then
    print('      params:')
    for pn, pv in params do
      print(`        {pn} = {pv}`)
    end
  end
  assert(example == result)
end

print(`Test URI:parse_jdbc`)

local examples_jdbc = {
  'jdbc:postgresql://localhost:5432/app',
  'jdbc:mysql://localhost:3306/youdatabase?useSSL=false&serverTimezone=UTC',
}

for i, example in examples_jdbc do
  print(`  Test {i}`)
  print('    Source:', example)
  local uri = URI:parse_jdbc(example)
  local result = uri:format_jdbc()
  print('    Result:', result)
  print('    Details:')
  for n, v in uri do
    print(`      {n} = {v}`)
  end
  local params = uri:query_params()
  if #params then
    print('      params:')
    for pn, pv in params do
      print(`        {pn} = {pv}`)
    end
  end
  assert(example == result)
end
