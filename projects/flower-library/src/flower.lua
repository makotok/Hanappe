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
-- English documentation has been updated.  Please contact github://Cloven with
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
-- @return Font instance
function flower.getFont(path, charcodes, points, dpi)
    return flower.Resources.getFont(path, charcodes, points, dpi)
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
-- @see flower.lang.class
flower.class = require "flower.lang.class"

---
-- table.
-- @see flower.lang.class
flower.table = require "flower.lang.table"

---
-- math.
-- @see flower.lang.class
flower.math = require "flower.lang.math"

---
-- Config class.
-- @see flower.core.Config
flower.Config = require "flower.core.Config"

---
-- KeyCode class.
-- @see flower.core.KeyCode
flower.KeyCode = require "flower.core.KeyCode"

---
-- Logger class.
-- @see flower.core.Logger
flower.Logger = require "flower.core.Logger"

---
-- Executors class.
-- @see flower.core.Executors
flower.Executors = require "flower.core.Executors"

---
-- Resources class.
-- @see flower.core.Resources
flower.Resources = require "flower.core.Resources"

---
-- Devices class.
-- @see flower.core.Devices
flower.Devices = require "flower.core.Devices"

---
-- ClassFactory class.
-- @see flower.core.ClassFactory
flower.ClassFactory = require "flower.core.ClassFactory"

---
-- Event class.
-- @see flower.core.Event
flower.Event = require "flower.core.Event"

---
-- EventListener class.
-- @see flower.core.EventListener
flower.EventListener = require "flower.core.EventListener"

---
-- EventDispatcher class.
-- @see flower.core.EventDispatcher
flower.EventDispatcher = require "flower.core.EventDispatcher"

---
-- Runtime class.
-- @see flower.core.Runtime
flower.Runtime = require "flower.core.Runtime"

---
-- InputMgr class.
-- @see flower.core.InputMgr
flower.InputMgr = require "flower.core.InputMgr"

---
-- RenderMgr class.
-- @see flower.core.RenderMgr
flower.RenderMgr = require "flower.core.RenderMgr"

---
-- SceneMgr class.
-- @see flower.core.SceneMgr
flower.SceneMgr = require "flower.core.SceneMgr"

---
-- DeckMgr class.
-- @see flower.core.DeckMgr
flower.DeckMgr = require "flower.core.DeckMgr"

---
-- Animation class.
-- @see flower.core.Animation
flower.Animation = require "flower.core.Animation"

---
-- Window class.
-- @see flower.core.Window
flower.Window = require "flower.core.Window"

---
-- DisplayObject class.
-- @see flower.core.DisplayObject
flower.DisplayObject = require "flower.core.DisplayObject"

---
-- Group class.
-- @see flower.core.Group
flower.Group = require "flower.core.Group"

---
-- Scene class.
-- @see flower.core.Scene
flower.Scene = require "flower.core.Scene"

---
-- SceneAnimations class.
-- @see flower.core.SceneAnimations
flower.SceneAnimations = require "flower.core.SceneAnimations"

---
-- Layer class.
-- @see flower.core.Layer
flower.Layer = require "flower.core.Layer"

---
-- Viewport class.
-- @see flower.core.Viewport
flower.Viewport = require "flower.core.Viewport"

---
-- Camera class.
-- @see flower.core.Camera
flower.Camera = require "flower.core.Camera"

---
-- Image class.
-- @see flower.core.Image
flower.Image = require "flower.core.Image"

---
-- SheetImage class.
-- @see flower.core.SheetImage
flower.SheetImage = require "flower.core.SheetImage"

---
-- MapImage class.
-- @see flower.core.MapImage
flower.MapImage = require "flower.core.MapImage"

---
-- MovieClip class.
-- @see flower.core.MovieClip
flower.MovieClip = require "flower.core.MovieClip"

---
-- NineImage class.
-- @see flower.core.NineImage
flower.NineImage = require "flower.core.NineImage"

---
-- Label class.
-- @see flower.core.Label
flower.Label = require "flower.core.Label"

---
-- DrawableObject class.
-- @see flower.core.DrawableObject
flower.DrawableObject = require "flower.core.DrawableObject"

---
-- DrawableRect class.
-- @see flower.core.DrawableRect
flower.DrawableRect = require "flower.core.DrawableRect"

---
-- Rect class.
-- @see flower.core.DrawableRect
flower.Rect = flower.DrawableRect

---
-- Graphics class.
-- @see flower.core.Graphics
flower.Graphics = require "flower.core.Graphics"

---
-- Particle class.
-- @see flower.core.Particle
flower.Particle = require "flower.core.Particle"

---
-- Font class.
-- @see flower.core.Font
flower.Font = require "flower.core.Font"

---
-- Texture class.
-- @see flower.core.Texture
flower.Texture = require "flower.core.Texture"

---
-- TouchHandler class.
-- @see flower.core.TouchHandler
flower.TouchHandler = require "flower.core.TouchHandler"

---
-- Interceptor class.
-- @see flower.core.Interceptor
flower.Interceptor = require "flower.core.Interceptor"

---
-- PropertyUtils class.
-- @see flower.util.PropertyUtils
flower.PropertyUtils = require "flower.util.PropertyUtils"

---
-- DebugUtils class.
-- @see flower.util.DebugUtils
flower.DebugUtils = require "flower.util.DebugUtils"

return flower