module(..., package.seeall)

local sceneItems = {
    -- display
    {text = "graphics", scene = "samples/display/graphics_sample", animation = "changeNow"},
    {text = "group", scene = "samples/display/group_sample", animation = "fade"},
    {text = "input", scene = "samples/display/input_sample", animation = "crossFade"},
    {text = "sprite", scene = "samples/display/sprite_sample", animation = "slideToTop"},
    {text = "spritesheet", scene = "samples/display/spritesheet_sample", animation = "slideToBottom"},
    {text = "mapsprite", scene = "samples/display/mapsprite_sample", animation = "slideToLeft"},
    {text = "text", scene = "samples/display/text_sample", animation = "slideToRight"},
    {text = "animation", scene = "samples/display/animation_sample", animation = "fade"},
    {text = "ninepatch", scene = "samples/display/ninepatch_sample", animation = "fade"},
    {text = "scene", scene = "samples/display/scene_sample", animation = "popIn"},
    {text = "moai", scene = "samples/display/moai_sample"},
    {text = "hittest", scene = "samples/display/hittest_sample", animation = "fade"},
    {text = "drag", scene = "samples/display/drag_sample", animation = "fade"},
    {text = "drag2", scene = "samples/display/drag2_sample", animation = "fade"},
    {text = "mesh", scene = "samples/display/mesh_sample", animation = "fade"},
    -- manager
    {text = "scenemanager", scene = "samples/manager/scenemanager_sample"},

    -- widget
    {text = "joystick", scene = "samples/widget/stick_sample"},
    {text = "button", scene = "samples/widget/button_sample", animation = "fade"},
    {text = "radiobutton", scene = "samples/widget/radiobutton_sample", animation = "fade"},
    {text = "panel", scene = "samples/widget/panel_sample", animation = "fade"},
    {text = "messagebox", scene = "samples/widget/messagebox_sample", animation = "fade"},
    {text = "messagebox2", scene = "samples/widget/messagebox2_sample", animation = "fade"},
    {text = "scrollview", scene = "samples/widget/scrollview_sample", animation = "fade"},
    {text = "textview", scene = "samples/widget/textview_sample", animation = "fade"},

    -- physics
    {text = "physics1", scene = "samples/physics/physics1_sample", animation = "fade"},

    -- tmx
    {text = "tiledmap", scene = "samples/tmx/tiledmap_sample", animation = "fade"},
    -- rpg
    {text = "rpgmap", scene = "samples/rpg/rpgmap_sample", animation = "fade"},
}

local selectedItem = nil

function onCreate(params)
    -- TODO:そのうちListViewに入れ替わる
    scrollView = ScrollView()
    scrollView:setScene(scene)
    --scrollView:setScreenSize(300, 300)
    --scrollView:setViewSize(300, 300)
    --scrollView:setPos(10, 10)
    
    for i, item in ipairs(sceneItems) do
        local graphics = Graphics({width = Application.viewWidth + 1, height = 50})
        setItemDefaultColor(graphics)
        graphics:setPos(0, 0)
        
        local text = TextLabel({text = item.text, width = graphics:getWidth() - 1, height = 50})
        text:setPos(5, 0)
        text:setAlignment(MOAITextBox.LEFT_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
        text.sceneName = item.scene
        text.sceneAnimation = item.animation
        text.background = graphics
        text:setColor(0, 0, 0, 1)
        
        local group = Group({width = graphics:getWidth() - 1, height = 50})
        group:addChild(graphics)
        group:addChild(text)
        group:setPos(0, (i - 1) * 50)
        
        scrollView:addChild(group)
    end
end

function onTouchDown(event)
    local worldX, worldY, worldZ = scrollView:wndToWorld(event.x, event.y, 0)
    local touchProp = scrollView:getPartition():propForPoint ( worldX, worldY )
    if touchProp and touchProp.sceneName then
        selectedItem = touchProp
        setItemSelectedColor(selectedItem.background)
    end
end

function onTouchUp(event)
    if selectedItem then
        setItemDefaultColor(selectedItem.background)
        SceneManager:openScene(selectedItem.sceneName, {animation = selectedItem.sceneAnimation})
    end
end

function onTouchMove(event)
    if not selectedItem then
        return
    end
    
    if selectedItem.background then
        setItemDefaultColor(selectedItem.background)
    end
    selectedItem = nil
    
end

function setItemDefaultColor(g)
    g:clear()
    g:setPenColor(1.0, 1.0, 0.9, 1):fillRect()
    g:setPenColor(0.5, 0.5, 0.5, 1):drawRect()
end

function setItemSelectedColor(g)
    g:clear()
    g:setPenColor(0.5, 0.5, 1.0, 1):fillRect()
    g:setPenColor(0.5, 0.5, 0.5, 1):drawRect()
end
