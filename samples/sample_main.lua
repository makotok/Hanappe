module(..., package.seeall)

local sceneItems = {
    {text = "graphics", scene = "samples/graphics_sample", animation = "changeNow"},
    {text = "group", scene = "samples/group_sample", animation = "fade"},
    {text = "input", scene = "samples/input_sample", animation = "crossFade"},
    {text = "sprite", scene = "samples/sprite_sample", animation = "slideToTop"},
    {text = "spritesheet", scene = "samples/spritesheet_sample", animation = "slideToBottom"},
    {text = "mapsprite", scene = "samples/mapsprite_sample", animation = "slideToLeft"},
    {text = "text", scene = "samples/text_sample", animation = "slideToRight"},
    {text = "animation", scene = "samples/animation_sample", animation = "fade"},
    {text = "ninepatch", scene = "samples/ninepatch_sample", animation = "fade"},
    {text = "scene", scene = "samples/scene_sample", animation = "popIn"},
    {text = "moai", scene = "samples/moai_sample"},
    {text = "joystick", scene = "samples/stick_sample"},
    {text = "button", scene = "samples/button_sample", animation = "fade"},
    {text = "panel", scene = "samples/panel_sample", animation = "fade"},
    {text = "scrollview", scene = "samples/scrollview_sample", animation = "fade"},
    {text = "tiledmap", scene = "samples/tiledmap_sample", animation = "fade"},
    {text = "rpgmap", scene = "samples/rpgmap_sample", animation = "fade"},
}

local selectedItem = nil

function onCreate(params)
    -- TODO:そのうちListViewに入れ替わる
    scrollView = ScrollView()
    scrollView:setScene(scene)
    
    for i, item in ipairs(sceneItems) do
        local graphics = Graphics:new({width = Application.screenWidth + 1, height = 50})
        setItemDefaultColor(graphics)
        graphics:setPos(0, 0)
        
        local text = TextLabel:new({text = item.text, width = graphics:getWidth() - 1, height = 50})
        text:setPos(5, 0)
        text:setAlignment(MOAITextBox.LEFT_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
        text.sceneName = item.scene
        text.sceneAnimation = item.animation
        text.background = graphics
        text:setColor(0, 0, 0, 1)
        
        local group = Group:new({width = graphics:getWidth() - 1, height = 50})
        group:addChild(graphics)
        group:addChild(text)
        group:setPos(0, (i - 1) * 50)
        
        scrollView:addChild(group)
    end
end

function onTouchDown(event)
    local worldX, worldY, worldZ = scrollView:wndToWorld(event.x, event.y, 0)
    local touchProp = scrollView.partition:propForPoint ( worldX, worldY )
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
