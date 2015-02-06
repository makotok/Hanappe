----------------------------------------------------------------------------------------------------
-- Flower library is a lightweight library for Moai SDK.
-- https://github.com/makotok/Hanappe
--
-- MEMO:
-- English documentation has been updated.  Please contact github://Cloven with
-- issues, questions, or problems regarding the documentation.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- module
local flower = {}

-- flower lang classes
flower.table = require "flower.lang.table"
flower.math = require "flower.lang.math"
flower.class = require "flower.lang.class"

-- flower core classes
flower.Config = require "flower.core.Config"
flower.KeyCode = require "flower.core.KeyCode"
flower.Logger = require "flower.core.Logger"
flower.Executors = require "flower.core.Executors"
flower.Resources = require "flower.core.Resources"
flower.Devices = require "flower.core.Devices"
flower.ClassFactory = require "flower.core.ClassFactory"
flower.Event = require "flower.core.Event"
flower.EventListener = require "flower.core.EventListener"
flower.EventDispatcher = require "flower.core.EventDispatcher"
flower.Runtime = require "flower.core.Runtime"
flower.InputMgr = require "flower.core.InputMgr"
flower.RenderMgr = require "flower.core.RenderMgr"
flower.SceneMgr = require "flower.core.SceneMgr"
flower.DeckMgr = require "flower.core.DeckMgr"
flower.Window = require "flower.core.Window"
flower.DisplayObject = require "flower.core.DisplayObject"
flower.Group = require "flower.core.Group"
flower.Scene = require "flower.core.Scene"
flower.SceneAnimations = require "flower.core.SceneAnimations"
flower.Layer = require "flower.core.Layer"
flower.Viewport = require "flower.core.Viewport"
flower.Camera = require "flower.core.Camera"
flower.Image = require "flower.core.Image"
flower.SheetImage = require "flower.core.SheetImage"
flower.MapImage = require "flower.core.MapImage"
flower.MovieClip = require "flower.core.MovieClip"
flower.NineImage = require "flower.core.NineImage"
flower.Label = require "flower.core.Label"
flower.DrawableObject = require "flower.core.DrawableObject"
flower.DrawableRect = require "flower.core.DrawableRect"
flower.Graphics = require "flower.core.Graphics"
flower.Font = require "flower.core.Font"
flower.Texture = require "flower.core.Texture"
flower.TouchHandler = require "flower.core.TouchHandler"

-- flower util classes
flower.PropertyUtils = require "flower.util.PropertyUtils"
flower.DebugUtils = require "flower.util.DebugUtils"

-- compatibility
flower.Rect = flower.DrawableRect

----------------------------------------------------------------------------------------------------
-- Public variables
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
-- Public functions
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

return flower