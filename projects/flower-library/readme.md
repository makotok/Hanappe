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
