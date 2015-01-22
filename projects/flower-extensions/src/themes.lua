----------------------------------------------------------------------------------------------------
-- Widget Themes.
-- 
-- @author Makoto
-- @release V2.1.2
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- import
local flower = require "flower"
local widget = require "widget"
local ClassFactory = flower.ClassFactory
local MsgBox = widget.MsgBox
local ListItem = widget.ListItem

--- Normal theme
M.NORMAL = {
    common = {
        normalColor = {1, 1, 1, 1},
        disabledColor = {0.5, 0.5, 0.5, 1},
    },
    Button = {
        normalTexture = "skins/button_normal.9.png",
        selectedTexture = "skins/button_selected.9.png",
        disabledTexture = "skins/button_normal.9.png",
        fontName = "VL-PGothic.ttf",
        textSize = 20,
        textColor = {0, 0, 0, 1},
        textDisabledColor = {0.5, 0.5, 0.5, 1},
        textAlign = {"center", "center"},
    },
    ImageButton = {
        normalTexture = "skins/imagebutton_normal.png",
        selectedTexture = "skins/imagebutton_selected.png",
        disabledTexture = "skins/imagebutton_disabled.png",
        fontName = "VL-PGothic.ttf",
        textSize = 20,
        textColor = {1, 1, 1, 1},
        textDisabledColor = {0.5, 0.5, 0.5, 1},
        textAlign = {"center", "center"},
        textPadding = {10, 5, 10, 5},
    },
    SheetButton = {
        textureSheets = "skins/texture_sheets",
        normalTexture = "gb-up.png",
        selectedTexture = "gb-down.png",
        disabledTexture = "gb-up.png",
        fontName = "VL-PGothic.ttf",
        textSize = 20,
        textColor = {0, 0, 0, 1},
        textDisabledColor = {0.5, 0.5, 0.5, 1},
        textAlign = {"center", "center"},
    },
    CheckBox = {
        normalTexture = "skins/checkbox_normal.png",
        selectedTexture = "skins/checkbox_selected.png",
        disabledTexture = "skins/checkbox_normal.png",
        fontName = "VL-PGothic.ttf",
        textSize = 20,
        textColor = {1, 1, 1, 1},
        textDisabledColor = {0.5, 0.5, 0.5, 1},
        textAlign = {"left", "center"},
    },
    Joystick = {
        baseTexture = "skins/joystick_base.png",
        knobTexture = "skins/joystick_knob.png",
    },
    Slider = {
        backgroundTexture = "skins/slider_background.9.png",
        progressTexture = "skins/slider_progress.9.png",
        thumbTexture = "skins/slider_thumb.png",
    },
    Panel = {
        backgroundTexture = "skins/panel.9.png",
    },
    TextBox = {
        parentStyle = "Panel",
        fontName = "VL-PGothic.ttf",
        textSize = 18,
        textColor = {1, 1, 1, 1},
        textAlign = {"left", "top"},
    },
    TextInput = {
        parentStyle = "TextBox",
        backgroundTexture = "skins/textinput_normal.9.png",
        focusTexture = "skins/textinput_focus.9.png",
        textColor = {0, 0, 0, 1},
        textAlign = {"left", "center"},
    },
    MsgBox = {
        parentStyle = "TextBox",
        pauseTexture = "skins/msgbox_pause.png",
        animShowFunction = MsgBox.ANIM_SHOW_FUNCTION,
        animHideFunction = MsgBox.ANIM_HIDE_FUNCTION,
    },
    ListBox = {
        parentStyle = "Panel",
        scrollBarTexture = "skins/scrollbar_vertical.9.png",
        rowHeight = 35,
        listItemFactory = ClassFactory(ListItem),
    },
    ListItem = {
        backgroundTexture = "skins/listitem_background.9.png",
        backgroundVisible = false,
        fontName = "VL-PGothic.ttf",
        textSize = 20,
        textColor = {1, 1, 1, 1},
        textAlign = {"left", "top"},
        iconVisible = true,
        iconTexture = "skins/icons.png",
        iconTileSize = {24, 24},
    },
    ScrollGroup = {
        friction = 0.1,
        scrollPolicy = {true, true},
        bouncePolicy = {true, true},
        scrollForceLimits = {0.5, 0.5, 100, 100},
        verticalScrollBarTexture = "skins/scrollbar_vertical.9.png",
        horizontalScrollBarTexture = "skins/scrollbar_horizontal.9.png",
    },
    ScrollView = {
        friction = 0.1,
        scrollPolicy = {true, true},
        bouncePolicy = {true, true},
        scrollForceLimits = {0.5, 0.5, 100, 100},
        verticalScrollBarTexture = "skins/scrollbar_vertical.9.png",
        horizontalScrollBarTexture = "skins/scrollbar_horizontal.9.png",
    },
    PanelView = {
        parentStyle = "ScrollView",
        backgroundTexture = "skins/panel.9.png",
    },
    TextView = {
        parentStyle = "PanelView",
        scrollPolicy = {false, true},
        fontName = "VL-PGothic.ttf",
        textSize = 18,
        textColor = {1, 1, 1, 1},
        textAlign = {"left", "top"},
    },
    ListView = {
        parentStyle = "PanelView",
        scrollPolicy = {false, true},
        rowHeight = 35,
        listItemRendererFactory = ClassFactory(ListItem),
    },
}

-- initial theme
widget.setTheme(M.NORMAL)

return M
