--Blue assist figurine
color = 'Blue'

pos = {18.26, 1.06, 10.04}
rot = {0, 221.31, 0}

function onPlayerTurn()
  if Player[color].seated == true then
    self.setPositionSmooth(pos, false, false)
    self.setRotationSmooth(rot, false, false)
  end
end --onPlayerTurn