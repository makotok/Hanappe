--------------------------------------------------------------------------------
-- 標準的なGUIテーマです.
--------------------------------------------------------------------------------

-- import
local Display       = require "hp/modules/Display"

-- module define
local M             = {}

--------------------------------------------------------------------------------
M.Button = {
    normal = {
        skin = "skins/button-normal.png",
        skinClass = Display.Sprite,
        color = {1, 1, 1, 1},
        font = "fonts/ipag.ttf",
        textSize = 24,
        textColor = {0.8, 0.8, 0.8, 1},
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

--------------------------------------------------------------------------------
M.RadioButton = {
    normal = {
        skin = "skins/radio-button.png",
        onIndex = 5,
        offIndex = 2,
        color = {1, 1, 1, 1},
        font = "fonts/ipag.ttf",
        textSize = 24,
        textColor = {1, 1, 1, 1},
        textPadding = {0, 0, 0, 0},
    },
    over = {
        onIndex = 6,
        offIndex = 3,
    },
    disabled = {
        onIndex = 4,
        offIndex = 1,
    },
}

--------------------------------------------------------------------------------
M.CheckBox = 
{
    normal = {
        skin = "skins/checkbox.png",
        onIndex = 5,
        offIndex = 2,
        color = {1, 1, 1, 1},
        font = "fonts/ipag.ttf",
        textSize = 24,
        textColor = {1, 1, 1, 1},
        textPadding = {0, 0, 0, 0},
    },
    over = {
        onIndex = 6,
        offIndex = 3,
    },
    disabled = {
        onIndex = 4,
        offIndex = 1,
    },
}

--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
M.Panel = {
    normal = {
        backgroundSkin = "skins/panel-background.png",
        backgroundSkinClass = Display.Sprite,
        backgroundColor = {1, 1, 1, 1},
        borderSkin = "skins/panel-border.png",
        borderSkinClass = Display.NinePatch,
        borderColor = {1, 1, 1, 1},
        color = {1, 1, 1, 1}
    },
    disabled = {
        color = {0.5, 0.5, 0.5, 1},
    },
}

--------------------------------------------------------------------------------
M.MessageBox = {
    normal = {
        backgroundSkin = "skins/panel-background.png",
        borderSkin = "skins/panel-border.png",
        color = {1, 1, 1, 1},
        padding = {10, 10, 10, 10},
        textSize = 16,
        textColor = {1, 1, 1, 1},
    },
    disabled = {
        color = {0.5, 0.5, 0.5, 1},
    },
}

--------------------------------------------------------------------------------

return M