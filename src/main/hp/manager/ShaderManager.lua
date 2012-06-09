
local M = {}
M.shaders = {}

M.SHADERS_DIRECTORY = "src/main/hp/shader/" -- TODO:Trying to do.
M.BASIC_COLOR_SHADER = "simpleColor"

function M.simpleColor( self )
    if MOAIGfxDevice.isProgrammable () then
    
        local shader = MOAIShader.new ()
        
        local file = assert(io.open ( self.SHADERS_DIRECTORY .. 'shader_simple.vsh', mode ))
        local vsh = file:read('*all')
        file:close()
        
        file = assert(io.open(self.SHADERS_DIRECTORY .. 'shader_simple.fsh', mode))
        local fsh = file:read('*all')
        file:close()
        
        shader:reserveUniforms(2)
        shader:declareUniform(1, 'transform', MOAIShader.UNIFORM_WORLD_VIEW_PROJ )
        shader:declareUniform(2, 'maskColor', MOAIShader.UNIFORM_COLOR )
        
        shader:setVertexAttribute ( 1, 'position' )
        --shader:setVertexAttribute ( 2, 'uv' )
        shader:setVertexAttribute ( 2, 'color' )
        
        shader:load ( vsh, fsh )
        
        print("adding shader simple color")
        return shader
    end
end


function M:request(shaderName)
    --TODO:When you share, attr would be reflected in the other prop.
    --[[
    if self.shaders[shaderName] then
        return self.shaders[shaderName]
    end
    --]]
    local shader = self[shaderName]( self )
    self.shaders[shaderName] = shader
    return shader
end

return M