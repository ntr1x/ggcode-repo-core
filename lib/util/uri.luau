local function parse(st: string)
    local schema, host, path, queryString, hashString = st:match("([^:]+)://([^/]*)([^?]*)([^#]*)(.*)")
    local domain, portString = host:match("([^:]+)(.*)")
    local port = if portString ~= "" then portString:match(":(.*)") else nil
    local query = if queryString ~= "" then queryString:match("?(.*)") else nil
    local hash = if hashString ~= "" then hashString:match("#(.*)") else nil

    return {
        schema = schema,
        host = host,
        domain = domain,
        port = port,
        path = path,
        query = query,
        hash = hash,
    }
end

return {
  parse = parse,
}
