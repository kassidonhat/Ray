
--====================================================================================================================================================================================================
--  This Script Spawns, Adds, and Removes The Projectile Object
--====================================================================================================================================================================================================




--====================================================================================================================================================================================================
--  Imports
--====================================================================================================================================================================================================
local world = require('openmw.world')
local core = require('openmw.core')
local types = require('openmw.types')
local util = require('openmw.util')




--====================================
-- Spawn Projectile Logic
--====================================
local function SpawnProjectileLocal(sentData)


	
	--Here we make the projectile, add the script to it, and teleport it in front of the player
	local projectileObjectMade = world.createObject(sentData.ProjectileObjectID)
	for i in pairs(sentData) do
		if string.find(tostring(sentData[i]), "ProjectileScript.Lua") then
			projectileObjectMade:addScript(sentData[i],sentData)
		end
	end
	-- projectileObjectMade:addScript('scripts/Object/ObjectLogicScript.Lua', sentData)

	projectileObjectMade:teleport(sentData.CurrentplayerCell, sentData.ProjectilePostion)
end




--====================================================================================================================================================================================================
--  Event Handlers
--====================================================================================================================================================================================================
return {
	
    eventHandlers = {		
        SpawnProjectile = SpawnProjectileLocal,
    }
	
}

