
local M = {}
M.shaders = {}

M.SHADERS_DIRECTORY = "src/main/hp/shader/" -- TODO:Trying to do.
M.BASIC_COLOR_SHADER = "simpleColor"

function M.simpleColor()
    if MOAIGfxDevice.isProgrammable () then
    
        local shader = MOAIShader.new ()
        
        local file = assert(io.open ( M.SHADERS_DIRECTORY .. 'shader_simple.vsh', mode ))
        local vsh = file:read('*all')
        file:close()
        
        file = assert(io.open(M.SHADERS_DIRECTORY .. 'shader_simple.fsh', mode))
        local fsh = file:read('*all')
        file:close()
        
        shader:reserveUniforms(2)
        shader:declareUniform(1, 'transform', MOAIShader.UNIFORM_WORLD_VIEW_PROJ )
        shader:declareUniform(2, 'ucolor', MOAIShader.UNIFORM_PEN_COLOR )
        
        shader:setVertexAttribute ( 1, 'position' )
        shader:setVertexAttribute ( 2, 'color' )
        
        shader:load ( vsh, fsh )
        return shader
    end
end


function M.getShader(shaderName)
    if M.shaders[shaderName] then
        return M.shaders[shaderName]
    end
    local shader = M[shaderName](M)
    M.shaders[shaderName] = shader
    return shader
end

return M