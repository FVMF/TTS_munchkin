color = 'Purple'

function onLoad(script_state)
  local state = JSON.decode(script_state)
  if state == '' or state == nil then
    previousLevel = 0
    previousBonus = 0
    previousCp = 0  
    levelCounter = Global.getTable('levelCounters')[color]
    equipBonusCounter = Global.getTable('equipBonusCounters')[color]
    assistFig = Global.getTable('playerAssistFigs')[color]
    playerSupportZone = Global.getTable('equipmentBonusZones')['Player Support']
    tokensToUpdate = Global.getTable('tokensToUpdate')
 else
    previousLevel = state.previousLevel
    previousBonus = state.previousBonus
    previousCp = state.previousCp
    levelCounter = getObjectFromGUID(state.guids.levelCounter)
    equipBonusCounter = getObjectFromGUID(state.guids.equipBonusCounter)
    assistFig = getObjectFromGUID(state.guids.assistFig)
    playerSupportZone = getObjectFromGUID(state.guids.playerSupportZone)
    tokensToUpdate = {['Double Level'] = getObjectFromGUID(state.guids.tokensToUpdate['Double Level']), ['Doppleganger'] = getObjectFromGUID(state.guids.tokensToUpdate['Doppleganger']), ['Level Only I'] = getObjectFromGUID(state.guids.tokensToUpdate['Level Only I']), ['Level Only II'] = getObjectFromGUID(state.guids.tokensToUpdate['Level Only II']) }
 end
end --onLoad

function updateValue()
  if Player[color].seated then
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
end --updateValue

function onSave()
  local state = {
    previousLevel = previousLevel, previousBonus = previousBonus, previousCp = previousCp,
    guids = {levelCounter = levelCounter.guid, equipBonusCounter = equipBonusCounter.guid, assistFig = assistFig.guid, playerSupportZone = playerSupportZone.guid, tokensToUpdate = {['Double Level'] = tokensToUpdate['Double Level'].guid, ['Doppleganger'] = tokensToUpdate['Doppleganger'].guid, ['Level Only I'] = tokensToUpdate['Level Only I'].guid, ['Level Only II'] = tokensToUpdate['Level Only II'].guid}},
  }
  return JSON.encode(state)
end --onSave

Wait.time(updateValue, 0.33, -1)