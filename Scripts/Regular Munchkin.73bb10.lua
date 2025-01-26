color = 'Yellow'

function onLoad(script_state)
  local state = JSON.decode(script_state)
  if state == '' or state == nil then
    self.setName('Regular Munchkin')
    epicText = ''
  else
    self.setName(state.name)
    epicText = state.epicText
  end
end --onLoad

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

function onSave()
  local state = {name = self.getName(), epicText = epicText}
  return JSON.encode(state)
end --onSave