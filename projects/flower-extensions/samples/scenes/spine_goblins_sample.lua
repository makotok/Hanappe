module(..., package.seeall)

local goblin, goblinGirl
local timer1, timer2

function onCreate()
    local layer = flower.Layer()
    layer:setScene(scene)

    layer:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)

    goblin = spine.Skeleton("goblins/goblins.json", "goblins/goblins.atlas", 0.5, -0.5)
    goblin:setLayer(layer)
    goblin:setLoc(60, 300)
    goblin:setSkin('goblin')
    goblin:playAnim('walk', true)

    goblinGirl = spine.Skeleton("goblins/goblins.json", "goblins/goblins.atlas", 0.5, -0.5)
    goblinGirl:setLayer(layer)
    goblinGirl:setLoc(240, 300)
    goblinGirl:setSkin('goblingirl')
    goblinGirl:setScl(-1, 1)
    goblinGirl:playAnim('walk', true)

    local skins = {'goblin', 'goblingirl'}
    
    local i = 1
    timer1 = flower.Executors.callLoopTime(3, function() 
        goblin:setSkin(skins[1 + i % 2])
        i = i + 1
    end)

    local j = 0
    timer2 = flower.Executors.callLoopTime(1.2, function() 
        goblinGirl:setSkin(skins[1 + j % 2])
        j = j + 1
    end)

end

-- Stop all actions and animations to prevent memory leaks
function onClose(e)
    goblin:stopAnim()
    goblinGirl:stopAnim()
    timer1:stop()
    timer2:stop()
end