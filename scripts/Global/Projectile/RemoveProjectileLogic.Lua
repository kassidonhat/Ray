
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
-- Remove Projectile Logic
--====================================
local function RemoveProjectileLocal(dataPassed)

	--protection, sometimes the hit detection script sends this event twice
	if not dataPassed.ProjectileObject then
		print("Projectile not found")
		return
	end
	
	local function CanWeRemoveTheProjectile(proj)
		proj:remove()
	end
	--deletes the object and script, if it exists
	--[[
	if pcall(CanWeRemoveTheProjectile,dataPassed.ProjectileObject) then
		dataPassed.ProjectileObject:remove()
	end]]
	pcall(CanWeRemoveTheProjectile,dataPassed.ProjectileObject)
	if not dataPassed.ProjectileObject then

		for i in pairs(dataPassed) do
			if string.find(tostring(dataPassed[i]), "ProjectileScript.Lua") then
				dataPassed.ProjectileObject:removeScript(dataPassed[i])

			end
		end
	end

end








--====================================================================================================================================================================================================
--  Event Handlers
--====================================================================================================================================================================================================
return {
	
    eventHandlers = {		
        RemoveProjectile = RemoveProjectileLocal
    }
	
}

