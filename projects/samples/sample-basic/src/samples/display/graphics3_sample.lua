module(..., package.seeall)

function onCreate(params)
    layer = Layer {scene = scene}
    
    background = Graphics {
        size = {layer:getViewSize()}, pos = {0, 0}, layer = layer,
    }
    background:setPenColor(1, 1, 1, 1):fillRect()

    panel = Sprite {
        texture = "skins/panel-background.png", size = {300, 200}, pos = {10, 10}, layer = layer,
    }
    
    border = NinePatch {
        texture = "skins/panel-border.png", size = {300, 200}, pos = {10, 10}, layer = layer,
    }
    
    labelBack = Graphics {
        size = {290, 20}, pos = {15, 15}, layer = layer,
    }
    labelBack:setPenColor(1, 1, 1, 0.5):fillRect()
    
    label1 = TextLabel {
        text = "リスト1", textSize = 16, size = {100, 20}, pos = {15, 15}, color = {0.8, 0.8, 0.8, 1}, layer = layer,
    }

    GUI.View {
        scene = scene,
        children = {{
            GUI.Button {
                size = {200, 50},
                text = "スタート",
                pos = {15, 15}
            },
        
        }},
    
    }
end

function onStart()
end

function onTouchDown()
    SceneManager:closeScene({animation = "fade"})
end