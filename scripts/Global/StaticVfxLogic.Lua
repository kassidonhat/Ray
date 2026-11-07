
--====================================================================================================================================================================================================
--  This Script Spawns, Adds, and Removes The Projectile Object
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
local projectileModel = nil
local ParticleForVFX = nil
local SpellID = nil
local SpellRemover = nil





--====================================
-- Spell Parsing
--====================================
local function ParseCurrentSelectedSpellLocal(sentData)
	
	-- find the spell
	SpellID = sentData.SpellID
	SpellVar = core.magic.spells.records[SpellID]
	
	local FirstPassCheck = 0
	
	-- go through the effects and get all of the models we're going to use
	for key, effect in ipairs(SpellVar.effects) do
		if RayEffects[SpellVar.effects[key].id] and FirstPassCheck == 0 then
			
			-- these varibles are just nice for read-ability
			local effectsID = SpellVar.effects[key].id
			local effectHere = core.magic.effects.records[effectsID]
			
			-- these variables are what we're after, the models for the projectile and the area effect, the area size of the effect,
			-- and the particle for the VFXs. 
			projectileModel = types.Static.records[effectHere.castStatic].model
			ParticleForVFX = core.magic.effects.records[effectsID].particle
			
			--We only grab the first one even though technically you could have two different ray effects.
			FirstPassCheck = 1

		end
	end
end




--====================================
-- Spawn VFX Logic
--====================================
local function SpawnVFXLocal(PassedData)
	
	--This string is how the game recoginizes what to delete with the vfx.remove function
	SpellRemover = PassedData.ProjectileObject.id..'SpellRemover'	
	vfxPosit = PassedData

	world.vfx.spawn(projectileModel,vfxPosit,{ useAmbientLight = true, vfxId = SpellRemover,particleTextureOverride = ParticleForVFX})
end



--====================================
-- Remove VFX Logic
--====================================
local function RemoveVFXLocal(PassedData)
	
	--this all handles the removal of the vfx
	local function removeTheVFX(vfxId)
		world.vfx.remove(vfxId)
	end
	if pcall(removeTheVFX,SpellRemover) then
		removeTheVFX(SpellRemover)
	end


end













--====================================================================================================================================================================================================
--  Event Handlers
--====================================================================================================================================================================================================
return {
    eventHandlers = {
		ParseCurrentSelectedSpell = ParseCurrentSelectedSpellLocal,
        SpawnVFX = SpawnVFXLocal,
        RemoveVFX = RemoveVFXLocal
		
    }
	
}
