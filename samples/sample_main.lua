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
    {text = "scene", scene = "samples/scene_sample", animation = "popIn"},
    {text = "moai", scene = "samples/moai_sample"},
    {text = "joystick", scene = "samples/stick_sample"},
    {text = "tiledmap", scene = "samples/tiledmap_sample", animation = "fade"},
    {text = "rpgmap", scene = "samples/rpgmap_sample", animation = "fade"},
}

function onCreate(params)
    layer = Layer:new({scene = scene})
    
    for i, item in ipairs(sceneItems) do
        local graphics = Graphics:new({width = Application.screenWidth + 1, height = 30, layer = layer})
        graphics:setPenColor(0.5, 0.5, 0.5, 1):fillRect()
        graphics:setPenColor(1, 1, 1, 1):drawRect()
        graphics:setLeft(0)
        graphics:setTop(0)
        
        local text = TextLabel:new({text = item.text, width = Application.screenWidth, height = 30, layer = layer})
        text.sceneName = item.scene
        text.sceneAnimation = item.animation
        text:setLeft(5)
        text:setTop(0)
        
        local group = Group:new({width = Application.screenWidth, height = 30})
        group:addChild(graphics)
        group:addChild(text)
        group:setLeft(0)
        group:setTop((i - 1) * 30)
    end
end

function onTouchDown(event)
    local worldX, worldY, worldZ = layer:wndToWorld(event.x, event.y, 0)
    local touchProp = layer.partition:propForPoint ( worldX, worldY )
    if touchProp and touchProp.sceneName then
        SceneManager:openScene(touchProp.sceneName, {animation = touchProp.sceneAnimation})
    end
end
