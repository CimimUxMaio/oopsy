---@class Base
---@field className string
local Base = { className = "Class", initialize = function() end }

---@param name string
---@return Base
local function class(name)
  local cls = setmetatable({}, { __index = Base })
  cls.className = name
  return cls
end

---@generic T : Base
---@param parent T
---@return T
local function extends(name, parent)
  return setmetatable(class(name), { __index = parent })
end

---@generic T : Base
---@param cls T
---@param ... any
---@return T
function Base.new(cls, ...)
  local instance = setmetatable({}, { __index = cls })
  instance:initialize(...)
  return instance
end

---@generic T : Base
---@param cls T
---@return boolean
function Base:instanceOf(cls)
  local meta = getmetatable(self)

  local parent = nil
  if meta ~= nil then
    parent = meta.__index
  end

  if parent == nil then
    return false
  end

  if parent == cls then
    return true
  end

  return parent:instanceOf(cls)
end

return class, extends
