# Widget
Widget library that can be used for simple.

## Usage
Example of some components are as follows.

```Lua
widget = require "widget"

function onCreate(e)
    view = widget.UIView {
        scene = scene
    }
    
    button = widget.Button {
        size = {200, 50},
        pos = {10, 10},
        text = "Test1",
        parent = view,
        onClick = button_OnClick,
        onDown = button_OnDown,
        onUp = button_OnUp,
    }

    checkbox = widget.CheckBox {
        pos = {10, 70},
        size = {300, 40},
        parent = view,
        text = "メッセージ",
        selected = true,
        onSelectedChanged = function(e)
            print("checkbox1 selected changed:", e.target:isSelected())
        end,
    }
    
    textInput = widget.TextInput {
        size = {200, 50},
        pos = {10, 120},
        parent = view,
    }

    joystick = widget.Joystick {
    	pos = {10, 180},
        stickMode = "analog",
        parent = view,
        onStickChanged = joystick_OnStickChanged,
    }
    
end
```

### Theme
Can be freely set the Theme.
