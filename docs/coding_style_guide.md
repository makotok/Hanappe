# Coding Style Guide

## Lua

Coding style of Lua basically.
However, I have changed the style of some.

* [LuaStyleGuide](http://lua-users.org/wiki/LuaStyleGuide)

### Indent

Do not use the Tab.
Indented four spaces.

It is carried out in automatic formatter of Eclipse is desirable.

### Comments

Header comments written in LDoc format.

```Lua
-- Example

---
-- Test Method.
-- @param name name
-- @param value value
-- @return name and value
-- @return value
Class:doTest(name, value)
    return name .. "|" .. value, value
end
```

