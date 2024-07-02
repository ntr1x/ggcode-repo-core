local ARRAY = require('core/util/array')

local URI = {
  schema = nil,
  username = nil,
  password = nil,
  hostname = nil,
  port = nil,
  path = nil,
  query = nil,
  fragment = nil,
}

function URI:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function URI:parse(st: string)
  local schema = nil
  local without_schema = nil
  local authority = nil
  local without_authority = nil
  local userinfo = nil
  local username = nil
  local password = nil
  local host = nil
  local hostname = nil
  local port = nil
  local path = nil
  local without_path = nil
  local query = nil
  local without_query = nil
  local fragment = nil

  if st:sub(1,2) == '//' then
    without_schema = ':' .. st
  else
    schema, without_schema = st:match("([^:]*)(.*)")
  end
  if without_schema and #without_schema then
    if without_schema:sub(1, 3) == '://' then
      authority, without_authority = without_schema:match("://([^/]*)(.*)")
      if authority and #authority then
        if authority:find('@') then
          userinfo, host = authority:match("([^@]*)@(.*)")
        else
          host = authority
        end
        if userinfo and #userinfo then
          if userinfo:find(':') then
            username, password = userinfo:match("([^:]*):(.*)")
          else
            username = userinfo
          end
        end
        if host and #host then
          if host:find(':') then
            hostname, port = host:match("([^:]*):(.*)")
          else
            hostname = host
          end
        end
      end
      if without_authority and #without_authority then
        path, without_path = without_authority:match("([^?]*)(.*)")
      end
      if without_path and #without_path then
        query, without_query = without_path:match("?([^#]*)(.*)")
      end
      if without_query and #without_query then
        fragment = without_query:sub(1):match("#(.*)")
      end
    elseif without_schema:sub(1,1) == ':' then
      path = st:match(":(.*)")
    end
  end

  return URI:new({
    schema = schema,
    username = username,
    password = password,
    hostname = hostname,
    port = port,
    path = path,
    query = query,
    fragment = fragment,
  })
end

function URI:parse_nested(schema: string, st: string)
  if st:find(schema .. ':') == 1 then
    return URI:parse(st:sub(#schema + 2))
  end
  error(`Invalid prefix: '{schema}'`)
end

function URI:parse_jdbc(st: string)
  return URI:parse_nested('jdbc', st)
end

function URI:userinfo()
  if self.username ~= nil and self.password ~= nil then
    return self.username .. ':' .. self.password
  elseif self.username ~= nil then
    return self.username
  end
  return nil
end

function URI:host()
  if self.hostname ~= nil and self.port ~= nil then
    return self.hostname .. ':' .. self.port
  elseif self.hostname ~= nil then
    return self.hostname
  end
  return nil
end

function URI:authority()
  local host = self:host()
  local userinfo = self:userinfo()
  if host ~= nil and userinfo ~= nil then
    return userinfo .. '@' .. host
  elseif host ~= nil then
    return host
  end
  return nil
end

function URI:query_params()
  local result = {}
  if self.query ~= nil then
    for item in self.query:gmatch("([^&]+)") do
      if item:find('=') then
        local name, value = item:match("([^=]*)=(.*)")
        result[name] = value
      else
        result[item] = true
      end
    end
  end
  return result
end

function URI:format()
  local st = ''
  if self.schema ~= nil then
    st ..= self.schema .. ':'
  end
  local authority = self:authority()
  if authority ~= nil then
    st ..= '//' .. authority
  end
  if self.path ~= nil then
    st ..= self.path
  end
  if self.query ~= nil then
    st ..= ('?' .. self.query)
  end
  if self.fragment ~= nil then
    st ..= ('#' .. self.fragment)
  end
  return st
end

function URI:format_nested(schema: string)
  return schema .. ':' .. self:format()
end

function URI:format_jdbc()
  return self:format_nested('jdbc')
end

function URI:with_schema(schema: string)
  self.schema = schema
  return self
end

function URI:override_schema(overrides: table)
  self.schema = overrides[self.schema] or self.schema
  return self
end

function URI:with_port(port: string)
  self.port = port
  return self
end

function URI:with_hostname(hostname: string)
  self.hostname = hostname
  return self
end

function URI:with_path(path: string)
  self.path = path
  return self
end

function URI:with_query(query: string)
  self.query = query
  return self
end

function URI:with_fragment(fragment: string)
  self.fragment = fragment
  return self
end

function URI:with_username(username: string)
  self.username = username
  return self
end

function URI:with_password(password: string)
  self.password = password
  return self
end

function URI:resolve(subpath: string)
  if subpath == nil then
    return self:with_path(nil)
  end
  if subpath:find('^/') then
    return self:with_path(subpath)
  end
  if self.path == '' or self.path == nil then
    return self:with_path(subpath)
  end
  if self.path:find('/$') then
    return self:with_path(self.path .. subpath)
  end
  return self:with_path(self.path .. '/' .. subpath)
end

return URI
