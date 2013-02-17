# Hanappe Framework

## Introduction
This is the framework for Moai SDK.

http://getmoai.com/

## Feature
MoaiSDK is powerful.
However, there are many little cumbersome.  

You will be easily able to use the Flower.

* To simplify the coding
* Based object-oriented
* High performance
* Can mix standard code MoaiSDK

## How to use

### Open the window
You must first open the window.
Opens when you start the application.

```Lua
-- main.lualocal modules = require "modules"local config = require "config"Application:start(config)SceneManager:openScene(config.mainScene)```
```Lua
-- config.lua
local config = {
    title = "Title",
    screenWidth = 480,
    screenHeight = 320,
    viewScale = 1, -- Option(Default 1)
    mainScene = "main_scene",
}
return config
```

### Create a Scene
You implement the code to control the scene.
The following sources are defined as a scene controller.

```Lua
-- main_scene.lua
module(..., package.seeall)

function onCreate(params)
    layer = Layer {
        scene = scene,
    }
    sprite = Sprite {
        texture = "cathead.png",
        pos = {0, 0},
        layer = layer,
    }
end
```

The scene controller can define the following event handler.
Called events are registered automatically when you define the function.

* onCreate ... Called when generating the scene
* onDestroy ... Called at the destroy of the scene
* onStart ... Called at the start of the scene
* onStop ... Called at the stop of the scene
* onResume ... Called when you resume the scene
* onPause ... Called at the pause of the scene
* onEnterFrame ... Called at the enter frame of the scene
* onKeyDown ... Called at the key down of the scene
* onKeyUp ... Called at the key up of the scene
* onTouchDown ... Called at the touch down of the scene
* onTouchUp ... Called at the touch up of the scene
* onTouchMove ... Called at the touch move of the scene
* onTouchCancel ... Called at the touch cancel of the scene

### Scene transition
Transition between scenes can be done very easily.

```Lua
-- main_scene.lua
module(..., package.seeall)

function onCreate(params)
    layer = Layer {
        scene = scene,
    }
    sprite = Sprite {
        texture = "cathead.png",
        pos = {0, 0},
        layer = layer,
    }
end

function onTouchDown(e)
    SceneManager:openScene("title_scene", {animation = "fade"})
    --SceneManager:openNextScene("title_scene", {animation = "fade"})
end
```

```Lua
-- title_scene.lua
module(..., package.seeall)

function onCreate(params)
    layer = Layer {
        scene = scene,
    }
    textlabel = TextLabel {
        text = "hello world!",
        size = {200, 30},
        pos = {0, 0},
        layer = layer,
    }
end
```

In the code above, the transition to "title_scene" When you touch the sprite.
In addition, you can define an animation of the scene transitions.
The animation can specify the following parameters.

* "changeNow" ... Switch scenes immediately
* "overlay" ... Displayed over the scene
* "fade" ... The scene in order to fade
* "crossFade" ... The scene fades in parallel
* "popIn" ... Pop-in animation
* "popOut" ... Pop-out animation
* "slideToLeft" ... Slide animation
* "slideToRight" ... Slide animation
* "slideToTop" ... Slide animation
* "slideToBottom" ... Slide animation
* custom function ... You can specify a function that defines the scene

### Layer
Scene is composed of multiple layers.
After you create a scene, create a layer.

```Lua
module(..., package.seeall)

function onCreate(params)
    mainLayer = Layer {
        scene = scene,
    }
    guiLayer = Layer {
        scene = scene,
    }
end
```

Hanappe layer is the class of the extension MOAILayer.
Therefore, you can use all the features of Moai.

### Sprite
The Sprite is a class that extends MOAIProp.

```Lua
module(..., package.seeall)

function onCreate(params)
    layer = Layer {
        scene = scene,
    }
    sprite = Sprite {
        texture = "cathead.png",
        pos = {0, 0},
        layer = layer,
    }
end
```

The texture is automatically cached.
Therefore, the efficiency that I may not particularly care.

If there are no more references to the texture, the resource is automatically released.

Following classes can be used.

* Sprite ... Displays the simple texture.
* SpriteSheet ... Display a texture sheet or tile images.
* MapSprite ... Inherit the SheetImage. This class displays a grid.
* BackgroundSprite ... Displayed on one side of a single texture background.
* NinePatch ... Displays the NinePatch(Not Android).

### Graphics
Graphics class to draw a shape that does not use texture.
You can create a shape in a declarative manner.

```Lua
module(..., package.seeall)

function onCreate(params)
    layer = Layer {
        scene = scene
    }
    
    -- Rect
    g1 = Graphics {width = 50, height = 50, left = 10, top = 10, layer = layer}
    g1:setPenColor(1, 0, 0, 1):fillRect()
    g1:setPenColor(0, 1, 0, 1):drawRect()
end
```

### Text Label
Label to display the text.
Inherit the MOAITextBox.

```Lua
module(..., package.seeall)

function onCreate(params)
    layer = Layer {
        scene = scene
    }
    
    textlabel = TextLabel {
        text = "hello world!",
        size = {200, 30},
        pos = {0, 0},
        layer = layer,
    }
end
```

Also cache Font.
Are devised so that the highest performance.

### Mesh
Mesh displays the shape of the gradient.

```Lua
module(..., package.seeall)

function onCreate(params)
    layer = Layer {
        scene = scene
    }
    
    -- circle
    circle = Mesh.newCircle(10, 10, 25, "#FFCC00")
    circle:setLayer(layer)

    -- rect
    local rectColors = { "#FF0000", "#FFCC00", "#009900", "#0099CC" }
    rect = Mesh.newRect(10, 10, 25, 50, rectColors )
    rect:setLayer(layer)
end
```

### Animation
Animation class can define a continuous complex animation.
It can be defined in the method chain.

```Lua
function onCreate(params)
    layer = Layer {scene = scene}
    
    sprite1 = Sprite {
        texture = "cathead.png",
        layer = layer,
        pos = {0, 0}
    }
    sprite2 = Sprite {
        texture = "cathead.png",
        layer = layer,
        pos = {0, sprite1:getBottom()}
    }

    animation = Animation({sprite1, sprite2}, 1)
        :moveLoc(50, 50, 0)
        :moveRot(0, 0, 180)
        :moveScl(1, 1, 0)
        :wait(3)
        :sequence(
            Animation(sprite1, 1)
                :moveScl(-1, -1, 0)
                :moveRot(0, 0, -180)
                :moveLoc(-50, -50, 0),
            Animation(sprite2, 1)
                :moveScl(-1, -1, 0)
                :moveRot(0, 0, -180)
                :moveLoc(-50, -50, 0)
            )
        :wait(3)
        :parallel(
            Animation(sprite1, 1)
                :setLeft(10):setTop(10),
            Animation(sprite2, 1)
                :setLeft(10)
                :setTop(sprite1:getHeight() + 10)
            )
end

function onStart()
    animation:play {onComplete = completeHandler}
end
```

### GUI
Hanappe can use some GUI.

```Lua
function onCreate(params)
    view = View {
        scene = scene,
        layout = {
            VBoxLayout {
                align = {"center", "center"},
                padding = {10, 10, 10, 10},
            }
        },
        children = {{
            Button {
                name = "startButton",
                text = "start",
                onClick = onStartClick,
            },
            Button {
                name = "backButton",
                text = "back",
                onClick = onBackClick,
            },
            Button {
                name = "testButton1",
                text = "disabled",
                enabled = false,
            },
        }},
    }
end

function onStartClick(e)
    print("onStartClick")
end

function onBackClick(e)
    SceneManager:closeScene({animation = "fade"})
end
```

### Event
Events like Flash can be used.

```Lua
module(..., package.seeall)

function onCreate(e)
    layer = Layer {
        scene = scene,
    }
    sprite = Sprite {
        texture = "cathead.png",
        pos = {0, 0},
        layer = layer,
    }
    
    sprite:addEventListener("message", onMessage)
    sprite:dispatchEvent("message", "Hello world!")
end

function onMessage(e)
	print(e.data)
end
```

You can also catch a touch event.

```Lua
module(..., package.seeall)

function onCreate(e)
    layer = Layer {
        scene = scene,
    }
    sprite = Sprite {
        texture = "cathead.png",
        pos = {0, 0},
        layer = layer,
    }

    sprite:addEventListener("touchDown", onTouch)
    sprite:addEventListener("touchMove", onTouch)
    sprite:addEventListener("touchUp", onTouch)
    sprite:addEventListener("touchCancel", onTouch)
end

function onTouch(e)
	print("Touch!", e.type)
end
```

### Class Inheritance
Class can be extended.
Alternatively, you can define a new class.

```Lua
-- import
local class = require "hp/core/class"

-- Actor class
local Actor = class()

function Actor:init(name)
    self.name = name
end

function Actor:speak()
    print(self.name .. " Hello!")
end

-- Player class
local Player = class(Actor)

function Player:init()
    Actor.init(self, "Player")
end

function Player:speak()
    Actor.speak(self)
    print("speak")
end

-- Use class
local actor = Actor("actor1")
actor:speak()

local player = Player()
player:speak()
```

## Tips

### Why it is not MOAIProp2D?

MOAIProp2D is actually MOAIProp.
It wraps some functions.

MOAIProp2D is deprecated.
In addition, does not exist MOAITextBox2D.

Therefore, I have not used a 2D interface in Flower.

### FPS is not stable

May be stabilized by changing the settings of MOAISim.

```Lua
MOAISim.setStep(1 / 60)MOAISim.clearLoopFlags()MOAISim.setLoopFlags(MOAISim.SIM_LOOP_ALLOW_BOOST)MOAISim.setLoopFlags(MOAISim.SIM_LOOP_LONG_DELAY)MOAISim.setBoostThreshold(0)
```


