-- Mate
VISIBLE_ONCE = false
RADIUS = 4

function onLoad()
   zoneToUpdate = Global.getTable('equipmentBonusZones')['Monster Support']
   previousValue = 0
   castVisible = true
   pos = self.getPosition()
   rot = self.getRotation()
end --function onLoad

function onPlayerTurn()
   self.setDescription(0)
   self.setPositionSmooth(pos, false, false)
   self.setRotationSmooth(rot, false, false)
   previousValue = 0
   objectInCorrectZone = false
end --function onPlayerTurn

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
end --function onDrop

function onPickUp()
   showCast = true
   self.setDescription('')
end --function onPickUp

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
   if currentValue ~= previousValue then
      self.setDescription(valueOfCards)
      Global.call('updateZoneCounter', zoneToUpdate) 
   end
end --function getValueOfCards

Wait.time(getValueOfCardsInArea, 0.5, -1)