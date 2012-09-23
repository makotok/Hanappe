module(..., package.seeall)

--------------------------------------------------------------------------------
-- Requires
--------------------------------------------------------------------------------

local FpsMonitor = require "hp/util/FpsMonitor"

--------------------------------------------------------------------------------
-- Constraints
--------------------------------------------------------------------------------

local LIST_ROW_HEIGHT = 50

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

local sceneItems = {
    {text = "sprite",           scene = "samples/display/sprite_sample",        animation = "slideToTop"},
    {text = "spritesheet",      scene = "samples/display/spritesheet_sample",   animation = "slideToBottom"},
    {text = "display",          scene = "samples/display/display_sample",       animation = "slideToTop"},
    {text = "mapsprite",        scene = "samples/display/mapsprite_sample",     animation = "slideToLeft"},
    {text = "text",             scene = "samples/display/text_sample",          animation = "slideToRight"},
    {text = "ninepatch",        scene = "samples/display/ninepatch_sample",     animation = "fade"},
    {text = "group",            scene = "samples/display/group_sample",         animation = "fade"},
    {text = "graphics1",        scene = "samples/display/graphics1_sample",     animation = "changeNow"},
    {text = "graphics2",        scene = "samples/display/graphics2_sample",     animation = "fade"},
    {text = "input",            scene = "samples/display/input_sample",         animation = "crossFade"},
    {text = "animation",        scene = "samples/display/animation_sample",     animation = "fade"},
    {text = "scene",            scene = "samples/display/scene_sample",         animation = "popIn"},
    {text = "moai",             scene = "samples/display/moai_sample"},
    {text = "hittest",          scene = "samples/display/hittest_sample",       animation = "fade"},
    {text = "drag1",            scene = "samples/display/drag1_sample",         animation = "fade"},
    {text = "drag2",            scene = "samples/display/drag2_sample",         animation = "fade"},
    {text = "mesh",             scene = "samples/display/mesh_sample",          animation = "fade"},
    {text = "particles",        scene = "samples/display/particles_sample",     animation = "fade"},
    {text = "scenemanager",     scene = "samples/manager/scenemanager_sample"},
    {text = "scenemanager3",    scene = "samples/manager/scenemanager3_sample"},
    {text = "sound1",           scene = "samples/sound/sound1_sample",          animation = "fade"},
    {text = "physics1",         scene = "samples/physics/physics1_sample",      animation = "fade"},
    {text = "tiledmap",         scene = "samples/tmx/tiledmap_sample",          animation = "fade"},
    {text = "rpgmap",           scene = "samples/rpg/rpgmap_sample",            animation = "fade"},
    {text = "button",           scene = "samples/gui/button_sample",            animation = "fade"},
    {text = "joystick",         scene = "samples/gui/joystick_sample",          animation = "fade"},
    {text = "panel",            scene = "samples/gui/panel_sample",             animation = "fade"},
    {text = "messagebox",       scene = "samples/gui/messagebox_sample",        animation = "fade"},
    {text = "scroller",         scene = "samples/gui/scroller_sample",          animation = "fade"},
}

local selectedItem = nil

--------------------------------------------------------------------------------
-- Create Scene
--------------------------------------------------------------------------------
function onCreate(params)
    createListView()
    
    FpsMonitor(10):play()
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onTouchDown(e)
    -- List Menu touch
    local layer = listView:getLayer()
    local worldX, worldY, worldZ = layer:wndToWorld(e.x, e.y, 0)
    local touchProp = layer:getPartition():propForPoint ( worldX, worldY )
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
    if selectedItem and selectedItem.background then
        drawItemDefaultColor(selectedItem.background)
        selectedItem = nil
    end
end

--------------------------------------------------------------------------------
-- Create Main Layer
--------------------------------------------------------------------------------

function createListView()
    listView = View {
        scene = scene,
        priorityUpdateEnabled = false,
    }
    scroller = Scroller {
        parent = listView,
    }
    
    for i, item in ipairs(sceneItems) do
        local row = createListRow(item)
        scroller:addChild(row)
        row:setPos(0, (i - 1) * LIST_ROW_HEIGHT)
    end
end

function createListRow(item)
    local group = Group {
        size = {listView:getWidth(), LIST_ROW_HEIGHT},
    }
    
    local background = Graphics {
        size = {group:getWidth(), LIST_ROW_HEIGHT},
        pos = {0, 0},
        priority = 1,
    }
    drawItemDefaultColor(background)
    
    local label = TextLabel {
        text = item.text,
        size = {group:getWidth(), LIST_ROW_HEIGHT},
        pos = {0, 0},
        color = {0, 0, 0, 1},
        alignment = {MOAITextBox.LEFT_JUSTIFY, MOAITextBox.CENTER_JUSTIFY},
        userdata = item,
        priority = 2,
    }
    label.background = background
    label.userdata = item

    group:addChild(background)
    group:addChild(label)
    
    return group
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
