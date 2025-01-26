--Doppleganger
pos = {4.71, 1.02, 7.50}
rot = {0, 180, 0}

function onLoad(script_state)
  local state = JSON.decode(script_state)
  if state == '' or state == nil then
    CpCounters = Global.getTable('equipBonusCounters')
    playerColors = Global.getTable('playerColors')
    ownColor = ''
  else
    CpCounters = {['Red'] = getObjectFromGUID(state.guids.red), ['Orange'] = getObjectFromGUID(state.guids.orange), ['Yellow'] = getObjectFromGUID(state.guids.yellow), ['Green'] = getObjectFromGUID(state.guids.green), ['Blue'] = getObjectFromGUID(state.guids.blue), ['Purple'] = getObjectFromGUID(state.guids.purple)}
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
    self.setColorTint(playerColor)
    currentCp = CpCounters[playerColor].getValue()
    self.setDescription(currentCp)
  end
end --onPickUp

function onSave()
  local state = {guids = 
    {red = CpCounters['Red'].guid, orange = CpCounters['Orange'].guid, yellow = CpCounters['Yellow'].guid, green = CpCounters['Green'].guid, blue = CpCounters['Blue'].guid, purple = CpCounters['Purple'].guid},
     playerColors = playerColors, ownColor = ownColor}
  return JSON.encode(state)
end --onSave