module(..., package.seeall)

local sceneItems = {
    {text = "graphics", scene = "samples/graphics_sample"},
    {text = "group", scene = "samples/group_sample"},
    {text = "input", scene = "samples/input_sample"},
    {text = "sprite", scene = "samples/sprite_sample"},
    {text = "spritesheet", scene = "samples/spritesheet_sample"},
    {text = "mapsprite", scene = "samples/mapsprite_sample"},
    {text = "text", scene = "samples/text_sample"},
    {text = "animation", scene = "samples/animation_sample"},
    {text = "scene", scene = "samples/scene_sample"},
    {text = "moai", scene = "samples/moai_sample"},
    {text = "tiledmap", scene = "samples/tiledmap_sample"},
}

function onCreate(params)
    layer = Layer:new({scene = scene})
    partition = MOAIPartition.new()
    layer:setPartition(partition)
    
    for i, item in ipairs(sceneItems) do
        local graphics = Graphics:new({width = Application.screenWidth + 1, height = 30, layer = layer})
        graphics:setPenColor(0.5, 0.5, 0.5, 1):fillRect()
        graphics:setPenColor(1, 1, 1, 1):drawRect()
        graphics:setLeft(0)
        graphics:setTop(0)
        
        local text = TextLabel:new({text = item.text, width = Application.screenWidth, height = 30, layer = layer})
        text.sceneName = item.scene
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
    local touchProp = partition:propForPoint ( worldX, worldY )
    if touchProp and touchProp.sceneName then
        SceneManager:openScene(touchProp.sceneName, {animation = "fade"})
    end
end
