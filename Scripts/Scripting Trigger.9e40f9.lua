function onObjectEnterZone(zone, object)
  for _, tag in ipairs(object.getTags()) do
    if tag == 'Fairy Dust' then
      if zone.guid == '9e40f9' then
        if math.abs(object.getVelocity()[1]) < 1 then
          destroyObject(object)
        end
      end
    end
  end
end --onObjectEnterZone