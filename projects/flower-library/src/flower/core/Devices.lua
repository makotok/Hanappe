----------------------------------------------------------------------------------------------------
-- This is a class that lists information about the device.
----------------------------------------------------------------------------------------------------
local Devices = {}

Devices.desktop640x480 = {
    deviceOS = nil,
    retinaDisplay = false,
    displayDPI = 96,
    displayWidth = 640,
    displayHeight = 480,
}
Devices.iPhone5 = {
    deviceOS = "iOS",
    retinaDisplay = true,
    displayDPI = 326,
    displayWidth = 640,
    displayHeight = 1136,
}
Devices.iPhone5S = {
    deviceOS = "iOS",
    retinaDisplay = true,
    displayDPI = 326,
    displayWidth = 640,
    displayHeight = 1136,
}
Devices.iPhone6 = {
    deviceOS = "iOS",
    retinaDisplay = true,
    displayDPI = 326,
    displayWidth = 750,
    displayHeight = 1334,
}
Devices.iPhone6Plus = {
    deviceOS = "iOS",
    retinaDisplay = true,
    displayDPI = 401,
    displayWidth = 1080,
    displayHeight = 1920,
}
Devices.iPad = {
    deviceOS = "iOS",
    retinaDisplay = true,
    displayDPI = 132,
    displayWidth = 768,
    displayHeight = 1024,
}
Devices.iPadMini = {
    deviceOS = "iOS",
    retinaDisplay = false,
    displayDPI = 163,
    displayWidth = 768,
    displayHeight = 1024,
}
Devices.iPadMini2 = {
    deviceOS = "iOS",
    retinaDisplay = true,
    displayDPI = 326,
    displayWidth = 1536,
    displayHeight = 2048,
}
Devices.iPadAir = {
    deviceOS = "iOS",
    retinaDisplay = true,
    displayDPI = 264,
    displayWidth = 1536,
    displayHeight = 2048,
}

return Devices