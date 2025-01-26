pos = {3.08, 1.03, 7.49}
rot = {0, 180, 0}

-- Only level
function onLoad(script_state)
   local state = JSON.decode(script_state)
   if state == '' or state == nil then
      equipBonusCounters = Global.getTable('equipBonusCounters')
      playerColors = Global.getTable('playerColors')
      ownColor = ''
   else
      equipBonusCounters = {['Red'] = getObjectFromGUID(state.guids.red), ['Orange'] = getObjectFromGUID(state.guids.orange), ['Yellow'] = getObjectFromGUID(state.guids.yellow), ['Green'] = getObjectFromGUID(state.guids.green), ['Blue'] = getObjectFromGUID(state.guids.blue), ['Purple'] = getObjectFromGUID(state.guids.purple), ['Monster Support'] = getObjectFromGUID(state.guids.monster_support), ['Player Support'] = getObjectFromGUID(state.guids.player_support)}
      playerColors = state.playerColors
      ownColor = state.ownColor 
   end
end --onLoad

function onPlayerTurn()
   self.setDescription(0)
   self.setColorTint('White')
   ownColor = ''
   self.setPositionSmooth(pos, false, false)
   self.setRotationSmooth(rot, false, false)
end --onPlayerTurn

function has_value (tab, val)
   for index, value in ipairs(tab) do
     if value == val then
       return true
     end
   end
   return false
end --has_value

function onPickUp(playerColor)
   if has_value(playerColors, playerColor) then
      ownColor = playerColor
      self.setColorTint(ownColor)
      equipBonus = equipBonusCounters[playerColor].getValue()
      if equipBonus > 0 then
         equipBonus = equipBonus * -1
      end
      self.setDescription(equipBonus)
   end
end --onPickUp

function onSave()
   local state = {guids = 
      {red = equipBonusCounters['Red'].guid, orange = equipBonusCounters['Orange'].guid, yellow = equipBonusCounters['Yellow'].guid, green = equipBonusCounters['Green'].guid, blue = equipBonusCounters['Blue'].guid, purple = equipBonusCounters['Purple'].guid, monster_support = equipBonusCounters['Monster Support'].guid, player_support = equipBonusCounters['Player Support'].guid},
      playerColors = playerColors, ownColor = ownColor}
   return JSON.encode(state)
end --onSave