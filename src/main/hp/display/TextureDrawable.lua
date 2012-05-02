local TextureManager = require("hp/manager/TextureManager")

--------------------------------------------------------------------------------
-- テクスチャを描画するオブジェクトが実装するモジュールです.<br>
-- このモジュール単体では使用できません.<br>
-- self.deckが存在する必要があります.<br>
-- @class table
-- @name TextureDrawable
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Textureをdeckに設定します.
-- @param texture path
--------------------------------------------------------------------------------
function M:setTexture(texture)
    assert(texture, "texture nil value!")
    
    if type(texture) == "string" then
        texture = TextureManager:request(texture)
    end
    self.texture = texture
    self.deck:setTexture(texture)
end

return M