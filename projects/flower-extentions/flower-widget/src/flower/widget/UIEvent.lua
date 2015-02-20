----------------------------------------------------------------------------------------------------
-- @type UIEvent
-- This is a class that defines the type of event.
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Event = require "flower.Event"

-- class
UIEvent = class(Event)

--- UIComponent: Resize Event
UIEvent.RESIZE = "resize"

--- UIComponent: Theme changed Event
UIEvent.THEME_CHANGED = "themeChanged"

--- UIComponent: Style changed Event
UIEvent.STYLE_CHANGED = "styleChanged"

--- UIComponent: Enabled changed Event
UIEvent.ENABLED_CHANGED = "enabledChanged"

--- UIComponent: FocusIn Event
UIEvent.FOCUS_IN = "focusIn"

--- UIComponent: FocusOut Event
UIEvent.FOCUS_OUT = "focusOut"

--- Button: Click Event
UIEvent.CLICK = "click"

--- Button: Click Event
UIEvent.CANCEL = "cancel"

--- Button: Selected changed Event
UIEvent.SELECTED_CHANGED = "selectedChanged"

--- Button: down Event
UIEvent.DOWN = "down"

--- Button: up Event
UIEvent.UP = "up"

--- Slider: value changed Event
UIEvent.VALUE_CHANGED = "valueChanged"

--- Joystick: Event type when you change the position of the stick
UIEvent.STICK_CHANGED = "stickChanged"

--- MsgBox: msgShow Event
UIEvent.MSG_SHOW = "msgShow"

--- MsgBox: msgHide Event
UIEvent.MSG_HIDE = "msgHide"

--- MsgBox: msgEnd Event
UIEvent.MSG_END = "msgEnd"

--- MsgBox: spoolStop Event
UIEvent.SPOOL_STOP = "spoolStop"

--- ListBox: selectedChanged
UIEvent.ITEM_CHANGED = "itemChanged"

--- ListBox: enter
UIEvent.ITEM_ENTER = "itemEnter"

--- ListBox: itemClick
UIEvent.ITEM_CLICK = "itemClick"

--- ScrollGroup: scroll
UIEvent.SCROLL = "scroll"

return UIEvent