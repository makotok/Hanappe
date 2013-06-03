module(..., package.seeall)

--------------------------------------------------------------------------------
-- Requires
--------------------------------------------------------------------------------

local FpsMonitor = require "hp/util/FpsMonitor"
local Component = require "hp/gui/Component"

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
    {text = "touch",            scene = "samples/display/touch_sample",         animation = "fade"},
    {text = "animation",        scene = "samples/display/animation_sample",     animation = "fade"},
    {text = "scene",            scene = "samples/display/scene_sample",         animation = "popIn", backAnimation = "popOut"},
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
    {text = "tiledmap2",        scene = "samples/tmx/tiledmap2_sample",         animation = "fade"},
    {text = "tiledmap3",        scene = "samples/tmx/tiledmap3_sample",         animation = "fade"},
    {text = "rpgmap",           scene = "samples/rpg/rpgmap_sample",            animation = "fade"},
    {text = "button",           scene = "samples/gui/button_sample",            animation = "fade"},
    {text = "joystick",         scene = "samples/gui/joystick_sample",          animation = "fade"},
    {text = "panel",            scene = "samples/gui/panel_sample",             animation = "fade"},
    {text = "messagebox",       scene = "samples/gui/messagebox_sample",        animation = "fade"},
    {text = "scroller",         scene = "samples/gui/scroller_sample",          animation = "fade"},
    {text = "game1",            scene = "samples/game/game1_sample",            animation = "fade"},
}

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

local fpsMonitor = FpsMonitor(10)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(params)
    MOAISim.setHistogramEnabled(true)

    createBackgroundLayer()
    createGuiView()
    fpsMonitor:play()
end

function onButtonClick(e)
    MOAISim.forceGarbageCollection()
    MOAISim.reportHistogram()

    local target = e.target
    local item = target and target.item or nil
    selectedItem = item
    if item then
        local childScene = SceneManager:openScene(item.scene, {animation = item.animation})
        createBackButton(childScene)
    end
end

function onBackButtonClick(e)
    SceneManager:closeScene({animation = selectedItem.backAnimation or "slideToRight"})

    MOAISim.forceGarbageCollection()
    MOAISim.reportHistogram()
end

function onExitButtonClick(e)
    os.exit(0)
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
        hBounceEnabled = false,
        layout = VBoxLayout {
            align = {"center", "center"},
            padding = {10, 10, 10, 10},
            gap = {10, 10},
        },
    }
    
    titleLabel = TextLabel {
        text = "Hanappe Samples",
        size = {guiView:getWidth(), 50},
        color = {0, 0, 0},
        parent = scroller,
        align = {"center", "center"},
    }

    exitButton = Button {
        text = "Exit",
        size = {100, 50},
        parent = scroller,
        onClick = onExitButtonClick,
    }
    
    for i, item in ipairs(SCENE_ITEMS) do
        local button = createButton(item.text, scroller)
        button.item = item
    end
    
end

function createButton(text, parent)
    local button = Button {
        text = text,
        size = {200, 50},
        parent = parent,
        onClick = onButtonClick,
    }
    return button
end

function createBackButton(parentScene)
    local view = View {
        scene = parentScene,
    }
    local button = Button {
        text = "Back",
        alpha = 0.8,
        size = {100, 50},
        parent = view,
        onClick = onBackButtonClick,
    }
    button:setRight(view:getWidth())
    return button
end
