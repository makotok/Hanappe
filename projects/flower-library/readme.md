# Flower Library

## Introduction
Flower is a simple, lightweight library for MoaiSDK.

http://getmoai.com/

## SDK Version
I have been tested on the following versions.

* Moai SDK Version 1.3 (Build 160)

## Tools Version
Tool version being used by the Flower is as follows.

* Lua Development Tools 0.9 (http://www.eclipse.org/koneki/ldt/)
* Apache Ant version 1.8.2 (http://ant.apache.org/)
* LDoc version 1.3.3 (https://github.com/stevedonovan/LDoc)

## Test environment
The terminal work as follows.
I want you to tell me if there is a terminal that worked also.

* Mac OSX 10.8.2
* Windows 7
* Android 4.1 (Nexus 7)

## Starting window
In MoaiSDK, start by creating a first window and viewport.

```Lua
MOAISim.openWindow("window tile", 320, 480)

viewport = MOAIViewport.new()
viewport:setSize(320, 480)
viewport:setScale(320, 480)
```

Create a window in the same way Flower.
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
