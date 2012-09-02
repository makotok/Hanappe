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
        index = 2,
        color = {1, 1, 1, 1},
        font = "fonts/ipag.ttf",
        textSize = 24,
        textColor = {1, 1, 1, 1},
        textPadding = {0, 0, 0, 0},
    },
    over = {
        index = 3,
    },
    disabled = {
        index = 1,
    },
    selected = {
        index = 5,
    },
    selectedOver = {
        index = 6,
    },
    selectedDisabled = {
        index = 4,
    },
}

--------------------------------------------------------------------------------
M.CheckBox = 
{
    normal = {
        skin = "skins/checkbox.png",
        index = 2,
        color = {1, 1, 1, 1},
        font = "fonts/ipag.ttf",
        textSize = 24,
        textColor = {1, 1, 1, 1},
        textPadding = {0, 0, 0, 0},
    },
    over = {
        index = 3,
    },
    disabled = {
        index = 1,
    },
    selected = {
        index = 5,
    },
    selectedOver = {
        index = 6,
    },
    selectedDisabled = {
        index = 4,
    },
}

--------------------------------------------------------------------------------
M.Panel = {
    normal = {
        backgroundSkin = "skins/panel-background.png",
        borderSkin = "skins/panel-border.png",
        color = {1, 1, 1, 1},
        padding = {10, 10, 10, 10},
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