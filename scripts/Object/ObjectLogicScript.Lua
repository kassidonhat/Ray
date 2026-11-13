

--====================================================================================================================================================================================================
--  This Script Handles the hit detection for the projectile
--====================================================================================================================================================================================================
local self = require('openmw.self')
local core = require('openmw.core')
local nearby = require('openmw.nearby')
local async = require('openmw.async')
local util = require('openmw.util')
local RequireBuilder = require('scripts.Require.RequireBuilder')


--=============================================================================================================================================
-- Variables
--=============================================================================================================================================
local timer = 0
local FuncTable = {}
local projectileDataTable = {}





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
			
			FuncTable = RequireBuilder.RequireBuilder("ProjectileObject",projectileDataTable)

		end,
			
			
		--====================================
		-- ProjectileObject's brain essentially, it keeps track of how long it's been alive, when it needs to move,
		-- and if it hits someone. Sends global events accordingly.
		--====================================

		onUpdate = function(dt)
			--ticks the timer forward
			timer=timer+dt
			projectileDataTable["timer"] = timer
            for k, v in pairs(FuncTable) do
                projectileDataTable=v(projectileDataTable)
			end
	
		end
	}
}


