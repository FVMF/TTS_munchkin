--Red assist figurine
color = 'Red'

pos = {18.32, 1.06, -10.46}
rot = {0, 315, 0}

function onPlayerTurn()
  if Player[color].seated == true then
    self.setPositionSmooth(pos, false, false)
    self.setRotationSmooth(rot, false, false)
  end
end --onPlayerTurn