
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
local FuncTable = {}





local function PlayerEventBulider(passedTable)
    FuncTable = RequireBuilder.RequireBuilder(passedTable.EventScript,passedTable)
    passedTable["EventScript"] = nil


    for k, v in pairs(FuncTable) do
        passedTable=v(passedTable)
    end

end








--=============================================================================================================================================
-- Engine Handlers
--=============================================================================================================================================
return{
	
    eventHandlers = {
		PlayerEventBulider = PlayerEventBulider
    }
	
}
