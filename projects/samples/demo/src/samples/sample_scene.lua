module(..., package.seeall)

--------------------------------------------------------------------------------
-- Requires
--------------------------------------------------------------------------------

local FpsMonitor = require "hp/util/FpsMonitor"

--------------------------------------------------------------------------------
-- Constraints
--------------------------------------------------------------------------------

local LIST_ROW_HEIGHT = 50
local MENU_BAR_HEIGHT = 50

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

local sceneItems = {
    -- display
    {text = "sprite",           scene = "samples/display/sprite_sample",        animation = "slideToTop"},
    {text = "spritesheet",      scene = "samples/display/spritesheet_sample",   animation = "slideToBottom"},
    {text = "display",          scene = "samples/display/display_sample",       animation = "slideToTop"},
    {text = "mapsprite",        scene = "samples/display/mapsprite_sample",     animation = "slideToLeft"},
    {text = "text",             scene = "samples/display/text_sample",          animation = "slideToRight"},
    {text = "ninepatch",        scene = "samples/display/ninepatch_sample",     animation = "fade"},
    {text = "group",            scene = "samples/display/group_sample",         animation = "fade"},
    {text = "graphics1",        scene = "samples/display/graphics1_sample",     animation = "changeNow"},
    {text = "graphics2",        scene = "samples/display/graphics2_sample",     animation = "fade"},
    {text = "graphics3",        scene = "samples/display/graphics3_sample",     animation = "fade"},
    {text = "input",            scene = "samples/display/input_sample",         animation = "crossFade"},
    {text = "animation",        scene = "samples/display/animation_sample",     animation = "fade"},
    {text = "scene",            scene = "samples/display/scene_sample",         animation = "popIn"},
    {text = "moai",             scene = "samples/display/moai_sample"},
    {text = "hittest",          scene = "samples/display/hittest_sample",       animation = "fade"},
    {text = "drag",             scene = "samples/display/drag_sample",          animation = "fade"},
    {text = "drag2",            scene = "samples/display/drag2_sample",         animation = "fade"},
    {text = "mesh",             scene = "samples/display/mesh_sample",          animation = "fade"},
    {text = "particles",        scene = "samples/display/particles_sample",     animation = "fade"},

    -- manager
    {text = "scenemanager",     scene = "samples/manager/scenemanager_sample"},
    {text = "scenemanager3",    scene = "samples/manager/scenemanager3_sample"},

    -- sound
    {text = "sound1",           scene = "samples/sound/sound1_sample",          animation = "fade"},

    -- physics
    {text = "physics1",         scene = "samples/physics/physics1_sample",      animation = "fade"},

    -- tmx
    {text = "tiledmap",         scene = "samples/tmx/tiledmap_sample",          animation = "fade"},

    -- rpg
    {text = "rpgmap",           scene = "samples/rpg/rpgmap_sample",            animation = "fade"},

    -- gui
    {text = "button",           scene = "samples/gui/button_sample",            animation = "fade"},
    {text = "joystick",         scene = "samples/gui/joystick_sample",          animation = "fade"},
    {text = "panel",            scene = "samples/gui/panel_sample",          animation = "fade"},
}

local selectedItem = nil

--------------------------------------------------------------------------------
-- Create Scene
--------------------------------------------------------------------------------
function onCreate(params)
    createMainLayer()
    createMenuLayer()
    
    FpsMonitor(10):play()
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onTouchDown(e)
    -- Menu Bar touch
    if helpMenuItem:hitTestScreen(e.x, e.y) then
        onHelpMenuClick(helpMenuItem)
        return
    end
    if exitMenuItem:hitTestScreen(e.x, e.y) then
        onExitMenuClick(exitMenu)
        return
    end
    
    -- List Menu touch
    local worldX, worldY, worldZ = mainLayer:wndToWorld(e.x, e.y, 0)
    local touchProp = mainLayer:getPartition():propForPoint ( worldX, worldY )
    if touchProp and touchProp.background then
        selectedItem = touchProp
        drawItemSelectedColor(selectedItem.background)
    end
end

function onTouchUp(e)
    if selectedItem then
        local userdata = selectedItem.userdata
        drawItemDefaultColor(selectedItem.background)
        SceneManager:openScene(userdata.scene, {animation = userdata.animation})
        selectedItem = nil
    end
end

function onTouchMove(e)
    if e.tapCount > 1 then
        return
    end
    scrollToPositionFromCamera(-e.moveY)
    
    if selectedItem and selectedItem.background then
        drawItemDefaultColor(selectedItem.background)
        selectedItem = nil
    end
end

function onHelpMenuClick(item)
    SceneManager:openScene("samples/help_scene")
end

function onExitMenuClick(item)
    os.exit()
end

--------------------------------------------------------------------------------
-- Create Main Layer
--------------------------------------------------------------------------------

function createMainLayer()
    mainLayer = Layer {
        scene = scene,
        size = {Application.screenWidth, Application.screenHeight - MENU_BAR_HEIGHT}
    }
    mainLayer:createCamera(true, 1, -1)
    mainLayer.listTotalHeight = 0
    for i, item in ipairs(sceneItems) do
        local row = createListRow(item)
        row:setPos(0, (i - 1) * LIST_ROW_HEIGHT)
        mainLayer.listTotalHeight = mainLayer.listTotalHeight + LIST_ROW_HEIGHT
    end
end

function createListRow(item)
    local group = Group {
        layer = mainLayer,
        children = {{
            drawItemDefaultColor(Graphics {
                name = "background",
                size = {mainLayer:getViewWidth(), LIST_ROW_HEIGHT},
                pos = {0, 0},
            }),
            TextLabel {
                name = "label",
                text = item.text,
                size = {mainLayer:getViewWidth(), LIST_ROW_HEIGHT},
                pos = {0, 0},
                color = {0, 0, 0, 1},
                alignment = {MOAITextBox.LEFT_JUSTIFY, MOAITextBox.CENTER_JUSTIFY},
            },
        }},
    }
    local background = group:getChildByName("background")
    local label = group:getChildByName("label")
    label.background = background
    label.userdata = item
    
    return group
end

--------------------------------------------------------------------------------
-- Create Menu Layer
--------------------------------------------------------------------------------

function createMenuLayer()
    menuLayer = Layer {
        scene = scene,
        size = {Application.screenWidth, MENU_BAR_HEIGHT},
        pos = {0, mainLayer:getBottom()}
    }
    createMenuBar()
end

function createMenuBar()
    menuBar = Group { layer = menuLayer, size = {menuLayer:getViewSize()}}
    
    helpMenuItem = createMenuItem(menuBar, "Help", 1)
    exitMenuItem = createMenuItem(menuBar, "Exit", 2)
end

function createMenuItem(menuBar, text, index)
    local menuItemWidth = menuLayer:getViewWidth() / 2
    local menuItemHeight = menuLayer:getViewHeight()
    
    local menuItem = Group {
        size = {menuItemWidth, menuItemHeight},
        pos = {menuItemWidth * (index - 1), 0},
        children = {{
            Graphics ({
                name = text,
                pos = {0, 0},
                size = {menuItemWidth, menuItemHeight},
            }):setPenColor(0.8, 0.8, 0.9, 1):fillRect():setPenColor(0.5, 0.5, 0.5, 1):drawRect(1, 1, menuItemWidth, menuItemHeight),

            TextLabel {
                text = text,
                pos = {0, 0},
                size = {menuItemWidth, menuItemHeight},
                color = {0, 0, 0, 1},
                alignment = {MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY},
            }
        }},
    }
    menuBar:addChild(menuItem)
    return menuItem
end

--------------------------------------------------------------------------------
-- Draw functions
--------------------------------------------------------------------------------

function drawItemDefaultColor(g)
    g:clear()
    g:setPenColor(1.0, 1.0, 0.9, 1):fillRect()
    g:setPenColor(0.5, 0.5, 0.5, 1):drawLine(0, 0, g:getWidth(), 0)
    return g
end

function drawItemSelectedColor(g)
    g:clear()
    g:setPenColor(0.5, 0.5, 1.0, 1):fillRect()
    g:setPenColor(0.5, 0.5, 0.5, 1):drawLine(0, 0, g:getWidth(), 0)
    return g
end

--------------------------------------------------------------------------------
-- Scroll Position
--------------------------------------------------------------------------------

function scrollToPositionFromCamera(scrollY)
    local x, y, z = mainLayer.camera:getLoc()
    local maxY = mainLayer.listTotalHeight - mainLayer:getViewHeight()

    y = y + scrollY
    y = math.max(0, y)
    y = math.min(maxY, y)
    
    mainLayer.camera:setLoc(x, y, z)
end
