----------------------------------------------------------------------------------------------------
-- This is a class that lists information about the device.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- class
local Devices = {}

--- desktop for 640x480
Devices.desktop640x480 = {
    deviceOS = nil,
    retinaDisplay = false,
    displayDPI = 96,
    displayWidth = 640,
    displayHeight = 480,
}

--- iPhone5
Devices.iPhone5 = {
    deviceOS = "iOS",
    retinaDisplay = true,
    displayDPI = 326,
    displayWidth = 640,
    displayHeight = 1136,
}

--- iPhone5S
Devices.iPhone5S = {
    deviceOS = "iOS",
    retinaDisplay = true,
    displayDPI = 326,
    displayWidth = 640,
    displayHeight = 1136,
}

--- iPhone6
Devices.iPhone6 = {
    deviceOS = "iOS",
    retinaDisplay = true,
    displayDPI = 326,
    displayWidth = 750,
    displayHeight = 1334,
}

--- iPhone6Plus
Devices.iPhone6Plus = {
    deviceOS = "iOS",
    retinaDisplay = true,
    displayDPI = 401,
    displayWidth = 1080,
    displayHeight = 1920,
}

--- iPad
Devices.iPad = {
    deviceOS = "iOS",
    retinaDisplay = true,
    displayDPI = 132,
    displayWidth = 768,
    displayHeight = 1024,
}

--- iPadMini
Devices.iPadMini = {
    deviceOS = "iOS",
    retinaDisplay = false,
    displayDPI = 163,
    displayWidth = 768,
    displayHeight = 1024,
}

--- iPadMini2
Devices.iPadMini2 = {
    deviceOS = "iOS",
    retinaDisplay = true,
    displayDPI = 326,
    displayWidth = 1536,
    displayHeight = 2048,
}

--- iPadAir
Devices.iPadAir = {
    deviceOS = "iOS",
    retinaDisplay = true,
    displayDPI = 264,
    displayWidth = 1536,
    displayHeight = 2048,
}

return Devices