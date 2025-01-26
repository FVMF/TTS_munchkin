--Double level Munchkin
pos = {6.26, 0.97, 7.50}
rot = {0, 180, 0}

function onLoad(script_state)
  local state = JSON.decode(script_state)
  if state == '' or state == nil then
    levelCounters = Global.getTable('levelCounters')
    playerColors = Global.getTable('playerColors')
    ownColor = ''
  else
    levelCounters = {['Red'] = getObjectFromGUID(state.guids.red), ['Orange'] = getObjectFromGUID(state.guids.orange), ['Yellow'] = getObjectFromGUID(state.guids.yellow), ['Green'] = getObjectFromGUID(state.guids.green), ['Blue'] = getObjectFromGUID(state.guids.blue), ['Purple'] = getObjectFromGUID(state.guids.purple)}
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
    currentLevel = levelCounters[playerColor].getValue()
    self.setDescription(currentLevel)
  end
end --onPickUp

function onSave()
  local state = {guids = 
  {red = levelCounters['Red'].guid, orange = levelCounters['Orange'].guid, yellow = levelCounters['Yellow'].guid, green = levelCounters['Green'].guid, blue = levelCounters['Blue'].guid, purple = levelCounters['Purple'].guid}, playerColors = playerColors, ownColor = ownColor}
  return JSON.encode(state)
end --onSave