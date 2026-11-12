

--====================================================================================================================================================================================================
-- imports
--====================================================================================================================================================================================================
local self = require('openmw.self')
local core = require('openmw.core')
local nearby = require('openmw.nearby')
local async = require('openmw.async')
local util = require('openmw.util')






--=============================================================================================================================================
-- This is the callback for hit detection, we're using this because we have to use the async version of cast rendering ray.
-- We'd have to use onFrame for normal cast rendering ray, and onFrame broke the whole script
--=============================================================================================================================================





-- local function MoveProjectilePostionFuncLocal(passed)
-- 	if not PassedTable.HitDetectedSwitch then
-- 		projectileDataTable = passed
-- 	end
-- end




local function MoveProjectileForwardFunction(PassedTable)
    -- print("MoveProjectileForwardFunction called")
    -- this is for safety
    if self:isValid() == false then return {} end



    --send the event to move the projectile forward, also sends the info to spawn the vfx
    if  PassedTable.timer >0.5 then
        PassedTable.ProjectilePostion = PassedTable.ProjectilePostion +  (PassedTable.DirectionPassed*20)
        core.sendGlobalEvent('MoveProjectile', PassedTable)				
        -- self:sendEvent('MoveProjectilePostionFunc', PassedTable)
        
    end

    return PassedTable
end



local function hitDetectFunction(PassedTable)


    local function hitDetectAsync(targets)
        if self:isValid() == false then return {} end
        if PassedTable.HitDetectedSwitch then return PassedTable end
        if targets.hit then
            
            PassedTable.HitDetectedSwitch = true
            -- self:sendEvent('HitDetectFunc', projectileDataTable)
            
        end
        return PassedTable
    end

    if PassedTable.HitDetectedSwitch then return PassedTable end
    if self:isValid() == false then return {} end


    -- here is the hit detection, sort of, it's a rendering ray,
    -- which means it can hit anything and give a return.
    -- we have to do this if we wan't to incorporate area
    local adjustedRayPostition = PassedTable.ProjectilePostion+ util.vector3(0, 0, -100)
    local rayC = nearby.asyncCastRenderingRay(async:callback(hitDetectAsync),
        adjustedRayPostition,
        adjustedRayPostition+(PassedTable.DirectionPassed*20),
        {ignore = {self,PassedTable.CasterObject}})
    return PassedTable
end






--=============================================================================================================================================
-- This is the callback for hit detection, we're using this because we have to use the async version of cast rendering ray.
-- We'd have to use onFrame for normal cast rendering ray, and onFrame broke the whole script
--=============================================================================================================================================
local function AreaHitDetectFunction(PassedTable)
    if self:isValid() == false then return {} end
    if not PassedTable.HitDetectedSwitch then return PassedTable end

	-- Define bounding box
	local halfOfASideOfTheBoundingBox = PassedTable.SizeOfArea*(1/3.28084)*70
	local ProjectileminPos = PassedTable.ProjectilePostion + util.vector3(-halfOfASideOfTheBoundingBox, -halfOfASideOfTheBoundingBox, -halfOfASideOfTheBoundingBox)
	local ProjectilemaxPos = PassedTable.ProjectilePostion + util.vector3(halfOfASideOfTheBoundingBox, halfOfASideOfTheBoundingBox, halfOfASideOfTheBoundingBox)


	-- VFX and SFX
	PassedTable["ImpactVFXPostion"] = PassedTable.ProjectilePostion + util.vector3(0, 0, -halfOfASideOfTheBoundingBox)
	core.sendGlobalEvent('SpawnSpellArea', PassedTable)
	if PassedTable.AreaSoundLocal == nil then
		PassedTable.AreaSoundLocal = 'destruction area'
	end
	core.sound.playSound3d(PassedTable.AreaSoundLocal, self)

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
		   actormaxPos.z >= ProjectileminPos.z and actorminPos.z <= ProjectilemaxPos.z and k ~= PassedTable.CasterObject then
			--For each actor found in the area, fire the hit target event in the global script
			PassedTable["Target"] = k
			core.sendGlobalEvent('HitTargetWithSpell', PassedTable)
		end
	end
	
	-- Set the timer forward to end, we can despawn the projectile now that it has hit something
	PassedTable.EarlyRemovalTriggered = true
    return PassedTable

end


local function EarlyRemovalFunction(PassedTable)
    if self:isValid() == false then return {} end
    if PassedTable.EarlyRemovalTriggered then
	    PassedTable.timer = 4
    end
    return PassedTable
end


local function RemovalFunction(PassedTable)
        
    --Sends the event to remove the object if it's been around too long, and makes sure the movement logic doesn't try to run after removal
    if PassedTable.timer > PassedTable.maxTime or PassedTable.DirectionPassed == nil then
        core.sendGlobalEvent('RemoveProjectile', PassedTable)
    end
    
    -- this is for safety
    if self:isValid() == false then return {} end

    return PassedTable
end








return {MoveProjectileForwardFunction =MoveProjectileForwardFunction,
        hitDetectFunction = hitDetectFunction,
        AreaHitDetectFunction = AreaHitDetectFunction,
        EarlyRemovalFunction = EarlyRemovalFunction,
        RemovalFunction = RemovalFunction}













