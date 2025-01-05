-- Green assist figurine
color = 'Green'

pos = {-17.42, 1.06, 10.13}
rot = {0, 135, 0}

function onPlayerTurn()
  if Player[color].seated == true then
    self.setPositionSmooth(pos, false, false)
    self.setRotationSmooth(rot, false, false)
  end
end --onPlayerTurn