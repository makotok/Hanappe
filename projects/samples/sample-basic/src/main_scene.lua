module(..., package.seeall)

local FpsMonitor = require("hp/util/FpsMonitor")

local sceneItems = {
    -- display
    {text = "sprite", scene = "samples/display/sprite_sample", animation = "slideToTop"},
    {text = "spritesheet", scene = "samples/display/spritesheet_sample", animation = "slideToBottom"},
    {text = "display", scene = "samples/display/display_sample", animation = "slideToTop"},
    {text = "mapsprite", scene = "samples/display/mapsprite_sample", animation = "slideToLeft"},
    {text = "text", scene = "samples/display/text_sample", animation = "slideToRight"},
    {text = "ninepatch", scene = "samples/display/ninepatch_sample", animation = "fade"},
    {text = "group", scene = "samples/display/group_sample", animation = "fade"},
    {text = "graphics1", scene = "samples/display/graphics1_sample", animation = "changeNow"},
    {text = "graphics2", scene = "samples/display/graphics2_sample", animation = "fade"},
    {text = "input", scene = "samples/display/input_sample", animation = "crossFade"},
    {text = "animation", scene = "samples/display/animation_sample", animation = "fade"},
    {text = "scene", scene = "samples/display/scene_sample", animation = "popIn"},
    {text = "moai", scene = "samples/display/moai_sample"},
    {text = "hittest", scene = "samples/display/hittest_sample", animation = "fade"},
    {text = "drag", scene = "samples/display/drag_sample", animation = "fade"},
    {text = "drag2", scene = "samples/display/drag2_sample", animation = "fade"},
    {text = "mesh", scene = "samples/display/mesh_sample", animation = "fade"},
    {text = "particles", scene = "samples/display/particles_sample", animation = "fade"},
    -- manager
    {text = "scenemanager", scene = "samples/manager/scenemanager_sample"},
    {text = "scenemanager3", scene = "samples/manager/scenemanager3_sample"},
    -- sound
    {text = "sound1", scene = "samples/sound/sound1_sample", animation = "fade"},
    -- physics
    {text = "physics1", scene = "samples/physics/physics1_sample", animation = "fade"},
    -- tmx
    {text = "tiledmap", scene = "samples/tmx/tiledmap_sample", animation = "fade"},
    -- rpg
    {text = "rpgmap", scene = "samples/rpg/rpgmap_sample", animation = "fade"},
    -- gui
    {text = "button", scene = "samples/gui/button_sample", animation = "fade"},
}

local selectedItem = nil

--------------------------------------------------------------------------------

function onCreate(params)
    mainLayer = Layer()
    mainLayer:setScene(scene)
    
    camera = MOAICamera.new()
    camera:setOrtho(true)
    camera:setNearPlane(1)
    camera:setFarPlane(-1)
    mainLayer:setCamera(camera)

    for i, item in ipairs(sceneItems) do
        local row = createListRow(item)
        row:setPos(0, (i - 1) * 50)
    end
    
    FpsMonitor(10):play()
end

--------------------------------------------------------------------------------
function onTouchDown(e)
    local worldX, worldY, worldZ = mainLayer:wndToWorld(e.x, e.y, 0)
    local touchProp = mainLayer:getPartition():propForPoint ( worldX, worldY )
    if touchProp and touchProp.sceneName then
        selectedItem = touchProp
        setItemSelectedColor(selectedItem.background)
    end
end

--------------------------------------------------------------------------------
function onTouchUp(e)
    if selectedItem then
        setItemDefaultColor(selectedItem.background)
        SceneManager:openScene(selectedItem.sceneName, {animation = selectedItem.sceneAnimation})
    end
end

--------------------------------------------------------------------------------
function onTouchMove(e)
    camera:addLoc(0, -e.moveY, 0)
    
    if selectedItem and selectedItem.background then
        setItemDefaultColor(selectedItem.background)
        selectedItem = nil
    end
end

--------------------------------------------------------------------------------
function createListRow(item)
    local graphics = Graphics {width = mainLayer:getViewWidth() + 1, height = 50}
    setItemDefaultColor(graphics)
    graphics:setPos(0, 0)
    
    local text = TextLabel {text = item.text, width = graphics:getWidth() - 1, height = 50}
    text:setPos(5, 0)
    text:setAlignment(MOAITextBox.LEFT_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
    text.sceneName = item.scene
    text.sceneAnimation = item.animation
    text.background = graphics
    text:setColor(0, 0, 0, 1)
    
    local group = Group {width = graphics:getWidth() - 1, height = 50}
    group:addChild(graphics)
    group:addChild(text)
    group:setLayer(mainLayer)
    
    return group
end

--------------------------------------------------------------------------------
function setItemDefaultColor(g)
    g:clear()
    g:setPenColor(1.0, 1.0, 0.9, 1):fillRect()
    g:setPenColor(0.5, 0.5, 0.5, 1):drawLine(0, 0, g:getWidth(), 0)
end

--------------------------------------------------------------------------------
function setItemSelectedColor(g)
    g:clear()
    g:setPenColor(0.5, 0.5, 1.0, 1):fillRect()
    g:setPenColor(0.5, 0.5, 0.5, 1):drawLine(0, 0, g:getWidth(), 0)
end
