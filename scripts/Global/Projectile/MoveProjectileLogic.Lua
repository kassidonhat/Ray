
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



-- --====================================
-- -- Variables
-- --====================================
-- local projectileModel = nil
-- local ParticleForVFX = nil
-- local SpellID = nil






--====================================
-- Move Projectile Logic
--====================================
local function MoveProjectileLocal(PassedData)

	--This string is how the game recoginizes what to delete with the vfx.remove function
	local SpellRemover = PassedData.ProjectileObject.id..'SpellRemover'	
	
	--This moves the actual object itself
	PassedData.ProjectileObject:teleport(PassedData.ProjectileObject.cell,PassedData.ProjectilePostion)
	
	--this all handles the removal of the last vfx position and the addition of the new vfx position
	local vfxPosit = PassedData.ProjectilePostion-util.vector3(0,0,100)
	local function removeTheVFX(vfxId)
		world.vfx.remove(vfxId)
	end
	if pcall(removeTheVFX,SpellRemover) then
		removeTheVFX(SpellRemover)
	end


	world.vfx.spawn(PassedData.projectileModel,vfxPosit,{ useAmbientLight = true, vfxId = SpellRemover
																				--,particleTextureOverride = PassedData.ParticleForVFX
																				})
end


--====================================================================================================================================================================================================
--  Event Handlers
--====================================================================================================================================================================================================
return {
    eventHandlers = {
        MoveProjectile = MoveProjectileLocal
    }
	
}
