# Flower Library

## Introduction
Flower is a simple, lightweight library for MoaiSDK.

http://getmoai.com/

## Open window
Open a window in the same way Flower.
It also creates a scene in Flower.

```Lua
flower = require "flower"
flower.openWindow("Flower samples", 320, 480)
flower.openScene("main_scene")
```

## Creating a Scene
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

## Scene transition
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

## Layer
Coming soon.

## Images
Coming soon.

## Label
Coming soon.

## Class Inheritance
Coming soon.

## Performance
Coming soon.
