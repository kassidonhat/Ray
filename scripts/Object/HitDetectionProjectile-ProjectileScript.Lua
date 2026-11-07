
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
local timer = 0
local projectileDataTable ={}
local HitDetectedSwitch = false








--=============================================================================================================================================
-- This is the callback for hit detection, we're using this because we have to use the async version of cast rendering ray.
-- We'd have to use onFrame for normal cast rendering ray, and onFrame broke the whole script
--=============================================================================================================================================
local function hitDetect(targets)

	if HitDetectedSwitch then return end
	if targets.hit then
		


		HitDetectedSwitch = true
		self:sendEvent('HitDetectFunc', projectileDataTable)


	end
end





local function ControlledReleaseFuncLocal()

	if HitDetectedSwitch then return end
	

	HitDetectedSwitch = true
	self:sendEvent('HitDetectFunc', projectileDataTable)


end






local function MoveProjectilePostionFuncLocal(passed)
	if not HitDetectedSwitch then
		projectileDataTable = passed
	end
end





--=============================================================================================================================================
-- Engine Handlers
--=============================================================================================================================================
return{
	

    engineHandlers = {
		
		--====================================
		-- Initial Data passed to the script on attachment to the projectile
		--====================================

		onInit = function(data)
			projectileDataTable = data
			projectileDataTable["ProjectileObject"] = self

			
		end,
			
			
		--====================================
		-- ProjectileObject's brain essentially, it keeps track of how long it's been alive, when it needs to move,
		-- and if it hits someone. Sends global events accordingly.
		--====================================

		onUpdate = function(dt)
			--ticks the timer forward
			if HitDetectedSwitch then return end
			if self:isValid() == false then return end

			timer=timer+dt



			-- here is the hit detection, sort of, it's a rendering ray, which means it can hit anything and give a return.
			-- we have to do this if we wan't to incorporate area
			local adjustedRayPostition = projectileDataTable.ProjectilePostion+ util.vector3(0, 0, -100)
			local rayC = nearby.asyncCastRenderingRay(async:callback(hitDetect),
				adjustedRayPostition,
				adjustedRayPostition+(projectileDataTable.DirectionPassed*20),
				{ignore = {self,projectileDataTable.CasterObject}})
	
		end
	},
	
	eventHandlers = {
		MoveProjectilePostionFunc = MoveProjectilePostionFuncLocal,
		ControlledReleaseFunc = ControlledReleaseFuncLocal
	}
}


