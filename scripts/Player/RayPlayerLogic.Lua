--[[]]

--====================================================================================================================================================================================================
--  This Gets The Player Inputs and Sends the event to the global script to spawn the projectile
--====================================================================================================================================================================================================



--========================================================================================================================================================================================================
--libaries imported
--========================================================================================================================================================================================================
local ui = require('openmw.ui')
local core = require('openmw.core')
local types = require('openmw.types')
local self = require('openmw.self')
local util = require('openmw.util')
local debug = require('openmw.debug')
local camera = require('openmw.camera')
local nearby = require('openmw.nearby')
local UIInter = require('openmw.interfaces').UI
local storage = require('openmw.storage')
local async = require('openmw.async')
local SkillProgression = require('openmw.interfaces').SkillProgression
local anim = require('openmw.animation')
local I = require('openmw.interfaces')


local PlayerLogic = require('scripts.Player.RequiredFunctions.PlayerLogic')
local RaySpellParse = require('scripts.Player.RequiredFunctions.RaySpellParseFunc')
local GetPlayerDirection = require('scripts.Player.RequiredFunctions.GetPlayerDirection')
local RayEffects = require('scripts.enums.RayEffectsList')



--========================================================================================================================================================================================================
--varibles 
--========================================================================================================================================================================================================


-- these are various logic switches
local fireTimer = 0

-- Spell Update switches
local CurrentSpellSelected = {id = 'NothingSelectedYet'}
local SpellChangeCheck = nil






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
--engine handlers
--====================================================================================================

return {
    engineHandlers = {

		


		--====================================================================================================
		--Frame by frame logic 
		--====================================================================================================
		onUpdate = function (dt2)

			local castState = anim.getCompletion(self, 'raycast')
			if castState == nil then
				castState = 0
			end

			if castState ~= 0 or anim.isPlaying(self, 'raycastloop') then
				if castState > AnimationReleaseT or anim.isPlaying(self, 'raycastloop') then
					
					local SelectedSpell = types.Actor.getSelectedSpell(self)

					fireTimer = fireTimer -dt2
					if fireTimer < 0 and UIInter.getMode() == nil then
						fireTimer = FIRE_RATE
						

						if not PlayerLogic.checkMagicka(SelectedSpell.cost, Cost_SCALE) then
							return end
						self:sendEvent('TakeMagickaFromPlayer', {cost = SelectedSpell.cost,
							CostScale = Cost_SCALE})
									
						self:sendEvent('RaySkillGainEvent', {SkillUsed = PlayerLogic.GetRayEffectSchoolInSpell(SelectedSpell)})
						
						-----------------------------------------------------
						--Player VFX and SFX
						self:sendEvent('playParticleAnimationEvent')
						self:sendEvent('playSpellSoundEvent', dt2)
					
					
						-------------------------------------------------------
						-- Building the table for passing
						local passedTable = RaySpellParse.SpellParse(SelectedSpell.id)
						local playerDirection = GetPlayerDirection.getPlayerDirection()

						--location information
						passedTable["ProjectilePostion"] = playerDirection.pos
						passedTable["CurrentplayerCell"] = self.cell.name
						passedTable["DirectionPassed"] = playerDirection.additionVector2
						passedTable["magickaCost"] = SelectedSpell.cost*Cost_SCALE

						-----------------------------------------------------
						-- sending an event to the global script so it can spawn the projectile
						core.sendGlobalEvent('SpawnProjectile',passedTable)

					end
				end
			end
		end,
    }
}










