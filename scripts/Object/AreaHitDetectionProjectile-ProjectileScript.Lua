
--====================================================================================================================================================================================================
--  This Script Handles the hit detection for the projectile
--====================================================================================================================================================================================================
local self = require('openmw.self')
local core = require('openmw.core')
local nearby = require('openmw.nearby')
local async = require('openmw.async')
local util = require('openmw.util')

--=============================================================================================================================================
-- Variables
--=============================================================================================================================================
local projectileDataTable ={}








--=============================================================================================================================================
-- This is the callback for hit detection, we're using this because we have to use the async version of cast rendering ray.
-- We'd have to use onFrame for normal cast rendering ray, and onFrame broke the whole script
--=============================================================================================================================================
local function HitDetectFuncLocal(passed)


	-- Define bounding box
	local halfOfASideOfTheBoundingBox = passed.SizeOfArea*(1/3.28084)*70
	local ProjectileminPos = passed.ProjectilePostion + util.vector3(-halfOfASideOfTheBoundingBox, -halfOfASideOfTheBoundingBox, -halfOfASideOfTheBoundingBox)
	local ProjectilemaxPos = passed.ProjectilePostion + util.vector3(halfOfASideOfTheBoundingBox, halfOfASideOfTheBoundingBox, halfOfASideOfTheBoundingBox)


	-- VFX and SFX
	passed["ImpactVFXPostion"] = passed.ProjectilePostion + util.vector3(0, 0, -halfOfASideOfTheBoundingBox)
	core.sendGlobalEvent('SpawnSpellArea', passed)
	if passed.AreaSoundLocal == nil then
		passed.AreaSoundLocal = 'destruction area'
	end
	core.sound.playSound3d(passed.AreaSoundLocal, self)

	-- Get everyone in said bounding box
	local actorsInBox = {}
	ActorsNearby = nearby.actors
	for i,k in ipairs(ActorsNearby) do
		local actorpos = k.position
		local actorBox = k:getBoundingBox()
		local actorBoxCenter = actorBox.center
		local actorminPos = actorBoxCenter + util.vector3(-actorBox.halfSize.x, -actorBox.halfSize.y, -actorBox.halfSize.z)
		local actormaxPos = actorBoxCenter + util.vector3(actorBox.halfSize.x, actorBox.halfSize.y, actorBox.halfSize.z)


		if actormaxPos.x >= ProjectileminPos.x and actorminPos.x <= ProjectilemaxPos.x and
		   actormaxPos.y >= ProjectileminPos.y and actorminPos.y <= ProjectilemaxPos.y and
		   actormaxPos.z >= ProjectileminPos.z and actorminPos.z <= ProjectilemaxPos.z and k ~= passed.CasterObject then
			--For each actor found in the area, fire the hit target event in the global script
			passed["Target"] = k
			core.sendGlobalEvent('HitTargetWithSpell', passed)
		end
	end
	
	-- Set the timer forward to end, we can despawn the projectile now that it has hit something
	self:sendEvent('EarlyRemovalFunc')

end





--=============================================================================================================================================
-- Engine Handlers
--=============================================================================================================================================
return{
	

    engineHandlers = {
		
		--========================================================================
		-- Initial Data passed to the script on attachment to the projectile
		--========================================================================

		onInit = function(data)
			projectileDataTable = data
			projectileDataTable["ProjectileObject"] = self
		end,
	},
	
	eventHandlers = {
		HitDetectFunc = HitDetectFuncLocal
	}
}

