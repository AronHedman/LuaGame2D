
Item = {}
Item.__index = Item

items = {}

function Item:new(prototype)
  local obj = {
    id = prototype.id,
    name = prototype.name or "Unnamed",
    type = prototype.type or "Undefined",
    data = prototype.data or {},
    sprite = prototype.sprite or nil,
    components = prototype.components or {},
  }

  for _, component in ipairs(obj.components) do
    if component.init then
      component.init(obj)
    end
  end

  setmetatable(obj, Item)
  return obj
end

function Item:call(event, ...)
  for _,component in ipairs(self.components) do
    if component[event] then
      component[event](self, ...)
    end
  end
end

function Item.iid() --Generates a unique instance ID in hexadecimal (Source: Lua - Lume Library, slightly modified with a randomseed)
  local fn = function(x)
    math.randomseed(love.timer.getTime())
    local r = math.random(16) - 1
    r = (x == "x") and (r + 1) or (r % 4) + 9
    return ("0123456789abcdef"):sub(r, r)
  end
  return (("xxxxxx"):gsub("[xy]", fn))
end