local self = require('openmw.self')
local core = require('openmw.core')
local types = require('openmw.types')

--[[]]
local soundtimer = 0

--========================================================================================================================================================================================================
--this handles the sound
--========================================================================================================================================================================================================
local function playSpellSound(timeCH)
    local spell = types.Actor.getSelectedSpell(self)
	local SpellSoundLocal=  core.magic.effects.records[spell.effects[1].id].castSound
	if SpellSoundLocal == nil then
		SpellSoundLocal = 'destruction cast'
	end

	if core.sound.isSoundPlaying(SpellSoundLocal, self) == true then
		if soundtimer > 0.05 then
			core.sound.playSound3d(SpellSoundLocal, self,{timeOffset = 0.6})
			soundtimer = 0.04
		end
		if soundtimer <= 0.05 then

			soundtimer = soundtimer + timeCH
		end
	end
	if core.sound.isSoundPlaying(SpellSoundLocal, self) == false then
		core.sound.playSound3d(SpellSoundLocal, self)
		
	end

end

local function ResetSoundTimer()
	
    soundtimer = 0

end


--====================================================================================================================================================================================================
--  Event Handler
--====================================================================================================================================================================================================
return{

	eventHandlers = {
    playSpellSoundEvent = playSpellSound,
    ResetSoundTimerEvent = ResetSoundTimer
	}
	
}
--[[]]