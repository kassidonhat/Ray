local core = require('openmw.core')
local RayEffects = require('scripts.enums.RayEffectsList')
local types = require('openmw.types')
local self = require('openmw.self')




--====================================================================================================
--this handles the spell Parsing
--====================================================================================================
local function SpellParse(PassedSpellID)


	
	
	-- Find the Spell
	local SpellID = PassedSpellID 
	local SpellVar = core.magic.spells.records[SpellID]
    local passedTable = {}
	local FirstPassCheck = 0

	-- go through the effects and get all of the models we're going to use
	for key, effect in ipairs(SpellVar.effects) do
		if RayEffects[SpellVar.effects[key].id] and FirstPassCheck == 0 then
			
			-- these varibles are just nice for read-ability
			local effectsID = SpellVar.effects[key].id
			local effectHere = core.magic.effects.records[effectsID]
			
			-- these variables are what we're after

			passedTable["SizeOfArea"] = SpellVar.effects[key].area
			passedTable["AreaSoundLocal"] = core.magic.effects.records[effectsID].areaSound
			passedTable["projectileModel"] = types.Weapon.records[effectHere.bolt].model 
			passedTable["AreaModel"] = types.Static.records[effectHere.areaStatic].model
			passedTable["ParticleForVFX"] = core.magic.effects.records[effectsID].particle
            passedTable["CasterObject"] = self
            passedTable["ProjectileObjectID"] = 'emptymodelprojectile'
            passedTable["DamageObjectID"] = 'emptymodelprojectile'
            passedTable["maxTime"] = 3
            passedTable["SpellID"] = PassedSpellID
            passedTable["ScriptType#ProjectileObject#ScriptPath:scripts.Require.RayProjectileFunctions#MoveProjectileForwardFunction"] = "MoveProjectileForwardFunction"
            passedTable["ScriptType#ProjectileObject#ScriptPath:scripts.Require.RayProjectileFunctions#hitDetectFunction"] = "hitDetectFunction"
            passedTable["ScriptType#ProjectileObject#ScriptPath:scripts.Require.RayProjectileFunctions#AreaHitDetectFunction"] = "AreaHitDetectFunction"
            passedTable["ScriptType#ProjectileObject#ScriptPath:scripts.Require.RayProjectileFunctions#EarlyRemovalFunction"] = "EarlyRemovalFunction"
            passedTable["ScriptType#ProjectileObject#ScriptPath:scripts.Require.RayProjectileFunctions#RemovalFunction"] = "RemovalFunction"


			-- We only grab the first one even though technically you could have two different ray effects.
			FirstPassCheck = 1

		end
		
		if RayEffects[SpellVar.effects[key].id] then
			passedTable['CustomEffect'..SpellVar.effects[key].id] = SpellVar.effects[key].id
		end
		
		
		
	end



	return passedTable
end




return {SpellParse = SpellParse}