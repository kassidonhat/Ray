local SkillProgression = require('openmw.interfaces').SkillProgression
local storage = require('openmw.storage')
local async = require('openmw.async')
--[[]]

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



--========================================================================================================================================================================================================
--this handles the skill gain for custom spells
--========================================================================================================================================================================================================

local function RaySkillGain(passedData)
	SkillProgression.skillUsed(passedData.SkillUsed, {useType = SkillProgression.SKILL_USE_TYPES.Spellcast_Success,CustomPass = 'RaySkillGain',scale=Cost_SCALE })

end



--====================================================================================================================================================================================================
--  Event Handler
--====================================================================================================================================================================================================
return{

	eventHandlers = {
    RaySkillGainEvent = RaySkillGain
	}
	
}--[[]]