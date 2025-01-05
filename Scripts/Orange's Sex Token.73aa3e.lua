--Orange Gender Token
color = 'Orange'

function onPickedUp(playerColor)
  if playerColor ~= color and playerColor ~= 'Black' then
    self.drop()
    vel = self.getVelocity()
    self.addForce({-vel['x'],-vel['y'],-vel['z']}, 4)
    Player[playerColor].print('This is not your gender token, ' ..Player[playerColor].steam_name)
  end
end --onPickedUp