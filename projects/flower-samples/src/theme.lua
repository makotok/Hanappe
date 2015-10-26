----------------------------------------------------------------------------------------------------
-- Widget Themes.
-- 
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local ClassFactory = require "flower.ClassFactory"
local ThemeMgr = require "flower.widget.ThemeMgr"

-- Theme
-- You can override the theme individually
local Theme = {
    common = {
    },
    UILabel = {
    },
    Button = {
    },
    ImageButton = {
    },
    SheetButton = {
    },
    CheckBox = {
    },
    Joystick = {
    },
    Slider = {
    },
    Panel = {
    },
    TextBox = {
    },
    TextInput = {
    },
    MsgBox = {
    },
    DialogBox = {
    },
    ListBox = {
    },
    ListItem = {
    },
    ScrollGroup = {
    },
    ScrollView = {
    },
    PanelView = {
    },
    TextView = {
    },
    ListView = {
    },
    BaseItemRenderer = {
    },
    LabelItemRenderer = {
    },
    ImageLabelItemRenderer = {
    },
    SheetImageLabelItemRenderer = {
    },
    CheckBoxItemRenderer = {
    },
    WidgetItemRenderer = {
    },
}

ThemeMgr.getInstance():overrideTheme(Theme)

return Theme
