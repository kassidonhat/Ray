local self = require('openmw.self')
local types = require('openmw.types')


--=======================
--  Variable
--=======================
local spareHealing = 0


--=======================
--  Function
--=======================
local function ApplyHealingToTargetActorLocal(Passed)
	--if the cost is less then 1 put it in our spare magic bucket, we'll subtract it when we get 1 whole Healing
	if Passed.Healing < 1 then
		spareHealing = spareHealing + Passed.Healing
	end
		
	
	if Passed.Healing >= 1 then
		-- Round the result for subtraction 
		local HealingInteger =math.floor(Passed.Healing)
		-- Reduce target health
		types.Actor.stats.dynamic.health(self).current = types.Actor.stats.dynamic.health(self).current+HealingInteger
		-- Grab the Healing we rounded off and put in the bucket as well
		spareHealing = spareHealing+Passed.Healing-HealingInteger
	end
	
	--check the bucket, if it has enough, send it
	if spareHealing >= 1 then
		types.Actor.stats.dynamic.health(self).current = types.Actor.stats.dynamic.health(self).current + 1
		spareHealing = spareHealing-1
	end
	
end


--====================================================================================================================================================================================================
--  Event Handler
--====================================================================================================================================================================================================
return{

	eventHandlers = {
    ApplyHealingToTargetActor = ApplyHealingToTargetActorLocal
	}
	
}