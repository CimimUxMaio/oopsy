---@class Base
---@field className string
local Base = {}
Base.className = "Base"
Base.initialize = function(...) end

---@generic T : Base
---@return T
function Base:getClass()
  local meta = getmetatable(self)
  return meta and meta.__index
end

---@generic T : Base
---@param parent T
---@return T
local function extends(name, parent)
  local cls = setmetatable({}, { __index = parent })
  cls.className = name
  return cls
end

---@param name string
---@return Base
local function class(name)
  return extends(name, Base)
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
  local c = self:getClass()

  if c == nil then
    return false
  end

  if c == cls then
    return true
  end

  return c:instanceOf(cls)
end

return { class = class, extends = extends }
