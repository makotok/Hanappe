module(..., package.seeall)

local aspect = require "aspect"

-- target table
local target1 = {
    print = function(self, ...)
        print(...)
    end,
    
    move = function(self, x, y)
        print("move", x, y)
    end,
}

local target2 = {
    print = function(...)
        print(...)
    end,
}

-- interceptor
local interceptor = aspect.Interceptor({target1, target2})

function interceptor:beginProcess(context, ...)
    print("[BEGIN]", context.name)
end

function interceptor:endProcess(context, ...)
    print("[END]", context.name)
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)

    target1:print("Hello", "World")
    target1:move(1, 2)
    target2.print("Hello", "World")
end

