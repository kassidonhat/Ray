
local util = require('openmw.util')
local camera = require('openmw.camera')
local self = require('openmw.self')



local function getPlayerDirection() 
    local directionOfCamera = camera.viewportToWorldVector(util.vector2(0.5,0.5))
    local StartingPositionAdjustmet = directionOfCamera*40
    local additionVector2 = directionOfCamera
    local pos = self.position + StartingPositionAdjustmet +util.vector3(0,0,200)

    local ReturnTable = {pos = pos, additionVector2 = additionVector2}

    return ReturnTable
end

return {getPlayerDirection = getPlayerDirection}