-- Mate
VISIBLE_ONCE = false
castVisible = true
RADIUS = 4
pos = {-5.10, 0.97, 7.50}
rot = {0, 180, 0}

function onLoad(script_state)
   local state = JSON.decode(script_state) 
   if state == '' or state == nil then
      zoneToUpdate = Global.getTable('equipmentBonusZones')['Monster Support']
      currentValue = 0
   else
      zoneToUpdate = getObjectFromGUID(state.zoneToUpdateGUID)
      currentValue = state.currentValue
      objectInCorrectZone = state.objectInCorrectZone
      physicsPosition = state.physicsPosition
   end
end --onLoad

function onPlayerTurn()
   self.setDescription(0)
   self.setPositionSmooth(pos, false, false)
   self.setRotationSmooth(rot, false, false)
   currentValue = 0
   objectInCorrectZone = false
end --onPlayerTurn

function onDrop()
   local zoneTable = {}
   physicsPosition = self.getPosition()
   physicsPosition[2] = physicsPosition[2] - 1
   if #self.getZones() > 0 then
     for _, zone in ipairs(self.getZones()) do
       if zone == zoneToUpdate then --if the token is in the Monster Support area
         objectInCorrectZone = true
       else
         objectInCorrectZone = false
         self.setDescription('')
       end
     end
   else
     objectInCorrectZone = false
   end
end --onDrop

function onPickUp()
   showCast = true
   self.setDescription('')
end --onPickUp

function getValueOfCardsInArea()
   if objectInCorrectZone then
      valueOfCards = 0
      hitlist = Physics.cast({
           origin       = physicsPosition,
           direction    = {0,-1,0},
           type         = 2,
           size         = {RADIUS, RADIUS, RADIUS},
           max_distance = 0,
           debug        = castVisible,
           })
      if VISIBLE_ONCE then
         castVisible = false
      end
      for _, hit in ipairs(hitlist) do
         if hit.hit_object != self then
            objectDescription = hit.hit_object.getDescription()
         end 
         if Global.call('validDescription', objectDescription) then
            valueOfCards = valueOfCards + tonumber(objectDescription)
         end
      end
   end
   if currentValue ~= valueOfCards then
      currentValue = valueOfCards
      self.setDescription(valueOfCards)
      Global.call('updateZoneCounter', zoneToUpdate) 
   end
end --getValueOfCards

function onSave()
   local state = {zoneToUpdateGUID = zoneToUpdate.guid, currentValue = currentValue, objectInCorrectZone = objectInCorrectZone, physicsPosition = physicsPosition}
   return JSON.encode(state)
end --onSave

Wait.time(getValueOfCardsInArea, 0.5, -1)