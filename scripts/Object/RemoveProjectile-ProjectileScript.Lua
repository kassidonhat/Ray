
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
local maxTime = 3
local projectileDataTable ={}

local function EarlyRemovalFuncLocal()
	timer = 4
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
			timer=timer+dt


			--Sends the event to remove the object if it's been around too long, and makes sure the movement logic doesn't try to run after removal
			if timer > maxTime or projectileDataTable.DirectionPassed == nil then
				core.sendGlobalEvent('RemoveProjectile', projectileDataTable)
				return
			end
			
			
			-- this is for safety
			if self:isValid() == false then return end
			

			
	
		end
	},
	
	eventHandlers = {
		EarlyRemovalFunc = EarlyRemovalFuncLocal
	}

	
}


