--====================================================================================================================================================================================================
--  This Spawns in the area VFX
--====================================================================================================================================================================================================




--====================================================================================================================================================================================================
--  Imports
--====================================================================================================================================================================================================
local world = require('openmw.world')
local core = require('openmw.core')
local types = require('openmw.types')
local util = require('openmw.util')




--====================================
-- Variables
--====================================
local ParticleForVFX = nil
local SpellID = nil
local ModSettings = nil
local SpellVar = nil


--====================================
-- This gets ahold of the mod settings for the damage object, this mod needs it for the scale factor.
--====================================

local function GetModSettingsForDamageObjectLocal(sentData)
	ModSettings = sentData
	print('settings sent to Target Handling')
	print('===============================================================================================================================================')
end





--====================================
-- Hit Target Add Script 
--====================================
local function HitTargetWithSpellLocal(PassedData)

	-- Aggro the person we hit
	types.Actor.activeSpells(PassedData.Target):add({id = PassedData.SpellID,
															effects = { 0 },
															stackable = true,
															name = 'Aggro',
															caster = PassedData.CasterObject
															})
															


	--Here we grab the custom effects that were passed
	local CustomEffectsPassed = {}
	for i,k in pairs(PassedData) do
		if string.find(i, 'CustomEffect') ~= nil then

			CustomEffectsPassed[k]=k
		end
	end
	
	SpellVar = core.magic.spells.records[PassedData.SpellID]

	-- Go through each effect of the spell, for each ray effect, run it's corresponding script
	for key, effect in pairs(SpellVar.effects) do

		-- This checks if the effect is a custom effect that was passed
		if CustomEffectsPassed[SpellVar.effects[key].id] then
					
					


					--This grabs the values out of the effect that we need
					local newmagnitudeMax = nil
					local newmagnitudeMin = nil
					local newEffectID = nil
					local storeduration = nil
					if effect.magnitudeMax then
						newmagnitudeMax = effect.magnitudeMax	
					end
					if effect.magnitudeMin then
						newmagnitudeMin = effect.magnitudeMin
					end
					if effect.duration then
						storeduration = effect.duration
					end
					if effect.id then
						newEffectID = effect.id
					end
					
					PassedData["MaxDamage"] = newmagnitudeMax
					PassedData["MinDamage"] = newmagnitudeMin
					PassedData["PassedDuration"] = storeduration
					PassedData["EffectIDPassed"] = newEffectID
					PassedData["ModSettings"] = ModSettings

					--This spawns an object under the player that we attach the spell effect script to, the alternative is to have each effect constantly
					--running, as I need the onUpdate engine handler to simulate time. This lets me only run the script when it's needed and delete it after it's finished.
					--The teleport is also neccesary apparently, the onUpdate doesn't run unless I teleport it in
					DamageObjectMade = world.createObject(PassedData.DamageObjectID)	
					DamageObjectMade:teleport(PassedData.CurrentplayerCell, PassedData.CasterObject.position+util.vector3(0,0,-10))
					DamageObjectMade:addScript("scripts/MagicEffects/"..newEffectID..".lua",PassedData)

		end
	end
end




--====================================
-- Hit Target Remove Script 
--====================================
local function HitTargetremoveScriptLocal(PassedData)

	--protection, sometimes the hit detection script sends this event twice
	if not PassedData.DamageObject then
		print("not found")
		return
	end
	
	--deletes the object and script, if it exists
	if  PassedData.DamageObject then
		PassedData.DamageObject:remove()
		PassedData.DamageObject:removeScript("scripts/MagicEffects/"..PassedData.EffectIDPassed..".lua")
	end

end



--====================================================================================================================================================================================================
--  Event Handlers
--====================================================================================================================================================================================================
return {
	
    eventHandlers = {
		GetModSettingsForDamageObject = GetModSettingsForDamageObjectLocal,
        HitTargetWithSpell = HitTargetWithSpellLocal,
		HitTargetremoveScript = HitTargetremoveScriptLocal
    }
	
}

