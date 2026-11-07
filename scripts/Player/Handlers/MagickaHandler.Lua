local self = require('openmw.self')
local types = require('openmw.types')

--[[]]

--=======================
--  Variable
--=======================
local sparemagicka = 0



--=======================
--  Function
--=======================
local function TakeMagickaFromPlayerLocal(Passed)

    if Passed.CostScale ~= nil then
        Cost_SCALE = Passed.CostScale
    else
        Cost_SCALE = 1
    end

    local magickaCost = (Passed.cost or 1) * Cost_SCALE


    --if the cost is less then 1 put it in our spare magic bucket, we'll subtract it when we get 1 whole magicka
    if magickaCost < 1 then
        sparemagicka = sparemagicka + magickaCost
    end
        
    if magickaCost >= 1 then
        -- Round the result for subtraction 
        local magickaCostInteger =math.floor(magickaCost)
        -- Reduce caster magicka
        types.Actor.stats.dynamic.magicka(self).current = types.Actor.stats.dynamic.magicka(self).current - magickaCostInteger
        -- Grab the magicka we rounded off and put in the bucket as well
        sparemagicka = sparemagicka+magickaCost-magickaCostInteger
    end

    --check the bucket, if it has enough, send it
    if sparemagicka >= 1 then
        types.Actor.stats.dynamic.magicka(self).current = types.Actor.stats.dynamic.magicka(self).current - 1
        sparemagicka = sparemagicka-1
    end
    
    return true
end



--====================================================================================================================================================================================================
--  Event Handler
--====================================================================================================================================================================================================
return{

	eventHandlers = {
    TakeMagickaFromPlayer = TakeMagickaFromPlayerLocal
	}
	
}--[[]]