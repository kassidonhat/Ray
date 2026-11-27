local anim = require('openmw.animation')
local core = require('openmw.core')
local RayEffects = require('scripts.enums.RayEffectsList')
local types = require('openmw.types')
local self = require('openmw.self')
local storage = require('openmw.storage')
local async = require('openmw.async')




--========================================================================================================================================================================================================
--settings 
--========================================================================================================================================================================================================
local MOD_ID = "Ray"
local settingsKey = "SettingsPlayer" .. MOD_ID
local settings = storage.playerSection(settingsKey)

local Cost_SCALE = settings:get("CostScaleMultiplierForRays")
local function updateSCALE_FACTOR(_, key)
    if key == "CostScaleMultiplierForRays" then
        Cost_SCALE = settings:get("CostScaleMultiplierForRays")
		print(Cost_SCALE)
    end
end
settings:subscribe(async:callback(updateSCALE_FACTOR))



local FIRE_RATE = settings:get("FireRateForRays")
local function updateFIRE_RATE(_, key)
    if key == "FireRateForRays" then
        FIRE_RATE = settings:get("FireRateForRays")
		print(FIRE_RATE)
    end
end
settings:subscribe(async:callback(updateFIRE_RATE))


local AnimationReleaseT = settings:get("AnimationReleaseTiming")
local function updateAnimationReleaseTiming(_, key)
    if key == "AnimationReleaseTiming" then
        AnimationReleaseT = settings:get("AnimationReleaseTiming")
		print(AnimationReleaseT)
    end
end
settings:subscribe(async:callback(updateAnimationReleaseTiming))






--====================================================================================================
--this checks if the spell start firing
--====================================================================================================
local function RayAnimationCheck(passedTable)

    local function continueCheckDependency()
        if passedTable.ContinueCheck == false then 
            passedTable["BreakCheck"] = true
        return passedTable end
    end

    if passedTable == "DependencyInjection" then return continueCheckDependency,"continueCheckDependency" end
    

    passedTable["ContinueCheck"] = false
    local castState = anim.getCompletion(self, 'raycast')
    if castState == nil then
        castState = 0
    end

    if castState ~= 0 or anim.isPlaying(self, 'raycastloop') then
        if castState > passedTable.AnimationReleaseT or anim.isPlaying(self, 'raycastloop') then
            passedTable["ContinueCheck"] = true  
        end
    end

    return passedTable
end



--====================================================================================================
--this checks if the spell firing event needs to be sent again
--====================================================================================================
local function RayFireTheEventBasedOnFireRate(passedTable) 

    local function EventFire(passedTable)
        passedTable["EventScript"] = 'PlayerLogicScript'
        self:sendEvent('PlayerEventBulider', passedTable)
    end
    local EventFireAsync = async:registerTimerCallback('EventFire', EventFire)
    
    if anim.isPlaying(self, 'raycastloop') or anim.isPlaying(self, 'raycast') then
        async:newSimulationTimer(passedTable.FIRE_RATE, EventFireAsync, passedTable)
    end

    return passedTable
end







--====================================================================================================
--this handles the spell Parsing
--====================================================================================================
local function RaySpellParse(passedTable)


	
	
	-- Find the Spell
	local SpellID = passedTable.SelectedSpellID
	local SpellVar = core.magic.spells.records[SpellID]
	local FirstPassCheck = 0

	-- go through the effects and get all of the models we're going to use
	for key, effect in ipairs(SpellVar.effects) do
		if RayEffects[SpellVar.effects[key].id] and FirstPassCheck == 0 then
			
			-- these varibles are just nice for read-ability
			local effectsID = SpellVar.effects[key].id
			local effectHere = core.magic.effects.records[effectsID]
			
			-- spell assets
			passedTable["SizeOfArea"] = SpellVar.effects[key].area
			passedTable["AreaSoundLocal"] = core.magic.effects.records[effectsID].areaSound
			passedTable["projectileModel"] = types.Weapon.records[effectHere.bolt].model 
			passedTable["AreaModel"] = types.Static.records[effectHere.areaStatic].model
			passedTable["ParticleForVFX"] = core.magic.effects.records[effectsID].particle
            passedTable["ProjectileObjectID"] = 'emptymodelprojectile'
            passedTable["DamageObjectID"] = 'emptymodelprojectile'
            

            -- spell info 
            passedTable["CasterObject"] = self
            passedTable["maxTime"] = 3
            passedTable["SpellID"] = SpellID
            passedTable["SpellCost"] = SpellVar.cost
            passedTable["ScriptAddedToProjectile"] = "scripts/Object/ObjectLogicScript.Lua"

            -- add the mod settings
            passedTable.AnimationReleaseT = AnimationReleaseT
            passedTable.Cost_SCALE = Cost_SCALE
            passedTable.FIRE_RATE = FIRE_RATE


            -- script building instructions
            passedTable["#IndexPosition:1#ScriptType:PlayerLogicScript#ScriptPath:scripts.Require.RaySpecificFunctions#FunctionName:RayAnimationCheck#DependencyInjection#"] = "RayAnimationCheck"
            passedTable["#IndexPosition:2#ScriptType:PlayerLogicScript#ScriptPath:scripts.Require.BasicSpellFunctions#FunctionName:checkMagickaFunc#Dependencies:continueCheckDependency-1,Main-2#"] = "checkMagickaFunc"
            passedTable["#IndexPosition:3#ScriptType:PlayerLogicScript#ScriptPath:scripts.Require.BasicSpellFunctions#FunctionName:TakeMagickaFromPlayerLocal#Dependencies:continueCheckDependency-1,Main-2#"] = "TakeMagickaFromPlayerLocal"
            passedTable["#IndexPosition:4#ScriptType:PlayerLogicScript#ScriptPath:scripts.Require.CustomEffectFunctions#FunctionName:GetCustomEffectSchoolInSpell#Dependencies:continueCheckDependency-1,Main-2#"] = "GetCustomEffectSchoolInSpell"
            passedTable["#IndexPosition:5#ScriptType:PlayerLogicScript#ScriptPath:scripts.Require.BasicSpellFunctions#FunctionName:SpellCastSkillGain#Dependencies:continueCheckDependency-1,Main-2#"] = "SpellCastSkillGain"
            passedTable["#IndexPosition:6#ScriptType:PlayerLogicScript#ScriptPath:scripts.Require.BasicSpellFunctions#FunctionName:playParticleAnimation#Dependencies:continueCheckDependency-1,Main-2#"] = "playParticleAnimation"
            passedTable["#IndexPosition:7#ScriptType:PlayerLogicScript#ScriptPath:scripts.Require.BasicSpellFunctions#FunctionName:playSpellSound#Dependencies:continueCheckDependency-1,Main-2#"] = "playSpellSound"
            passedTable["#IndexPosition:8#ScriptType:PlayerLogicScript#ScriptPath:scripts.Require.BasicSpellFunctions#FunctionName:getPlayerDirection#Dependencies:continueCheckDependency-1,Main-2#"] = "getPlayerDirection"
            passedTable["#IndexPosition:9#ScriptType:PlayerLogicScript#ScriptPath:scripts.Require.BasicSpellFunctions#FunctionName:SendGlobalEventToSpawnProjectile#Dependencies:continueCheckDependency-1,Main-2#"] = "SendGlobalEventToSpawnProjectile"
            passedTable["#IndexPosition:10#ScriptType:PlayerLogicScript#ScriptPath:scripts.Require.RaySpecificFunctions#FunctionName:RayFireTheEventBasedOnFireRate#"] = "RayFireTheEventBasedOnFireRate"
            

            passedTable["#IndexPosition:1#ScriptType:ProjectileObject#ScriptPath:scripts.Require.BasicProjectileFunctions#FunctionName:MoveProjectileForwardFunction#"] = "MoveProjectileForwardFunction"
            passedTable["#IndexPosition:2#ScriptType:ProjectileObject#ScriptPath:scripts.Require.BasicProjectileFunctions#FunctionName:hitDetectFunction#"] = "hitDetectFunction"
            passedTable["#IndexPosition:3#ScriptType:ProjectileObject#ScriptPath:scripts.Require.BasicProjectileFunctions#FunctionName:AreaHitDetectFunction#"] = "AreaHitDetectFunction"
            passedTable["#IndexPosition:4#ScriptType:ProjectileObject#ScriptPath:scripts.Require.BasicProjectileFunctions#FunctionName:EarlyRemovalFunction#"] = "EarlyRemovalFunction"
            passedTable["#IndexPosition:5#ScriptType:ProjectileObject#ScriptPath:scripts.Require.BasicProjectileFunctions#FunctionName:RemovalFunction#"] = "RemovalFunction"

            passedTable["#IndexPosition:1#ScriptType:GlobalSpawnProjectile#ScriptPath:scripts.Require.GlobalProjectileFunctions#FunctionName:SpawnProjectile#"] = "SpawnProjectile"
            
            passedTable["#IndexPosition:1#ScriptType:GlobalMoveProjectile#ScriptPath:scripts.Require.GlobalProjectileFunctions#FunctionName:MoveProjectile#"] = "MoveProjectile"
            
            passedTable["#IndexPosition:1#ScriptType:GlobalRemoveProjectile#ScriptPath:scripts.Require.GlobalProjectileFunctions#FunctionName:RemoveProjectile#"] = "RemoveProjectile"


			-- We only grab the first one even though technically you could have two different ray effects.
			FirstPassCheck = 1

		end
		
        -- Get any additional ray spell effects on the spell
		if RayEffects[SpellVar.effects[key].id] then
			passedTable['CustomEffect'..SpellVar.effects[key].id] = SpellVar.effects[key].id
		end
		
	end

	return passedTable
end




return {RaySpellParse = RaySpellParse,
        RayAnimationCheck = RayAnimationCheck,
        RayFireTheEventBasedOnFireRate = RayFireTheEventBasedOnFireRate
    }