----------------------------------------------------------------------------------------------------
-- @type PropertyUtils
--
-- It is a property utility class.
----------------------------------------------------------------------------------------------------

-- class
local PropertyUtils = {}

-- Property cache
PropertyUtils.SETTER_NAMES = {}

---
-- Sets the properties to object.
-- @param obj target object
-- @param properties source properties
-- @param unpackFlag Expand in the case of a simple table
function PropertyUtils.setProperties(obj, properties, unpackFlag)
    for name, value in pairs(properties) do
        PropertyUtils.setProperty(obj, name, value, unpackFlag)
    end
end

---
-- Sets the property to object.
-- @param obj target object
-- @param name property name
-- @param value property value
-- @param unpackFlag Expand in the case of a simple table
function PropertyUtils.setProperty(obj, name, value, unpackFlag)
    local setterNames = PropertyUtils.SETTER_NAMES
    if not setterNames[name] then
        local setterName = "set" .. name:sub(1, 1):upper() .. (#name > 1 and name:sub(2) or "")
        setterNames[name] = setterName
    end

    local setterName = setterNames[name]
    local setter = assert(obj[setterName], "Not Found Property!" .. name)
    if not unpackFlag or type(value) ~= "table" or getmetatable(value) ~= nil then
        return setter(obj, value)
    else
        return setter(obj, unpack(value))
    end
end

return PropertyUtils