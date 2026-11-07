
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
			timer=timer+dt
			
			
			
			-- this is for safety
			if self:isValid() == false then return end
			

			
			--send the event to move the projectile forward, also sends the info to spawn the vfx
			if  timer >0.5 then
				projectileDataTable.ProjectilePostion = projectileDataTable.ProjectilePostion +  (projectileDataTable.DirectionPassed*20)
				core.sendGlobalEvent('MoveProjectile', projectileDataTable)				
				self:sendEvent('MoveProjectilePostionFunc', projectileDataTable)

				
			end


	
		end
	}
}


