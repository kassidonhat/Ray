local SkillProgression = require('openmw.interfaces').SkillProgression
local types = require('openmw.types')
local core = require('openmw.core')
local self = require('openmw.self')
local util = require('openmw.util')
local camera = require('openmw.camera')



--========================================================================================================================================================================================================
--this handles the skill gain for custom spells
--========================================================================================================================================================================================================
local function SpellCastSkillGain(passedTable)

    -- if passedTable.ContinueCheck ~= true then return passedTable end

    if(passedTable.Cost_SCALE == nil) then passedTable.Cost_SCALE = 1 end
	SkillProgression.skillUsed(passedTable.CustomEffectSchool, {useType = SkillProgression.SKILL_USE_TYPES.Spellcast_Success,scale=passedTable.Cost_SCALE })
    return passedTable  
end



--========================================================================================================================================================================================================
--this sends a global event to spawn the projectile
--========================================================================================================================================================================================================
local function SendGlobalEventToSpawnProjectile(passedTable)
    -- if passedTable.ContinueCheck == false then return passedTable end

	passedTable["EventScript"] ='GlobalSpawnProjectile'
    core.sendGlobalEvent('GlobalEventBulider',passedTable)

    return passedTable
end





--========================================================================================================================================================================================================
--this handles the spell particles around the player for cutom spells
--========================================================================================================================================================================================================
local function playParticleAnimation(passedTable)

    -- if passedTable.ContinueCheck == false then return passedTable end


	local SpellEffectForAnimation =  types.Actor.getSelectedSpell(self).effects[1]

	local mgef = core.magic.effects.records[SpellEffectForAnimation.id]
	self:sendEvent('AddVfx', {
	  model = types.Static.record(mgef.castStatic).model,
	  options = {
		vfxId = mgef.id,
		particleTextureOverride = mgef.particle,
		loop = false
	  }
	})


    return passedTable
end


--========================================================================================================================================================================================================
--this handles the sound
--========================================================================================================================================================================================================
local function playSpellSound(passedTable)

    -- if passedTable.ContinueCheck == false then return passedTable end

	if passedTable['soundtimer'] == nil then passedTable['soundtimer'] = core.getSimulationTime() end
    local spell = types.Actor.getSelectedSpell(self)
	local SpellSoundLocal=  core.magic.effects.records[spell.effects[1].id].castSound
	if SpellSoundLocal == nil then SpellSoundLocal = 'destruction cast' end

	if core.sound.isSoundPlaying(SpellSoundLocal, self) == true then
		if passedTable['soundtimer'] - core.getSimulationTime() > 0.05 then
			core.sound.playSound3d(SpellSoundLocal, self,{timeOffset = 0.6})
			passedTable['soundtimer'] = core.getSimulationTime() + 0.04
		end
		-- if passedTable['soundtimer'] <= 0.05 then
		-- 	passedData['soundtimer'] = passedData['soundtimer'] + passedData['timeCH']
		-- end
	end

	if core.sound.isSoundPlaying(SpellSoundLocal, self) == false then
		core.sound.playSound3d(SpellSoundLocal, self)
	end

	return passedTable
end

-- local function ResetSoundTimer(passedData)
--     passedData['soundtimer'] = 0
-- 	return passedData
-- end






--========================================================================================================================================================================================================
--  This Handles the magicka cost for custom spells
--========================================================================================================================================================================================================
local function TakeMagickaFromPlayerLocal(passedTable)
    -- if passedTable.ContinueCheck == false then return passedTable end

	local CostScalelocal = 1
    if passedTable.Cost_SCALE ~= nil then CostScalelocal = passedTable.Cost_SCALE end
    if passedTable.sparemagicka == nil then passedTable.sparemagicka = 0 end

    local magickaCost = (passedTable.cost or 1) * CostScalelocal


    --if the cost is less then 1 put it in our spare magic bucket, we'll subtract it when we get 1 whole magicka
    if magickaCost < 1 then
        passedTable.sparemagicka = passedTable.sparemagicka + magickaCost
    end
        
    if magickaCost >= 1 then
        -- Round the result for subtraction 
        local magickaCostInteger =math.floor(magickaCost)
        -- Reduce caster magicka
        types.Actor.stats.dynamic.magicka(self).current = types.Actor.stats.dynamic.magicka(self).current - magickaCostInteger
        -- Grab the magicka we rounded off and put in the bucket as well
        passedTable.sparemagicka = passedTable.sparemagicka+magickaCost-magickaCostInteger
    end

    --check the bucket, if it has enough, send it
    if passedTable.sparemagicka >= 1 then
        types.Actor.stats.dynamic.magicka(self).current = types.Actor.stats.dynamic.magicka(self).current - 1
        passedTable.sparemagicka = passedTable.sparemagicka-1
    end
    
    passedTable.magickaCost = magickaCost
    return passedTable
end












--========================================================================================================================================================================================================
--this handles the direction the player is facing, and returns a vector3 of that direction
--========================================================================================================================================================================================================

local function getPlayerDirection(passedTable) 

    -- if passedTable.ContinueCheck == false then return passedTable end

    local directionOfCamera = camera.viewportToWorldVector(util.vector2(0.5,0.5))
    local StartingPositionAdjustmet = directionOfCamera*40
    local additionVector2 = directionOfCamera
    local pos = self.position + StartingPositionAdjustmet +util.vector3(0,0,200)

    passedTable['ProjectilePostion'] = pos
    passedTable['DirectionPassed'] = additionVector2
    passedTable["CurrentplayerCell"] = self.cell.name
    return passedTable
end






--========================================================================================================================================================================================================
--this checks if the player has enough magicka to cast a spell, it does not take any magicka from the player, just checks if they have enough
--========================================================================================================================================================================================================


local function checkMagickaFunc(passedTable)

    -- if passedTable.ContinueCheck == false then return passedTable end

    -- Check magicka
    local magickaCost = (passedTable.cost or 1) * passedTable.Cost_SCALE
    if types.Actor.stats.dynamic.magicka(self).current < magickaCost then 
        passedTable.ContinueCheck = false
        return passedTable 
    end

    passedTable.ContinueCheck = true
    return passedTable  
end


return {
    TakeMagickaFromPlayerLocal = TakeMagickaFromPlayerLocal,
    SpellCastSkillGain = SpellCastSkillGain,
    playParticleAnimation = playParticleAnimation,
    playSpellSound = playSpellSound,
    getPlayerDirection = getPlayerDirection,
    checkMagickaFunc = checkMagickaFunc,
    SendGlobalEventToSpawnProjectile = SendGlobalEventToSpawnProjectile
}