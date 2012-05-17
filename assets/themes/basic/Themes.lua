local Themes = {
    Button = {
        upSkin = "assets/themes/basic/skins/btn_up.png",
        downSkin = "assets/themes/basic/skins/btn_down.png",
        disabledUpSkin = "assets/themes/basic/skins/btn_disable.png",
        disabledDownSkin = "assets/themes/basic/skins/btn_disable.png",
        fontPath = "assets/fonts/ipag.ttf",
        fontSize = 24,
        fontColor = {1, 1, 1, 1},
        onStateChanged = function(self)
        end,
    },
    RadioButton = {
        upSkin = "assets/themes/basic/skins/radio_off.png",
        downSkin = "assets/themes/basic/skins/radio_on.png",
        disabledUpSkin = "assets/themes/basic/skins/radio_off_disable.png",
        disabledDownSkin = "assets/themes/basic/skins/radio_off_disable.png",
        fontPath = "assets/fonts/ipag.ttf",
        fontSize = 24,
        fontColor = {1, 1, 1, 1},
        onStateChanged = function(self)
        end,
    },
    CheckBox = {
        upSkin = "assets/themes/basic/skins/checkbox_off.png",
        downSkin = "assets/themes/basic/skins/checkbox_on.png",
        disabledUpSkin = "assets/themes/basic/skins/checkbox_on_disabled.png",
        disabledDownSkin = "assets/themes/basic/skins/checkbox_off_disabled.png",
        fontPath = "assets/fonts/ipag.ttf",
        fontSize = 24,
        fontColor = {1, 1, 1, 1},
        onStateChanged = function(self)
        end,
    },
    Panel = {
        skin = "assets/themes/basic/skins/panel.png",
    },
    MessageBox = {
        skin = "assets/themes/basic/skins/panel.png",
        paddingTop = 10,
        paddingLeft = 10,
        paddingBottom = 10,
        paddingRight = 10,
    },
    ScrollView = {
        vScrollEnabled = true,
        hScrollEnabled = true,
    },
    ListView = {
        vScrollEnabled = true,
        hScrollEnabled = false,
    },
    TextView = {
        vScrollEnabled = true,
        hScrollEnabled = false,
    },
    HScrollBar = {
        skin = "assets/themes/basic/skins/scrollbar_horizontal.png"
    },
    VScrollBar = {
        skin = "assets/themes/basic/skins/scrollbar_vertical.png"
    },
}

return Themes