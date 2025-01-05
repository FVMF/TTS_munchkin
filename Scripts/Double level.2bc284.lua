--Double level Monster

function onLoad()
  zoneToUpdate = Global.getTable('equipmentBonusZones')['Monster Support']
  previousValue = 0
  pos = self.getPosition()
  rot = self.getRotation()

end --function onLoad

function onPlayerTurn()
  self.setPositionSmooth(pos, false, false)
  self.setRotationSmooth(rot, false, false)
  previousValue = 0

end --function onPlayerTurn

function onPickUp()
  self.setDescription('')

end --function onPickUp

function onDrop()
  if #self.getZones() > 0 then
    for _, zone in ipairs(self.getZones()) do
      if zone == zoneToUpdate then
        radius = 1.5
        physicsPosition = self.getPosition()
        physicsPosition[2] = physicsPosition[2] - 0.5
        hitlist = Physics.cast({
              origin       = physicsPosition,
              direction    = {0,-1,0},
              type         = 2,
              size         = {radius,radius,radius},
              max_distance = 0,
              debug        = true,
        })
        self.setDescription(hitlist[1].hit_object.getDescription())
        Global.call('updateZoneCounter', zoneToUpdate)
      end
    end
  end

end --function onDrop