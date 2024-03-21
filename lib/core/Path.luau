local ARRAY = require('core/util/array')

local Path = {
  entries = {}
}

local TYPE_SEPARATOR = 0;
local TYPE_SEGMENT = 1;
local TYPE_CURRENT = 2;
local TYPE_PARENT = 3;

function Path:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Path:to_string()
  local st = ''
  for _, entry in self.entries do
    st ..= entry.value
  end
  return st
end

function Path:normalize()
  local entries = {}
  local is_absolute = if #self.entries > 0 and self.entries[1].type == TYPE_SEPARATOR then true else false
  for i, entry in self.entries do
    if entry.type == TYPE_CURRENT then
      -- do nothing
    elseif entry.type == TYPE_PARENT then
      if #entries > 1 and entries[#entries].type == TYPE_SEPARATOR and entries[#entries - 1].type == TYPE_SEGMENT then
        table.remove(entries, #entries) -- remove separator
        table.remove(entries, #entries) -- remove segment
      elseif #entries == 1 and entries[#entries].type == TYPE_SEPARATOR then
        table.remove(entries, #entries) -- remove separator
        entries[#entries + 1] = entry
      else
        entries[#entries + 1] = entry
      end
    elseif entry.type == TYPE_SEGMENT then
      entries[#entries + 1] = entry
    elseif entry.type == TYPE_SEPARATOR then
      if #entries > 0 and entries[#entries].type ~= TYPE_SEPARATOR then
        entries[#entries + 1] = entry
      elseif #entries == 0 and is_absolute then
        entries[#entries + 1] = entry
      else
        -- do nothing
      end
    end
  end
  if #entries > 1 and entries[#entries].type == TYPE_SEPARATOR then
    table.remove(entries, #entries) -- remove trailing separator
  end
  return Path:new({ entries = entries })
end

function Path:from_segments(segments: table)
  local entries = {}
  for i, segment in segments do
    if i > 1 then
      entries[#entries + 1] = { type = TYPE_SEPARATOR, value = '/' }
    end
    entries[#entries + 1] = { type = TYPE_SEGMENT, value = segment }
  end
  return Path:new({ entries = entries })
end

function Path:from_string(st: string)
  local entries = {}
  for separator, segment in st:gmatch("([/]*)([^/]*)") do
    if separator ~= '' then
      entries[#entries + 1] = { type = TYPE_SEPARATOR, value = '/' }
    end
    if segment ~= '' then
      if segment == '.' then
        entries[#entries + 1] = { type = TYPE_CURRENT, value = segment }
      elseif segment == '..' then
        entries[#entries + 1] = { type = TYPE_PARENT, value = segment }
      else
        entries[#entries + 1] = { type = TYPE_SEGMENT, value = segment }
      end
    end
  end
  return Path:new({ entries = entries })
end

function Path:parse(st: string)
  return Path:from_string(st)
end

function Path:join_path(other: Path)
  local entries = nil
  if #self.entries > 0 and #other.entries > 0 and self.entries[#self.entries].type ~= TYPE_SEPARATOR and other.entries[1].type ~= TYPE_SEPARATOR then
    entries = ARRAY.concat(ARRAY.concat(self.entries, {{ type = TYPE_SEPARATOR, value = '/' }}), other.entries)
  else
    entries = ARRAY.concat(self.entries, other.entries)
  end
  return Path:new({ entries = entries })
end

function Path:join_string(st: string)
  local other = Path:from_string(st)
  return self:join_path(other)
end

function Path:path_array()
  local array = {}
  for item in self:to_string():gmatch("([^/]+)") do
    array[#array + 1] = item
  end
  return array
end

function Path:path()
  return table.unpack(self:path_array())
end

return Path
