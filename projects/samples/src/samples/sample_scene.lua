module(..., package.seeall)

--------------------------------------------------------------------------------
-- Requires
--------------------------------------------------------------------------------

local FpsMonitor = require "hp/util/FpsMonitor"

--------------------------------------------------------------------------------
-- Constraints
--------------------------------------------------------------------------------

local SCENE_ITEMS = {
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
    {text = "moai",             scene = "samples/display/moai_sample",          animation = nil},
    {text = "hittest",          scene = "samples/display/hittest_sample",       animation = "slideToLeft"},
    {text = "drag1",            scene = "samples/display/drag1_sample",         animation = "slideToLeft"},
    {text = "drag2",            scene = "samples/display/drag2_sample",         animation = "fade"},
    {text = "mesh",             scene = "samples/display/mesh_sample",          animation = "fade"},
    {text = "particles",        scene = "samples/display/particles_sample",     animation = "fade"},
    {text = "scenemanager",     scene = "samples/manager/scenemanager_sample",  animation = "fade"},
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

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

local fpsMonitor = FpsMonitor(10)

--------------------------------------------------------------------------------
-- Create Scene
--------------------------------------------------------------------------------
function onCreate(params)
    createBackgroundLayer()
    createGuiView()
    fpsMonitor:play()
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onButtonClick(e)
    local target = e.target
    local item = target and target.item or nil
    if item then
        SceneManager:openScene(item.scene, {animation = item.animation})
    end
end

--------------------------------------------------------------------------------
-- Create Layer
--------------------------------------------------------------------------------

function createBackgroundLayer()
    backgroundLayer = Layer {}
    
    backgroundSprite = BackgroundSprite {
        texture = "background.png",
        layer = backgroundLayer,
    }
    
    SceneManager:addBackgroundLayer(backgroundLayer)
end

function createGuiView()
    guiView = View {
        scene = scene,
    }
    
    scroller = Scroller {
        parent = guiView,
    }
    
    titleLabel = TextLabel {
        text = "Hanappe Samples",
        size = {guiView:getWidth(), 50},
        textSize = 32,
        color = {0, 0, 0},
        align = {"center", "center"},
        parent = scroller,
    }
    
    local HALF_WIDTH = guiView:getWidth() / 2
    for i, item in ipairs(SCENE_ITEMS) do
        local button = createButton(item, scroller)
        button:setPos((HALF_WIDTH - button:getWidth()) / 2 + ((i - 1) % 2 * HALF_WIDTH), 70 + math.floor((i - 1) / 2) * 60)
    end
end

function createButton(item, parent)
    local button = Button {
        text = item.text,
        size = {200, 50},
        parent = scroller,
        onClick = onButtonClick,
    }
    button.item = item
    return button
end
