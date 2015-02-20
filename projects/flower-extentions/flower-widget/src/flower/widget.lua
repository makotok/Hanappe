----------------------------------------------------------------------------------------------------
-- Flower Extentions Library for widget.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- module
local widget = {}

----------------------------------------------------------------------------------------------------
-- Functions
----------------------------------------------------------------------------------------------------

---
-- This class is an dialog or IOS and Android.
-- @param ... title, message, positive, neutral, negative, cancelable, callback
function widget.showDialog(...)
    local MOAIDialog = MOAIDialogAndroid or MOAIDialogIOS
    MOAIDialog.showDialog(...)
end

---
-- Set the theme of widget.
-- TODO:Theme can be changed dynamically
-- @param theme theme of widget
function widget.setTheme(theme)
    widget.getThemeMgr():setTheme(theme)
end

---
-- Return the theme of widget.
-- @return theme
function widget.getTheme()
    return widget.getThemeMgr():getTheme()
end

---
-- Return the singlton instance of ThemeMgr. 
-- @return themeMgr
function widget.getThemeMgr()
    return widget.ThemeMgr.getInstance()
end

---
-- Return the singlton instance of FocusMgr.
-- TODO:Delete
-- @return focusMgr
function widget.getFocusMgr()
    return widget.FocusMgr.getInstance()
end

---
-- Return the singlton instance of LayoutMgr.
-- @return LayoutMgr
function widget.getLayoutMgr()
    return widget.LayoutMgr.getInstance()
end

---
-- Return the singlton instance of IconMgr.
-- @return IconMgr
function widget.getIconMgr()
    return widget.IconMgr.getInstance()
end

----------------------------------------------------------------------------------------------------
-- Classes
-- @section Classes
----------------------------------------------------------------------------------------------------

---
-- Themes Class.
-- @see flower.widget.Themes
widget.Themes = require "flower.widget.Themes"

---
-- ThemeMgr Class.
-- @see flower.widget.ThemeMgr
widget.ThemeMgr = require "flower.widget.ThemeMgr"

---
-- FocusMgr Class.
-- @see flower.widget.FocusMgr
widget.FocusMgr = require "flower.widget.FocusMgr"

---
-- LayoutMgr Class.
-- @see flower.widget.LayoutMgr
widget.LayoutMgr = require "flower.widget.LayoutMgr"

---
-- IconMgr Class.
-- @see flower.widget.IconMgr
widget.IconMgr = require "flower.widget.IconMgr"

---
-- TextAlign Class.
-- @see flower.widget.TextAlign
widget.TextAlign = require "flower.widget.TextAlign"

---
-- UIEvent Class.
-- @see flower.widget.UIEvent
widget.UIEvent = require "flower.widget.UIEvent"

---
-- UIComponent Class.
-- @see flower.widget.UIComponent
widget.UIComponent = require "flower.widget.UIComponent"

---
-- UILayer Class.
-- @see flower.widget.UILayer
widget.UILayer = require "flower.widget.UILayer"

---
-- UIGroup Class.
-- @see flower.widget.UIGroup
widget.UIGroup = require "flower.widget.UIGroup"

---
-- UIView Class.
-- @see flower.widget.UIView
widget.UIView = require "flower.widget.UIView"

---
-- UILayout Class.
-- @see flower.widget.UILayout
widget.UILayout = require "flower.widget.UILayout"

---
-- UILabel Class.
-- @see flower.widget.UILabel
widget.UILabel = require "flower.widget.UILabel"

---
-- BoxLayout Class.
-- @see flower.widget.BoxLayout
widget.BoxLayout = require "flower.widget.BoxLayout"

---
-- Button Class.
-- @see flower.widget.Button
widget.Button = require "flower.widget.Button"

---
-- ImageButton Class.
-- @see flower.widget.ImageButton
widget.ImageButton = require "flower.widget.ImageButton"

---
-- SheetButton Class.
-- @see flower.widget.SheetButton
widget.SheetButton = require "flower.widget.SheetButton"

---
-- CheckBox Class.
-- @see flower.widget.CheckBox
widget.CheckBox = require "flower.widget.CheckBox"

---
-- Joystick Class.
-- @see flower.widget.Joystick
widget.Joystick = require "flower.widget.Joystick"

---
-- Panel Class.
-- @see flower.widget.Panel
widget.Panel = require "flower.widget.Panel"

---
-- TextBox Class.
-- @see flower.widget.TextBox
widget.TextBox = require "flower.widget.TextBox"

---
-- TextInput Class.
-- @see flower.widget.TextInput
widget.TextInput = require "flower.widget.TextInput"

---
-- MsgBox Class.
-- @see flower.widget.MsgBox
widget.MsgBox = require "flower.widget.MsgBox"

---
-- ListBox Class.
-- @see flower.widget.ListBox
widget.ListBox = require "flower.widget.ListBox"

---
-- ListItem Class.
-- @see flower.widget.ListItem
widget.ListItem = require "flower.widget.ListItem"

---
-- Slider Class.
-- @see flower.widget.Slider
widget.Slider = require "flower.widget.Slider"

---
-- Spacer Class.
-- @see flower.widget.Spacer
widget.Spacer = require "flower.widget.Spacer"

---
-- ScrollGroup Class.
-- @see flower.widget.ScrollGroup
widget.ScrollGroup = require "flower.widget.ScrollGroup"

---
-- ScrollView Class.
-- @see flower.widget.ScrollView
widget.ScrollView = require "flower.widget.ScrollView"

---
-- PanelView Class.
-- @see flower.widget.PanelView
widget.PanelView = require "flower.widget.PanelView"

---
-- TextView Class.
-- @see flower.widget.TextView
widget.TextView = require "flower.widget.TextView"

---
-- ListView Class.
-- @see flower.widget.ListView
widget.ListView = require "flower.widget.ListView"

---
-- ListViewLayout Class.
-- @see flower.widget.ListViewLayout
widget.ListViewLayout = require "flower.widget.ListViewLayout"

---
-- BaseItemRenderer Class.
-- @see flower.widget.BaseItemRenderer
widget.BaseItemRenderer = require "flower.widget.BaseItemRenderer"

---
-- LabelItemRenderer Class.
-- @see flower.widget.LabelItemRenderer
widget.LabelItemRenderer = require "flower.widget.LabelItemRenderer"


-- compatibility
widget.TextLabel = widget.UILabel


return widget