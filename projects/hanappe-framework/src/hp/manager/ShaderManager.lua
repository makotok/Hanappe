----------------------------------------------------------------
-- This is a class to manage the Shader. <br>
-- This source has been implemented by Nenad Katic. <br>
-- Has been partially modified. <br>
----------------------------------------------------------------

local ResourceManager = require("hp/manager/ResourceManager")

local M = {}
M.shaders = {}

M.BASIC_COLOR_SHADER = "simpleColor"

local function getFileData(filename)
    return ResourceManager:readFile(filename)
end

function M:simpleColor()
    if not MOAIGfxDevice.isProgrammable () then
        return
    end

    local shader = MOAIShader.new ()
    local vsh = getFileData("hp/shader/shader_simple.vsh")
    local fsh = getFileData("hp/shader/shader_simple.fsh")
        
    if MOAIShaderProgram then
        -- V1.6
        local program = MOAIShaderProgram.new ()
        program:setVertexAttribute ( 1, 'position' )
        program:setVertexAttribute ( 2, 'color' )

        program:reserveUniforms(2)
        program:declareUniform(1, 'transform', MOAIShaderProgram.UNIFORM_MATRIX_F4 )
        program:declareUniform(2, 'ucolor', MOAIShaderProgram.UNIFORM_VECTOR_F4 )

        program:reserveGlobals(2)
        program:setGlobal(1, 1, MOAIShaderProgram.GLOBAL_WORLD_VIEW_PROJ )
        program:setGlobal(2, 2, MOAIShaderProgram.GLOBAL_PEN_COLOR )
        
        program:load ( vsh, fsh )

        shader:setProgram(program)
    else
        -- V1.5
        shader:setVertexAttribute ( 1, 'position' )
        shader:setVertexAttribute ( 2, 'color' )        
        shader:reserveUniforms(2)
        shader:declareUniform(1, 'transform', MOAIShader.UNIFORM_WORLD_VIEW_PROJ )
        shader:declareUniform(2, 'ucolor', MOAIShader.UNIFORM_PEN_COLOR )
        shader:load ( vsh, fsh )
    end

    return shader
end


function M:getShader(shaderName)
    if self.shaders[shaderName] then
        return self.shaders[shaderName]
    end
    local shader = self[shaderName](self)
    self.shaders[shaderName] = shader
    return shader
end

return M