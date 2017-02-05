
-- test target
local DisplayObject = flower.DisplayObject
local EventDispatcher = flower.EventDispatcher

-- test case
local TestString = {}
_G.TestString = TestString

---
-- tearDown
function TestString:tearDown()

end

---
-- test1
function TestString:test1_split()
    local obj1 = DisplayObject()
    local obj2 = EventDispatcher()

    obj1.a = "aaa"
    obj1.b = 10
    obj2.a = "bbb"
    obj2.b = 20
    obj2.c = {cc = 1, cb = "a"}

    print("--- DisplayObject properties ---")
    printTable(obj1:getRefTable().__index)
    print("--- EventDispatcher properties ---")
    printTable(obj2)
end

---
-- test1
function TestString:test2_instanceOf()
    local obj1 = DisplayObject()
    local obj2 = EventDispatcher()

    assertTrue(obj1:instanceOf(DisplayObject))
    assertTrue(obj1:instanceOf(EventDispatcher))

    assertFalse(obj2:instanceOf(DisplayObject))
    assertTrue(obj2:instanceOf(EventDispatcher))

end

