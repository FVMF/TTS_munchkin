color = 'Green'
previousLevel = 0
previousBonus = 0
previousCp = 0

function onLoad()
  levelCounter = Global.getTable('levelCounters')[color]
  equipBonusCounter = Global.getTable('equipBonusCounters')[color]
  assistFig = Global.getTable('playerAssistFigs')[color]
  playerSupportZone = Global.getTable('equipmentBonusZones')['Player Support']
  tokensToUpdate = Global.getTable('tokensToUpdate')
end --onLoad

function onFixedUpdate()
   if Player[color].seated then
   tick_count = Global.getVar('tick_count')
   if tick_count % 30 == 0 then --three times per second (90 physics ticks per second)
     gameStarted = Global.getVar('gameStarted')
     if gameStarted == true then
       currentLevel = levelCounter.getValue()
       currentBonus = equipBonusCounter.getValue()
       currentCp = self.getValue()
       if(currentLevel ~= previousLevel or currentBonus ~= previousBonus or currentCp ~= previousCp) then
         maxLevel = Global.getVar('maxLevel') 
         if currentLevel < 1 then
           currentLevel = 1
           levelCounter.setValue(currentLevel)
         elseif currentLevel > maxLevel then
           currentLevel = maxLevel
           levelCounter.setValue(currentLevel)
         end
         local combatPower = currentLevel + currentBonus
         self.setValue(combatPower)
         assistFig.setDescription(combatPower)

         if #playerSupportZone.getObjects() > 0 then
           toUpdate = false
           for _, object in ipairs(playerSupportZone.getObjects()) do
             if object.tag ~= 'Card' or object.tag ~= 'Deck' then --skip all cards or decks
               if object == tokensToUpdate['Double Level'] then
                 object.setDescription(currentLevel)
                 toUpdate = true
               elseif object == tokensToUpdate['Doppleganger'] then
                 object.setDescription(combatPower)
                 toUpdate = true
               elseif object == tokensToUpdate['Level Only I'] or object == tokensToUpdate['Level Only II'] then
                 if currentBonus > 0 then
                   minusBonus = currentBonus * -1
                   object.setDescription(minusBonus)
                 end
                 toUpdate = true
               elseif object == assistFig then--if the player assist figurine is in the Player Support area
                 toUpdate = true
               end

             end             
           end
           if toUpdate then
             Global.call('updateZoneCounter', playerSupportZone)
           end
         end
         previousLevel = currentLevel
         previousBonus = currentBonus
         previousCp = currentLevel + currentBonus
       end
     end
   end
   end

end --onFixedUpdate