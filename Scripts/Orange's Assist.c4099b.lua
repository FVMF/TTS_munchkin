-- Orange assist figurine
color = 'Orange'

pos = {-17.34, 1.06, -10.52}
rot = {0, 45, 0}

function onPlayerTurn()
  if Player[color].seated == true then
    self.setPositionSmooth(pos, false, false)
    self.setRotationSmooth(rot, false, false)
  end
end --onPlayerTurn