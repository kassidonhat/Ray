local self = require('openmw.self')
local types = require('openmw.types')






--====================================================================================================
--engine handlers
--====================================================================================================


return {
    engineHandlers = {


						--====================================================================================================
						--Frame by frame logic 
						--====================================================================================================
						onActive = function ()
							if self.recordId == 'estirdalin' then
								types.Actor.spells(self):add('BurningRay')
								types.Actor.spells(self):add('poisonray')
								types.Actor.spells(self):add('shockingray')
								types.Actor.spells(self):add('freezingray')
							end
							if self.recordId == 'arielle phiencel' then
								types.Actor.spells(self):add('VampiricRay')
								types.Actor.spells(self):add('HarmingRay')

							end
						end

						

		
    }
}