# Flower Library

## Introduction
Flower is a simple, lightweight library for MoaiSDK.

http://getmoai.com/

## Feature
MoaiSDK is powerful.
However, there are many little cumbersome.  

You will be easily able to use the Flower.

* To simplify the coding
* There is only one file
* Based object-oriented
* High performance
* Can mix standard code MoaiSDK

## Difference with Hanappe

Flower is improved Hanappe.
I is common in many parts of the Hanappe.

Hanappe can implement very interesting.

```Lua
-- Hanappe Code
module(..., package.seeall)

function onCreate(params)
    layer = Layer {
        scene = scene,
    }
    group = Group {
        layer = layer,
        color = {0.5, 0.5, 0.5, 1},
        scl = {2, 2, 1},
    }
    sprite = Sprite {
        texture = "cathead.png",
        pos = {0, 0},
        parent = group,
    }
end
```

But you hardly notice the typo.
In addition, too many features.

Flower was reduced features.
I was easy to understand instead.

```Lua
-- Flower Code
module(..., package.seeall)

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)
    
    group = flower.Group(layer)
    group:setColor(0.5, 0.5, 0.5, 1)
    group:setScl(2, 2, 1)

    image = flower.Image("cathead.png")
    image:setPos(0, 0)
    group:addChild(image)
end
```

## How to use

### Open the window
You must first open the window.
It also creates a scene in Flower.

```Lua
flower = require "flower"
flower.openWindow("Title", 320, 480)
flower.openScene("main_scene")
```

### Create a Scene
You implement the code to control the scene.
The following sources are defined as a scene controller.

```Lua
-- main_scene.lua
module(..., package.seeall)

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)

    image = flower.Image("cathead.png")
    image:setLayer(layer)
end
```

The scene controller can define the following event handler.
Called events are registered automatically when you define the function.

* onCreate ... Called when generating the scene
* onOpen ... Called when you open the scene
* onClose ... Called at the close of the scene
* onStart ... Called at the start of the scene
* onStop ... Called at the stop of the scene
* onUpdate ... Called at the update of the scene

### Scene transition
Transition between scenes can be done very easily.

```Lua
-- main_scene.lua
module(..., package.seeall)

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)
    layer:setTouchEnabled(true)

    image = flower.Image("cathead.png")
    image:setLayer(layer)
    image:addEventListener("touchDown", image_OnTouchDown)
end

function image_OnTouchDown(e)
    flower.gotoScene("title_scene", {animation = "fade"})
    --flower.openScene("title_scene", {animation = "fade"})
end
```

```Lua
-- title_scene.lua
module(..., package.seeall)

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)

    label = flower.Label("Hello world!", 200, 30)
    label:setLayer(layer)
end
```

In the code above, the transition to "title_scene" When you touch the image.
In addition, you can define an animation of the scene transitions.
The animation can specify the following parameters.

* "change" ... Switch scenes immediately
* "overlay" ... Displayed over the scene
* "fade" ... The scene in order to fade
* "crossFade" ... The scene fades in parallel
* "popIn" ... Pop-in animation
* "popOut" ... Pop-out animation
* "slideLeft" ... Slide animation
* "slideRight" ... Slide animation
* "slideTop" ... Slide animation
* "slideBottom" ... Slide animation
* custom function ... You can specify a function that defines the scene

### Layer
Scene is composed of multiple layers.
After you create a scene, create a layer.

```Lua
module(..., package.seeall)

function onCreate(e)
    mainLayer = flower.Layer()
    mainLayer:setScene(scene)

    guiLayer = flower.Layer()
    guiLayer:setScene(scene)
end
```

Flower layer is the class of the extension MOAILayer.
Therefore, you can use all the features of Moai.

Set the size of the Viewport automatically optimal.


### Images
The Image is a class that extends MOAIProp.


```Lua
module(..., package.seeall)

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)
    
    image = flower.Image("image.png")
    image:setLayer(layer) -- layer:insertProp(image)
end
```

The texture is automatically cached.
Therefore, the efficiency that I may not particularly care.

If there are no more references to the texture, the resource is automatically released.

Following classes can be used.

* Image ... Displays the simple texture.
* SheetImage ... Display a texture sheet or tile images.
* MapImage ... Inherit the SheetImage. This class displays a grid.
* MovieClip ... Inherit the SheetImage. Sheet animation is possible.
* NineImage ... Displays the NinePatch of Android.

### Label
Label to display the text.
Inherit the MOAITextBox.

```Lua
module(..., package.seeall)

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)
    
    label = flower.Label("Hello world!", 200, 30)
    label:setLayer(layer)
end
```

Also cache Font.
Are devised so that the highest performance.

### Event
Events like Flash can be used.

```Lua
module(..., package.seeall)

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)
    
    image = flower.Image("image.png")
    image:setLayer(layer)
    image:addEventListener("message", onMessage)
    
    image:dispatchEvent("message", "Hello world!")
end

function onMessage(e)
	print(e.data)
end
```

You can also catch a touch event.

```Lua
module(..., package.seeall)

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)
    layer:setTouchEnabled(true)
    
    image = flower.Image("image.png")
    image:setLayer(layer)
    image:addEventListener("touchDown", onTouch)
    image:addEventListener("touchMove", onTouch)
    image:addEventListener("touchUp", onTouch)
    image:addEventListener("touchCancel", onTouch)
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
local class = flower.class

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

In addition, to reduce the switching of the texture.
For example, you can use only one piece of tile map images.
