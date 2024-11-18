local oopsie = require("oopsie")
local class, extends = oopsie.class, oopsie.extends

describe("Class creation", function()
  it("#class does not fail", function()
    assert.has_no.errors(function()
      class("ClassA")
    end)
  end)

  it("#extends does not fail", function()
    local ClassA = class("ClassA")
    assert.has_no.errors(function()
      extends("ClassB", ClassA)
    end)
  end)
end)

describe("Instance creation", function()
  it("#new does not fail when instancing a simple class", function()
    local ClassA = class("ClassA")
    assert.has_no.errors(function()
      ClassA:new()
    end)
  end)

  it("#new does not fail when instancing a class that extends from another", function()
    local ClassA = class("ClassA")
    local ClassB = extends("ClassB", ClassA)
    assert.has_no.errors(function()
      ClassB:new()
    end)
  end)

  it("#new calls the #initialize method of the class", function()
    local ClassA = class("ClassA")
    spy.on(ClassA, "initialize")
    ClassA:new()
    assert.spy(ClassA.initialize).was_called()
  end)

  it("#initialize method can be overriten by the parent class", function()
    ---@class ClassA : Base
    local ClassA = class("ClassA")

    function ClassA:initialize()
      self.value = 42
    end

    local instance = ClassA:new()
    assert.is.equal(42, instance.value)
  end)

  it("#initialize method can be overriten by a grandparent class", function()
    ---@class ClassA : Base
    local ClassA = class("ClassA")

    function ClassA:initialize()
      self.value = 2
    end

    ---@class ClassB : ClassA
    local ClassB = extends("ClassB", ClassA)

    local instance = ClassB:new()
    assert.is.equal(2, instance.value)
  end)

  it("#initialize method is called with the same arguments as #new", function()
    local ClassA = class("ClassA")
    spy.on(ClassA, "initialize")
    ClassA:new(42, "hello world", true)
    assert.spy(ClassA.initialize).was.called_with(ClassA, 42, "hello world", true)
  end)
end)

describe("#inheritance", function()
  it("Instances inherit methods defined in the parent class", function()
    ---@class ClassA : Base
    local ClassA = class("ClassA")

    function ClassA:magicNumber()
      return 42
    end

    local instance = ClassA:new()
    assert.is.equal(42, instance:magicNumber())
  end)

  it("Instances inherit methods defined in a grandparent class", function()
    ---@class ClassA : Base
    local ClassA = class("ClassA")

    function ClassA:magicNumber()
      return 2
    end

    ---@class ClassB : ClassA
    local ClassB = extends("ClassB", ClassA)

    local instance = ClassB:new()
    assert.is.equal(2, instance:magicNumber())
  end)

  it("Subclasses can override parent methods", function()
    ---@class ClassA : Base
    local ClassA = class("ClassA")

    function ClassA:magicNumber()
      return 7
    end

    ---@class ClassB : ClassA
    local ClassB = extends("ClassB", ClassA)

    function ClassB:magicNumber() -- Override
      return 2
    end

    local instance = ClassB:new()
    assert.is.equal(2, instance:magicNumber())
  end)
end)

describe("#instanceOf", function()
  it("Returns true for the instance's parent class", function()
    local ClassA = class("ClassA")
    local instance = ClassA:new()
    assert.is_true(instance:instanceOf(ClassA))
  end)

  it("Returns true for any ancestor of the instance's parent class", function()
    local ClassA = class("ClassA")
    local ClassB = extends("ClassB", ClassA)
    local instance = ClassB:new()
    assert.is_true(instance:instanceOf(ClassA))
  end)

  it("Returns false for any unrelated class", function()
    local ClassA = class("ClassA")
    local ClassB = class("ClassB")
    local instance = ClassA:new()
    assert.is_false(instance:instanceOf(ClassB))
  end)

  it("Always returns true for the Base class", function()
    local ClassA = class("ClassA")
    local instance = ClassA:new()
    assert.is_true(instance:instanceOf(ClassA))
  end)
end)

describe("#className", function()
  it("Returns the correct class name", function()
    local ClassA = class("ClassA")
    assert.is.equal("ClassA", ClassA.className)
  end)

  it("Returns the correct class name for subclasses", function()
    local ClassA = class("ClassA")
    local ClassB = extends("ClassB", ClassA)
    assert.is.equal("ClassB", ClassB.className)
  end)
end)

describe("#getClass", function()
  it("Returns the class of the instance", function()
    local ClassA = class("ClassA")
    local instance = ClassA:new()
    assert.is.equal(ClassA, instance:getClass())
  end)

  it("Returns the class of the instance for subclasses", function()
    local ClassA = class("ClassA")
    local ClassB = extends("ClassB", ClassA)
    local instance = ClassB:new()
    assert.is.equal(ClassB, instance:getClass())
  end)
end)

describe("#getMethod", function()
  it("Returns a function that calls the method on the instance", function()
    ---@class ClassA : Base
    local ClassA = class("ClassA")

    function ClassA:sayHello()
      return "Hello"
    end

    local instance = ClassA:new()
    local method = instance:getMethod("sayHello")
    assert.is.equal("Hello", method())
  end)

  it("Returns a function that calls the method with arguments", function()
    ---@class ClassA : Base
    local ClassA = class("ClassA")

    function ClassA:sayHello(name)
      return "Hello, " .. name
    end

    local instance = ClassA:new()
    local method = instance:getMethod("sayHello")
    assert.is.equal("Hello, World", method("World"))
  end)

  it("Fail when the method does not exist", function()
    ---@class ClassA : Base
    local ClassA = class("ClassA")
    local instance = ClassA:new()
    assert.has_error(function()
      instance:getMethod("sayHello")
    end)
  end)

  it("Fail when the method is not a function", function()
    ---@class ClassA : Base
    local ClassA = class("ClassA")

    local instance = ClassA:new()
    ---@diagnostic disable-next-line: inject-field
    instance.notAMethod = 32

    assert.has_error(function()
      instance:getMethod("notAMethod")
    end)
  end)
end)
