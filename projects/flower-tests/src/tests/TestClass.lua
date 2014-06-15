
-- test target
local DisplayObject = flower.DisplayObject
local EventDispatcher = flower.EventDispatcher

-- test case
local TestClass = {}
_G.TestClass = TestClass

local function printTable(target, indent)
    indent = indent or 0
    for k, v in pairs(target) do
        local t = type(v)
        local prefix = ""
        for i = 1, indent do
            prefix = prefix .. "    "
        end
        print(prefix .. k .. "(" .. t .. ") = " .. tostring(v))

        if t == "table" then
            printTable(v, indent + 1)
        end
    end
end

---
-- tearDown
function TestClass:tearDown()

end

---
-- test1
function TestClass:test1_instance_properties()
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
