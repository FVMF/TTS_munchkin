-- Purple assist figurine
color = 'Purple'

pos = {29.26, 1.06, -0.07}
rot = {0, 270, 0}

function onPlayerTurn()
  if Player[color].seated == true then
    self.setPositionSmooth(pos, false, false)
    self.setRotationSmooth(rot, false, false)
  end
end --onPlayerTurn