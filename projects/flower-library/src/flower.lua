----------------------------------------------------------------------------------------------------
-- Flower library is a lightweight library for Moai SDK.
--
-- <h4>See:</h4>
-- <ul>
--   <li><a href="https://github.com/makotok/Hanappe">Hanappe</a><l/i>
-- </ul>
--
-- <h4>Memo:</h4>
-- <p>
-- English documentation has been updated.
-- Please contact github://Cloven with
-- issues, questions, or problems regarding the documentation.
-- </p>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- module
local flower = {}

----------------------------------------------------------------------------------------------------
-- Fields
----------------------------------------------------------------------------------------------------

--- Default viewport.
flower.viewport = nil

--- Width of Window.
flower.screenWidth = nil

--- Height of Window.
flower.screenHeight = nil

--- Width of default viewport.
flower.viewWidth = nil

--- Height of default viewport.
flower.viewHeight = nil

--- Scale of default viewport.
flower.viewScale = nil

----------------------------------------------------------------------------------------------------
-- Functions
----------------------------------------------------------------------------------------------------

---
-- Open the window.
-- Initializes the library.
-- @param title (Option)Title of the window
-- @param width (Option)Width of the window
-- @param height (Option)Height of the window
-- @param scale (Option)Scale of the Viewport to the Screen
function flower.openWindow(title, width, height, scale)
    flower.Window:openWindow(title, width, height, scale)

    flower.screenWidth = flower.Window.width
    flower.screenHeight = flower.Window.height
    flower.viewport = flower.Viewport.getDefaultViewport()
    flower.viewWidth = flower.viewport.viewWidth
    flower.viewHeight = flower.viewport.viewHeight
    flower.viewScale = flower.viewport.viewScale

    flower.viewport:addEventListener(flower.Event.RESIZE, function(e)
        flower.screenWidth = e.width
        flower.screenHeight = e.height
        flower.viewWidth = e.viewWidth
        flower.viewHeight = e.viewHeight
        flower.viewScale = e.viewScale
    end)

end

---
-- Set the size of the assumed device.
function flower.setDefaultWindowSize(targetDevice, landscape, scaleMode)
    flower.Window:setDefaultWindowSize(targetDevice, landscape, scaleMode)
end

---
-- Returns whether the mobile execution environment.
-- @return True in the case of mobile.
function flower.isMobile()
    return flower.Runtime.isMobile()
end

---
-- Returns whether the desktop execution environment.
-- @return True in the case of desktop.
function flower.isDesktop()
    return flower.Runtime.isDesktop()
end

---
-- Returns the size of the screen.
-- @return width, height
function flower.getScreenSize()
    return flower.screenWidth, flower.screenHeight
end

---
-- Returns the size of the viewport.
-- @return width, height
function flower.getViewSize()
    return flower.viewWidth, flower.viewHeight
end

---
-- Returns the Viewport to be used in layers.
-- If you change the Viewport, it affects all layers.
-- @return width, height
function flower.getViewport()
    return flower.viewport
end

---
-- Returns the texture.
-- Textures are cached.
-- @param path The path of the texture
-- @param filter Texture filter.
-- @return Texture instance
function flower.getTexture(path, filter)
    return flower.Resources.getTexture(path, filter)
end

---
-- Returns the font.
-- Fonts are cached.
-- @param path The path of the font.
-- @param charcodes (option)Charcodes of the font
-- @param points (option)Points of the font
-- @param dpi (option)Dpi of the font
-- @param filter (option)Filter of the font
-- @return Font instance
function flower.getFont(path, charcodes, points, dpi, filter)
    return flower.Resources.getFont(path, charcodes, points, dpi, filter)
end

---
-- Opens the scene.  This is a convenience function.
-- Delegate to SceneMgr.
-- @param sceneName module name of the Scene
-- @param params (option)Parameters of the Scene
function flower.openScene(sceneName, params)
    return flower.SceneMgr:openScene(sceneName, params)
end

---
-- Goto the Scene.  This is a convenience function.
-- Delegate to SceneMgr.
-- @param sceneName module name of the Scene
-- @param params (option)Parameters of the Scene
function flower.gotoScene(sceneName, params)
    return flower.SceneMgr:gotoScene(sceneName, params)
end

---
-- Close the Scene.  This is a convenience function.
-- Delegate to SceneMgr.
-- @param params (option)Parameters of the Scene
function flower.closeScene(params)
    return flower.SceneMgr:closeScene(params)
end

---
-- Executes a function in a MOAICoroutine.
-- This variant of the function family will run the func immediately
-- upon the next coroutine.yield().
-- @param func function object
-- @param ... (option)function arguments
function flower.callOnce(func, ...)
    return flower.Executors.callOnce(func, ...)
end

----------------------------------------------------------------------------------------------------
-- Classes
-- @section Classes
----------------------------------------------------------------------------------------------------

---
-- class.
-- @see flower.class
flower.class = require "flower.class"

---
-- table.
-- @see flower.table
flower.table = require "flower.table"

---
-- math.
-- @see flower.math
flower.math = require "flower.math"

---
-- Config class.
-- @see flower.Config
flower.Config = require "flower.Config"

---
-- KeyCode class.
-- @see flower.KeyCode
flower.KeyCode = require "flower.KeyCode"

---
-- Logger class.
-- @see flower.Logger
flower.Logger = require "flower.Logger"

---
-- Executors class.
-- @see flower.Executors
flower.Executors = require "flower.Executors"

---
-- Resources class.
-- @see flower.Resources
flower.Resources = require "flower.Resources"

---
-- Devices class.
-- @see flower.Devices
flower.Devices = require "flower.Devices"

---
-- ClassFactory class.
-- @see flower.ClassFactory
flower.ClassFactory = require "flower.ClassFactory"

---
-- Event class.
-- @see flower.Event
flower.Event = require "flower.Event"

---
-- EventListener class.
-- @see flower.EventListener
flower.EventListener = require "flower.EventListener"

---
-- EventDispatcher class.
-- @see flower.EventDispatcher
flower.EventDispatcher = require "flower.EventDispatcher"

---
-- Runtime class.
-- @see flower.Runtime
flower.Runtime = require "flower.Runtime"

---
-- InputMgr class.
-- @see flower.InputMgr
flower.InputMgr = require "flower.InputMgr"

---
-- RenderMgr class.
-- @see flower.RenderMgr
flower.RenderMgr = require "flower.RenderMgr"

---
-- SceneMgr class.
-- @see flower.SceneMgr
flower.SceneMgr = require "flower.SceneMgr"

---
-- DeckMgr class.
-- @see flower.DeckMgr
flower.DeckMgr = require "flower.DeckMgr"

---
-- Animation class.
-- @see flower.Animation
flower.Animation = require "flower.Animation"

---
-- Window class.
-- @see flower.Window
flower.Window = require "flower.Window"

---
-- DisplayObject class.
-- @see flower.DisplayObject
flower.DisplayObject = require "flower.DisplayObject"

---
-- Group class.
-- @see flower.Group
flower.Group = require "flower.Group"

---
-- Scene class.
-- @see flower.Scene
flower.Scene = require "flower.Scene"

---
-- SceneAnimations class.
-- @see flower.SceneAnimations
flower.SceneAnimations = require "flower.SceneAnimations"

---
-- Layer class.
-- @see flower.Layer
flower.Layer = require "flower.Layer"

---
-- Viewport class.
-- @see flower.Viewport
flower.Viewport = require "flower.Viewport"

---
-- Camera class.
-- @see flower.Camera
flower.Camera = require "flower.Camera"

---
-- Image class.
-- @see flower.Image
flower.Image = require "flower.Image"

---
-- SheetImage class.
-- @see flower.SheetImage
flower.SheetImage = require "flower.SheetImage"

---
-- MapImage class.
-- @see flower.MapImage
flower.MapImage = require "flower.MapImage"

---
-- MovieClip class.
-- @see flower.MovieClip
flower.MovieClip = require "flower.MovieClip"

---
-- NineImage class.
-- @see flower.NineImage
flower.NineImage = require "flower.NineImage"

---
-- Label class.
-- @see flower.Label
flower.Label = require "flower.Label"

---
-- DrawableObject class.
-- @see flower.DrawableObject
flower.DrawableObject = require "flower.DrawableObject"

---
-- DrawableRect class.
-- @see flower.DrawableRect
flower.DrawableRect = require "flower.DrawableRect"

---
-- Rect class.
-- @see flower.DrawableRect
flower.Rect = flower.DrawableRect

---
-- Graphics class.
-- @see flower.Graphics
flower.Graphics = require "flower.Graphics"

---
-- Particle class.
-- @see flower.Particle
flower.Particle = require "flower.Particle"

---
-- Font class.
-- @see flower.Font
flower.Font = require "flower.Font"

---
-- Texture class.
-- @see flower.Texture
flower.Texture = require "flower.Texture"

---
-- TouchHandler class.
-- @see flower.TouchHandler
flower.TouchHandler = require "flower.TouchHandler"

---
-- Interceptor class.
-- @see flower.Interceptor
flower.Interceptor = require "flower.Interceptor"

---
-- PropertyUtils class.
-- @see flower.PropertyUtils
flower.PropertyUtils = require "flower.PropertyUtils"

---
-- DebugUtils class.
-- @see flower.DebugUtils
flower.DebugUtils = require "flower.DebugUtils"

---
-- BitUtils class.
-- @see flower.BitUtils
flower.BitUtils = require "flower.BitUtils"

return flower