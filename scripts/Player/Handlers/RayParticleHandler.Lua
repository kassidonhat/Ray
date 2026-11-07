local types = require('openmw.types')
local core = require('openmw.core')
local self = require('openmw.self')

--[[]]


--========================================================================================================================================================================================================
--this handles the spell particles around the player
--========================================================================================================================================================================================================
local function playParticleAnimation()
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
end


--====================================================================================================================================================================================================
--  Event Handler
--====================================================================================================================================================================================================
return{

	eventHandlers = {
    playParticleAnimationEvent = playParticleAnimation
	}
	
}--[[]]