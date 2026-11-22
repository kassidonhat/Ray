
--====================================================================================================================================================================================================
--  Imports
--====================================================================================================================================================================================================
local world = require('openmw.world')
local core = require('openmw.core')
local types = require('openmw.types')
local util = require('openmw.util')






--====================================================================================================================================
-- Spawn Projectile Logic
--====================================================================================================================================
local function SpawnProjectile(passedTable)
	--Here we make the projectile, add the script to it, and teleport it in front of the player
	local projectileObjectMade = world.createObject(passedTable.ProjectileObjectID)

	projectileObjectMade:addScript(passedTable.ScriptAddedToProjectile, passedTable)

	projectileObjectMade:teleport(passedTable.CurrentplayerCell, passedTable.ProjectilePostion)

end







--===============================================================================================================================================================================================================================================================================================================================================================
-- Remove Projectile Logic
--===============================================================================================================================================================================================================================================================================================================================================================

local function RemoveProjectile(passedTable)

	--protection, sometimes the hit detection script sends this event twice
	if not passedTable.ProjectileObject then
		print("Projectile not found")
		return
	end
	
	local function CanWeRemoveTheProjectile(proj)
		proj:remove()
	end
	--deletes the object and script, if it exists
	pcall(CanWeRemoveTheProjectile,passedTable.ProjectileObject)
	if not passedTable.ProjectileObject then

		for i in pairs(passedTable) do
			if string.find(tostring(passedTable[i]), "ProjectileScript.Lua") then
				passedTable.ProjectileObject:removeScript(passedTable[i])

			end
		end
	end

end






--====================================
-- Move Projectile Logic
--====================================
local function MoveProjectile(passedTable)

	--This string is how the game recoginizes what to delete with the vfx.remove function
	local SpellRemover = passedTable.ProjectileObject.id..'SpellRemover'	
	
	local function testTeleport(PassedDatap)
		--this moves the projectile forward, and teleports it to the new position, this is done in a pcall because if the projectile is removed before this function is called, it will error out and break the script
		PassedDatap.ProjectileObject:teleport(PassedDatap.ProjectileObject.cell,PassedDatap.ProjectilePostion)
	end
	local protectHolder = pcall(testTeleport,passedTable)
    

	--this all handles the removal of the last vfx position and the addition of the new vfx position
	local vfxPosit = passedTable.ProjectilePostion-util.vector3(0,0,100)
	local function removeTheVFX(vfxId)
		world.vfx.remove(vfxId)
	end
	if pcall(removeTheVFX,SpellRemover) then
		removeTheVFX(SpellRemover)
	end


	world.vfx.spawn(passedTable.projectileModel,vfxPosit,{ useAmbientLight = true, vfxId = SpellRemover})
end


return{
        MoveProjectile=MoveProjectile,
        SpawnProjectile=SpawnProjectile,
        RemoveProjectile=RemoveProjectile
}