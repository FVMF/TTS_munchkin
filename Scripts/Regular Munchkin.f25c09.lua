color = 'Red'

function onLoad()
  self.setName('Regular Munchkin')
  epicText = ''
end --function onLoad

function onRotate(spin, flip)
  playerEpicBool = Global.getTable('epicBool')
  if flip == 0 then
    epicText = ''
    self.setName('Regular Munchkin')
    playerEpicBool[color] = false
  end
  if flip == 180 then
    epicText = ' EPIC'
    self.setName('Epic Munchkin')
    playerEpicBool[color] = true
  end
  Global.setTable('epicBool', playerEpicBool)
end