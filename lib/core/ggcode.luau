local generate = function(scroll)
  return function (config)
    local target = {
      target_name = config and config.target or nil,
      target_path = config and config.target_path or nil
    }
    local variables = config and config.variables or {}
    engine:generate(scroll, target, variables)
  end
end

return {
  generate = generate
}
