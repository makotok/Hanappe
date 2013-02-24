--------------------------------------------------------------------------------
-- This is a standard GUI theme.
-- Can not dynamically change the theme.
--------------------------------------------------------------------------------

-- import
local Sprite            = require "hp/display/Sprite"
local NinePatch         = require "hp/display/NinePatch"

-- module define
local M                 = {}

M.Button = {
    normal = {
        skin = "skins/button-normal.png",
        skinClass = NinePatch,
        skinColor = {1, 1, 1, 1},
        font = "VL-PGothic",
        textSize = 24,
        textColor = {0.0, 0.0, 0.0, 1},
        textPadding = {10, 5, 10, 8},
    },
    selected = {
        skin = "skins/button-selected.png",
    },
    over = {
        skin = "skins/button-over.png",
    },
    disabled = {
        skin = "skins/button-disabled.png",
        textColor = {0.5, 0.5, 0.5, 1},
    },
}

M.Joystick = {
    normal = {
        baseSkin = "skins/joystick_base.png",
        knobSkin = "skins/joystick_knob.png",
        baseColor = {1, 1, 1, 1},
        knobColor = {1, 1, 1, 1},
    },
    disabled = {
        baseColor = {0.5, 0.5, 0.5, 1},
        knobColor = {0.5, 0.5, 0.5, 1},
    },
}

M.Panel = {
    normal = {
        backgroundSkin = "skins/panel.png",
        backgroundSkinClass = NinePatch,
        backgroundColor = {1, 1, 1, 1},
    },
    disabled = {
        backgroundColor = {0.5, 0.5, 0.5, 1},
    },
}

M.MessageBox = {
    normal = {
        backgroundSkin = "skins/panel.png",
        backgroundSkinClass = NinePatch,
        backgroundColor = {1, 1, 1, 1},
        font = "VL-PGothic",
        textPadding = {20, 20, 15, 15},
        textSize = 20,
        textColor = {0, 0, 0, 1},
    },
    disabled = {
        backgroundColor = {0.5, 0.5, 0.5, 1},
        textColor = {0.2, 0.2, 0.2, 1},
    },
}

return M