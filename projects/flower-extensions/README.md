# Flower Extensions

## Introduction
It is a module that extends the Flower Library.

## Feature
This provides a powerful several modules. 

* Tiled. Module for using the Tiled Map Editor.
* Widget. Widget module that is simple and easy to use.
* Audio. Audio library that can be used for simple.

## Tiled
A library for using Tiled Map Editor.

http://www.mapeditor.org/

### Usage
It is the simplest way.

```Lua
tiled = require "tiled"

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)
    layer:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)
    
    tileMap = tiled.TileMap()
    tileMap:loadLueFile("platform.lue")
    tileMap:setLayer(layer)
end
```

### Isometric
It is possible to use Isometric.

### Performance
Designed to reduce the drawing.

When using a single tileset, and perform only once drawn.

### Scalability
Design for easy expansion.

Easy to inherited class, switching is simple.

## Widget
Widget library that can be used for simple.

### Usage
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

## Audio
Audio library that can be used for simple.

