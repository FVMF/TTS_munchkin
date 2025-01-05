-- Yellow assist figurine
color = 'Yellow'

pos = {-27.95, 1.06, 0.08}
rot = {0, 90, 0}

function onPlayerTurn()
  if Player[color].seated == true then
    self.setPositionSmooth(pos, false, false)
    self.setRotationSmooth(rot, false, false)
  end
end --onPlayerTurn