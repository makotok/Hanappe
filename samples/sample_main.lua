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

function onCreate(params)
    scrollView = ScrollView()
    scrollView:setScene(scene)
    
    for i, item in ipairs(sceneItems) do
        local graphics = Graphics:new({width = Application.screenWidth - 60, height = 50})
        graphics:setPenColor(0.5, 0.5, 0.5, 1):fillRect()
        graphics:setPenColor(1, 1, 1, 1):drawRect()
        graphics:setPos(0, 0)
        
        local text = TextLabel:new({text = item.text, width = graphics:getWidth(), height = 50})
        text:setPos(5, 0)
        text:setAlignment(MOAITextBox.LEFT_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
        text.sceneName = item.scene
        text.sceneAnimation = item.animation
        
        local group = Group:new({width = graphics:getWidth(), height = 50})
        group:addChild(graphics)
        group:addChild(text)
        group:setPos(30, (i - 1) * 50)
        
        scrollView:addChild(group)
    end
end

function onTouchDown(event)
    local worldX, worldY, worldZ = scrollView:wndToWorld(event.x, event.y, 0)
    local touchProp = scrollView.partition:propForPoint ( worldX, worldY )
    if touchProp and touchProp.sceneName then
        SceneManager:openScene(touchProp.sceneName, {animation = touchProp.sceneAnimation})
    end
end
