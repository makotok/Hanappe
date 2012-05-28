local table = require("hp/lang/table")

local M = {}

--------------------------------------------------------------------------------
M.Button = {
    upSkin = "assets/themes/basic/skins/btn_up.png",
    downSkin = "assets/themes/basic/skins/btn_down.png",
    disabledUpSkin = "assets/themes/basic/skins/btn_disable.png",
    disabledDownSkin = "assets/themes/basic/skins/btn_disable.png",
    fontPath = "assets/fonts/ipag.ttf",
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
    upSkin = "assets/themes/basic/skins/radio_off.png",
    downSkin = "assets/themes/basic/skins/radio_on.png",
    disabledUpSkin = "assets/themes/basic/skins/radio_off_disable.png",
    disabledDownSkin = "assets/themes/basic/skins/radio_off_disable.png",
    paddingTop = 0,
    paddingLeft = 0,
    paddingBottom = 0,
    paddingRight = 0,
})

--------------------------------------------------------------------------------
M.CheckBox = table.deepCopy(M.Button)
M.CheckBox = table.deepCopy(
{
    upSkin = "assets/themes/basic/skins/checkbox_off.png",
    downSkin = "assets/themes/basic/skins/checkbox_on.png",
    disabledUpSkin = "assets/themes/basic/skins/checkbox_on_disabled.png",
    disabledDownSkin = "assets/themes/basic/skins/checkbox_off_disabled.png",
    paddingTop = 0,
    paddingLeft = 0,
    paddingBottom = 0,
    paddingRight = 0,
})

--------------------------------------------------------------------------------
M.Panel = {
    skin = "assets/themes/basic/skins/panel.png",
}

--------------------------------------------------------------------------------
M.MessageBox = {
    skin = "assets/themes/basic/skins/panel.png",
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
    skin = "assets/themes/basic/skins/scrollbar_horizontal.png"
}

--------------------------------------------------------------------------------
M.VScrollBar = {
    skin = "assets/themes/basic/skins/scrollbar_vertical.png"
}
--------------------------------------------------------------------------------

return M