----------------------------------------------------------------------------------------------------
-- Widget Themes.
-- 
-- @author Makoto
-- @release V2.1.2
----------------------------------------------------------------------------------------------------

-- module
local Themes = {}

-- import
local ClassFactory = require "flower.ClassFactory"
local ThemeMgr = require "flower.widget.ThemeMgr"
local MsgBox = require "flower.widget.MsgBox"
local ListItem = require "flower.widget.ListItem"
local LabelItemRenderer = require "flower.widget.LabelItemRenderer"

--- Normal theme
Themes.NORMAL = {
    common = {
        normalColor = {1, 1, 1, 1},
        disabledColor = {0.5, 0.5, 0.5, 1},
    },
    UILabel = {
        textSize = 20,
        textColor = {1, 1, 1, 1},
        textAlign = {"left", "top"},
        textPadding = {0, 0, 0, 0},
        textResizePolicy = {"none", "none"},
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
        textPadding = {0, 0, 0, 0},
    },
    ImageButton = {
        parentStyle = "Button",
        normalTexture = "skins/imagebutton_normal.png",
        selectedTexture = "skins/imagebutton_selected.png",
        disabledTexture = "skins/imagebutton_disabled.png",
        textColor = {1, 1, 1, 1},
        textPadding = {10, 5, 10, 5},
    },
    SheetButton = {
        parentStyle = "Button",
        textureSheets = "skins/texture_sheets",
        normalTexture = "gb-up.png",
        selectedTexture = "gb-down.png",
        disabledTexture = "gb-up.png",
    },
    CheckBox = {
        parentStyle = "ImageButton",
        normalTexture = "skins/checkbox_normal.png",
        selectedTexture = "skins/checkbox_selected.png",
        disabledTexture = "skins/checkbox_normal.png",
        textAlign = {"left", "center"},
        textPadding = {0, 0, 0, 0},
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
        textSize = 20,
        textColor = {1, 1, 1, 1},
        textAlign = {"left", "top"},
        textPadding = {0, 0, 0, 0},
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
    DialogBox = {
        backgroundTexture = "skins/dialog_panel.9.png",
        backgroundColor = {1, 1, 1, 1},
        minSize = {300, 180},
        fontName = "VL-PGothic.ttf",
        textPadding = {5, 5, 5, 5},
        textSize = 20,
        textColor = {1, 1, 1, 1},
        titleFontName = "VL-PGothic.ttf",
        titlePadding = {0, 0, 0, 0},
        titleSize = 20,
        titleColor = {1, 1, 0, 1},
        iconPadding = {5, 5, 0, 5},
        iconScaleFactor = 0.5,
        iconInfo = "skins/dialog_icon_info.png",
        iconConfirm = "skins/dialog_icon_okay.png",
        iconWarning = "skins/dialog_icon_warning.png",
        iconError = "skins/dialog_icon_error.png",
        buttonsPadding = {5, 0, 5, 5},
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
        textPadding = {0, 0, 0, 0},
    },
    ScrollGroup = {
        friction = 0.1,
        scrollPolicy = {true, true},
        bouncePolicy = {true, true},
        scrollForceLimits = {0.5, 0.5, 100, 100},
        verticalScrollBarColor = {1, 1, 1, 0.5},
        verticalScrollBarTexture = "skins/scrollbar_vertical.9.png",
        horizontalScrollBarColor = {1, 1, 1, 0.5},
        horizontalScrollBarTexture = "skins/scrollbar_horizontal.9.png",
    },
    ScrollView = {
        parentStyle = "ScrollGroup",
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
        rowHeight = 40,
        columnCount = 1,
        borderColor = {0.5, 0.5, 0.5, 1},
        itemRendererFactory = ClassFactory(LabelItemRenderer),
    },
    BaseItemRenderer = {
        backgroundColor = {0, 0, 0, 0},
        backgroundPressedColor = {0.5, 0.5, 0.5, 0.5},
        backgroundSelectedColor = {0.5, 0.5, 0.8, 0.5},
        bottomBorderColor = {0.5, 0.5, 0.5, 0.5},
    },
    LabelItemRenderer = {
        parentStyle = "BaseItemRenderer",
        textSize = 24,
        textColor = {1, 1, 1, 1},
        textAlign = {"left", "center"},
        textPadding = {5, 0, 5, 0},
        textResizePolicy = {"none", "none"},
    },
    ImageLabelItemRenderer = {
        parentStyle = "LabelItemRenderer",
    },
    ImageItemRenderer = {
        parentStyle = "BaseItemRenderer",
    },
}

-- initial theme
ThemeMgr.getInstance():setTheme(Themes.NORMAL)

return ThemeMgr
