local table = require("hp/lang/table")

local M = {}

--------------------------------------------------------------------------------
M.Button = {
    upSkin = "themes/basic/skins/btn_up.png",
    downSkin = "themes/basic/skins/btn_down.png",
    disabledUpSkin = "themes/basic/skins/btn_disable.png",
    disabledDownSkin = "themes/basic/skins/btn_disable.png",
    fontPath = "fonts/ipag.ttf",
    fontSize = 24,
    fontUpColor = {red = 1, green = 1, blue = 1, alpha = 1},
    fontDownColor = {red = 1, green = 1, blue = 1, alpha = 1},
    upColor = {red = 1, green = 1, blue = 1, alpha = 1},
    downColor = {red = 1, green = 1, blue = 1, alpha = 1},
    paddingTop = 5,
    paddingLeft = 5,
    paddingBottom = 5,
    paddingRight = 5,
}

--------------------------------------------------------------------------------
M.RadioButton = table.deepCopy(M.Button)
M.RadioButton = table.deepCopy(
{
    upSkin = "themes/basic/skins/radio_off.png",
    downSkin = "themes/basic/skins/radio_on.png",
    disabledUpSkin = "themes/basic/skins/radio_off_disable.png",
    disabledDownSkin = "themes/basic/skins/radio_off_disable.png",
    paddingTop = 0,
    paddingLeft = 0,
    paddingBottom = 0,
    paddingRight = 0,
}, M.RadioButton)

--------------------------------------------------------------------------------
M.CheckBox = table.deepCopy(M.Button)
M.CheckBox = table.deepCopy(
{
    upSkin = "themes/basic/skins/checkbox_off.png",
    downSkin = "themes/basic/skins/checkbox_on.png",
    disabledUpSkin = "themes/basic/skins/checkbox_on_disabled.png",
    disabledDownSkin = "themes/basic/skins/checkbox_off_disabled.png",
    paddingTop = 0,
    paddingLeft = 0,
    paddingBottom = 0,
    paddingRight = 0,
}, M.CheckBox)

--------------------------------------------------------------------------------
M.Panel = {
    skin = "themes/basic/skins/panel.png",
}

--------------------------------------------------------------------------------
M.MessageBox = {
    skin = "themes/basic/skins/panel.png",
    textSize = 16,
    paddingTop = 10,
    paddingLeft = 10,
    paddingBottom = 10,
    paddingRight = 10,
}

--------------------------------------------------------------------------------
M.ScrollView = {
    vScrollEnabled = true,
    hScrollEnabled = true,
}

--------------------------------------------------------------------------------
M.ListView = {
    vScrollEnabled = true,
    hScrollEnabled = false,
}

--------------------------------------------------------------------------------
M.TextView = {
    vScrollEnabled = true,
    hScrollEnabled = false,
}

--------------------------------------------------------------------------------
M.HScrollBar = {
    skin = "themes/basic/skins/scrollbar_horizontal.png"
}

--------------------------------------------------------------------------------
M.VScrollBar = {
    skin = "themes/basic/skins/scrollbar_vertical.png"
}
--------------------------------------------------------------------------------

return M