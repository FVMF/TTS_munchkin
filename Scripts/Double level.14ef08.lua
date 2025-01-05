-- Double level Munchkin

function onLoad()
  levelCounters = Global.getTable('levelCounters')
  playerColors = Global.getTable('playerColors')
  ownColor = ''
  pos = self.getPosition()
  rot = self.getRotation()

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