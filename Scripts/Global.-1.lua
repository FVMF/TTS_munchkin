--Global script
--Base of script by Mr_Crzy, heavily modified by FVMF
gameStarted = false

function onload()
  if gameStarted == false then
    DEBUG = false
    maxLevel = 10 --default max level
    HIDING_HEIGHT = 10000
    epicMode = false
    meepleMode = false
    fasterPlayMode = false
    bottTimer = getObjectFromGUID('18d357')
    topTimer = getObjectFromGUID('67a2fc')
    playBoard = getObjectFromGUID('da6519')
    playBoard.interactable = false
    getObjectFromGUID('e16795').interactable = false --makes floating table non-interactable
    getObjectFromGUID('585a77').interactable = false --makes floating table non-interactable
    
    initializeObjects()
    
    sexMaleZones = { ['Red'] = getObjectFromGUID('937646'), ['Orange'] = getObjectFromGUID('067e27'), ['Yellow'] = getObjectFromGUID('ee5e14'),
                     ['Green'] = getObjectFromGUID('50bfe7'), ['Blue'] = getObjectFromGUID('d8c354'), ['Purple'] = getObjectFromGUID('086d64') }

    sexFemaleZones = { ['Red'] = getObjectFromGUID('d9f906'), ['Orange'] = getObjectFromGUID('af9179'), ['Yellow'] = getObjectFromGUID('459f17'), 
                       ['Green'] = getObjectFromGUID('dfd5da'), ['Blue'] = getObjectFromGUID('22fc62'), ['Purple'] = getObjectFromGUID('cef2fd') }

    equipmentBonusZones = { ['Red'] = getObjectFromGUID('8ba979'), ['Orange'] = getObjectFromGUID('49cd5f'), ['Yellow'] = getObjectFromGUID('e5f975'),
                            ['Green'] = getObjectFromGUID('c6713b'), ['Blue'] = getObjectFromGUID('6058eb'), ['Purple'] = getObjectFromGUID('d3c8fb'),
                            ['Monster Support'] = getObjectFromGUID('0f4c0d'), ['Player Support'] = getObjectFromGUID('dc3261') }

    levelZones = { --[[top levs]][1] = getObjectFromGUID('306e3d'), [2] = getObjectFromGUID('189e69'), [3] = getObjectFromGUID('b6658a'), [4] = getObjectFromGUID('447c41'), [5] = getObjectFromGUID('c94d60'),
                     [6] = getObjectFromGUID('657b16'), [7] = getObjectFromGUID('e17242'), [8] = getObjectFromGUID('b776af'), [9] = getObjectFromGUID('f8a99b'), [10] = getObjectFromGUID('147c21'),
                 
                   --[[bottom levs]][20] = getObjectFromGUID('f81290'), [19] = getObjectFromGUID('05759b'), [18] = getObjectFromGUID('ee4d11'), [17] = getObjectFromGUID('129765'), [16] = getObjectFromGUID('f6fc19'),
                     [15] = getObjectFromGUID('b19b66'), [14] = getObjectFromGUID('e6efb6'), [13] = getObjectFromGUID('8b88c4'), [12] = getObjectFromGUID('b30c8b'), [11] = getObjectFromGUID('7752ae') 
                 }

    deckZones = { ['Door Deck'] = getObjectFromGUID('af8979'), ['Door Discard'] = getObjectFromGUID('7857fc'),
                  ['Treasure Deck'] = getObjectFromGUID('6b77f1'), ['Treasure Discard'] = getObjectFromGUID('ff5448'),
                  ['Bosses'] = getObjectFromGUID('4959c7'), ['Bosses Discard'] = getObjectFromGUID('9a1441'),
                  ['Fairy Dust'] = getObjectFromGUID('7f109e'), ['Fairy Dust Discard'] = getObjectFromGUID('9e40f9'),
                  ['Munchkinomicon'] = getObjectFromGUID('f2f504'), ['Munchkinomicon Discard'] = getObjectFromGUID('a63226'),
                  ['Side Quests'] = getObjectFromGUID('4436f4'), ['Side Quests Discard'] = getObjectFromGUID('e4adb2'),
                  ['Side Quests 2'] = getObjectFromGUID('4436f4'), ['Side Quests 2 Discard'] = getObjectFromGUID('e4adb2')  
                }

    valueCpCounters = { ['Red'] = 0, ['Orange'] = 0, ['Yellow'] = 0, ['Green'] = 0, ['Blue'] = 0, ['Purple'] = 0 }
    
    playerHandZones = { ['Red'] = getObjectFromGUID('237de9'), ['Orange'] = getObjectFromGUID('7f61a9'), ['Yellow'] = getObjectFromGUID('7835c7'),
                        ['Green'] = getObjectFromGUID('a8572e'), ['Blue'] = getObjectFromGUID('e3027e'), ['Purple'] = getObjectFromGUID('05121b') }
    
    secondHandZones = { ['Red'] = getObjectFromGUID('986c0f'), ['Orange'] = getObjectFromGUID('26b16e'), ['Yellow'] = getObjectFromGUID('6df739'), 
                      ['Green'] = getObjectFromGUID('b4e68c'), ['Blue'] = getObjectFromGUID('43d0a1'), ['Purple'] = getObjectFromGUID('a87025') } 
    
    playerColors = { 'Red', 'Orange', 'Yellow', 'Green', 'Blue', 'Purple' }
    
    playerSeated = { ['Red'] = false, ['Orange'] = false, ['Yellow'] = false, 
                     ['Green'] = false, ['Blue'] = false, ['Purple'] = false }
    
    epicBool = { ['Red'] = false, ['Orange'] = false, ['Yellow'] = false,
                 ['Green'] = false, ['Blue'] = false, ['Purple'] = false } 
  
    sideDeckBoxes = { ['Bosses'] = getObjectFromGUID('510c92'), ['Fairy Dust'] = getObjectFromGUID('9cd897'), ['Munchkinomicon'] = getObjectFromGUID('377762'), ['Side Quests'] = getObjectFromGUID('5e11e9'), ['Side Quests 2'] = getObjectFromGUID('53af45') }

    sideDeckObjects = { ['Bosses'] = '', ['Fairy Dust'] = '', ['Munchkinomicon'] = '', ['Side Quests'] = '', ['Side Quests 2'] = '' }

    sideDeckTags = { 'Bosses', 'Fairy Dust', 'Munchkinomicon', 'Side Quests', 'Side Quests 2' }

    textObjects = { getObjectFromGUID('42be31'), getObjectFromGUID('7e6656'), getObjectFromGUID('d9aa73'), getObjectFromGUID('9d7cc8'), getObjectFromGUID('6f3de2'),
                    getObjectFromGUID('00dbc9'), getObjectFromGUID('d2eea9'), getObjectFromGUID('3f44f2'), getObjectFromGUID('be9c7e'), getObjectFromGUID('7b1d51') }

    for _, meepleColor in pairs(meeples) do --hide all meeples
      for _, meeple in pairs(meepleColor) do
        hideObject(meeple, not DEBUG)
      end
    end 
    for _, token in pairs(epicTokens) do  --hide epicTokens
      hideObject(token, not DEBUG)
    end
    for _, playerColor in pairs(playerColors) do --hide all player specific objects for non-seated players
      playerObjects = { playerFigs[playerColor], playerAssistFigs[playerColor], playerDice[playerColor], sexTokens[playerColor], sexCards[playerColor], equipBonusCounters[playerColor], CpCounters[playerColor], levelCounters[playerColor], infoCards[playerColor] }
      for _, playerObject in pairs(playerObjects) do
        --hideObject(playerObject, true)
        if DEBUG ~= true then
          hideObject(playerObject, not Player[playerColor].seated)
        else
          hideObject(playerObject, false)
        end
      end
    end 
    hideObject(meepleRuleCard, not meepleMode)
    
    for _, player in pairs(getSeatedPlayers()) do
      playerSeated[player] = true
    end

    Player["White"].changeColor("Red") --When loading the mod, default player color is White, change that to the Red seat (because the White one is missing)
  end

end --onload

function initializeObjects()
  playerFigs = { ['Red'] = getObjectFromGUID('ab2f82'), ['Orange'] = getObjectFromGUID('384799'), ['Yellow'] = getObjectFromGUID('61ffcd'), 
                 ['Green'] = getObjectFromGUID('a8e458'), ['Blue'] = getObjectFromGUID('8bc63c'), ['Purple'] = getObjectFromGUID('c232de') }

  playerAssistFigs = { ['Red'] = getObjectFromGUID('59db57'), ['Orange'] = getObjectFromGUID('c4099b'), ['Yellow'] = getObjectFromGUID('ce5e12'),
                       ['Green'] = getObjectFromGUID('d3df4a'), ['Blue'] = getObjectFromGUID('3aa0f1'), ['Purple'] = getObjectFromGUID('a24766') }
 
  playerDice = { ['Red'] = getObjectFromGUID('bcaa70'), ['Orange'] = getObjectFromGUID('f06878'), ['Yellow'] = getObjectFromGUID('976452'),
                 ['Green'] = getObjectFromGUID('297e8e'), ['Blue'] = getObjectFromGUID('e40b18'), ['Purple'] = getObjectFromGUID('a884b0') }
  
  sexTokens = { ['Red'] = getObjectFromGUID('e792ab'), ['Orange'] = getObjectFromGUID('73aa3e'), ['Yellow'] = getObjectFromGUID('495c41'),
                ['Green'] = getObjectFromGUID('089a44'), ['Blue'] = getObjectFromGUID('2122da'), ['Purple'] = getObjectFromGUID('080520') }
 
  sexCards = { ['Red'] = getObjectFromGUID('460dd4'), ['Orange'] = getObjectFromGUID('cbd287'), ['Yellow'] = getObjectFromGUID('1a3fde'),
               ['Green'] = getObjectFromGUID('dff550'), ['Blue'] = getObjectFromGUID('9cba8e'), ['Purple'] = getObjectFromGUID('48c06a') }

  equipBonusCounters = { ['Red'] = getObjectFromGUID('18006a'), ['Purple'] = getObjectFromGUID('5e189c'), ['Blue'] = getObjectFromGUID('a37170'),
                         ['Green'] = getObjectFromGUID('4c4c5f'), ['Yellow'] = getObjectFromGUID('02a27c'), ['Orange'] = getObjectFromGUID('9c0f6c'),
                         ['Monster Support'] = getObjectFromGUID('6bb260'), ['Player Support'] = getObjectFromGUID('dea604') }

  CpCounters = { ['Red'] = getObjectFromGUID('a809ba'), ['Orange'] = getObjectFromGUID('b20553'), ['Yellow'] = getObjectFromGUID('49d10e'),
                 ['Green'] = getObjectFromGUID('f6e5e2'), ['Blue'] = getObjectFromGUID('286541'), ['Purple'] = getObjectFromGUID('3b8902') }

  levelCounters = { ['Red'] = getObjectFromGUID('689db6'), ['Orange'] = getObjectFromGUID('03fd07'), ['Yellow'] = getObjectFromGUID('99e753'),
                    ['Green'] = getObjectFromGUID('07687c'), ['Blue'] = getObjectFromGUID('d84dad'), ['Purple'] = getObjectFromGUID('cc90ff') }

  tokensToUpdate = { ['Double Level'] = getObjectFromGUID('14ef08'), ['Doppleganger'] = getObjectFromGUID('6ffb96'),
                     ['Level Only I'] = getObjectFromGUID('e42d82'), ['Level Only II'] = getObjectFromGUID('c8cdc6') }

  epicTokens = { ['Red'] = getObjectFromGUID('f25c09'), ['Orange'] = getObjectFromGUID('54b150'), ['Yellow'] = getObjectFromGUID('73bb10'),
                 ['Green'] = getObjectFromGUID('ba4a94'), ['Blue'] = getObjectFromGUID('4c7d17'), ['Purple'] = getObjectFromGUID('164328') }

  meeples = { ['Red'] = { [1] = getObjectFromGUID('57e5fd'), [2] = getObjectFromGUID('f577c5'), [3] = getObjectFromGUID('41cc40'), [4] = getObjectFromGUID('107064'), [5] = getObjectFromGUID('4742e4') },
              ['Orange'] = { [1] = getObjectFromGUID('772fe4'), [2] = getObjectFromGUID('45f10d'), [3] = getObjectFromGUID('75530f'), [4] = getObjectFromGUID('b9bd32'), [5] = getObjectFromGUID('0feb8a') },
              ['Yellow'] = { [1] = getObjectFromGUID('299150'), [2] = getObjectFromGUID('a3e043'), [3] = getObjectFromGUID('60e5fd'), [4] = getObjectFromGUID('765d02'), [5] = getObjectFromGUID('446e24') }, 
              ['Green'] = { [1] = getObjectFromGUID('056dae'), [2] = getObjectFromGUID('03cc6c'), [3] = getObjectFromGUID('90fc4a'), [4] = getObjectFromGUID('e81bbb'), [5] = getObjectFromGUID('d71916') }, 
              ['Blue'] = { [1] = getObjectFromGUID('59e9f1'), [2] = getObjectFromGUID('c8cd14'), [3] = getObjectFromGUID('35d627'), [4] = getObjectFromGUID('ecc8d0'), [5] = getObjectFromGUID('e9a8ff') }, 
              ['Purple'] = { [1] = getObjectFromGUID('baf592'), [2] = getObjectFromGUID('bfecb7'), [3] = getObjectFromGUID('f855d8'), [4] = getObjectFromGUID('37b060'), [5] = getObjectFromGUID('fbf02f') } }    
  
  meepleRuleCard = getObjectFromGUID('879603') 
  
  infoCards = { ['Red'] = getObjectFromGUID('efec8a'), ['Orange'] = getObjectFromGUID('d6755c'), ['Yellow'] = getObjectFromGUID('48ffdb'),
                ['Green'] = getObjectFromGUID('48c904'), ['Blue'] = getObjectFromGUID('2e4791'), ['Purple'] = getObjectFromGUID('e8c75e') }

end --initializeObjects

function hideObject(object, boolHide)

  if object ~= nil then --make sure the object exists
    objectPos = object.getPosition()
    if boolHide and objectPos[2] > 0 then --Hide object when shown at the moment
      objectPos[2] = objectPos[2] - HIDING_HEIGHT
    elseif boolHide == false and objectPos[2] < 0 then --Show object when hidden at the moment
      objectPos[2] = objectPos[2] + HIDING_HEIGHT
    end
    object.setPosition(objectPos)
    object.interactable = not boolHide --Make object interactable when shown
    if object.type ~= 'Counter' then
      object.locked = boolHide --Lock objects when they are hidden
    else
      object.locked = true --Keep counters locked, also when shown 
    end
  end
end --hideObject

function onObjectEnterScriptingZone(zone, enter_object)
  for figColor, enter_object in pairs(playerFigs) do
    if enter_object == playerFigs[figColor] then Player[figColor].lift_height = 0.15 end
  end
  
  if zone == equipmentBonusZones['Monster Support'] or zone == equipmentBonusZones['Player Support'] then --pauses clock if an object enters the zone
    if bottTimer.getValue() > 0 then
      if bottTimer.Clock.paused == false then
        bottTimer.Clock.pauseStart()
        topTimer.Clock.pauseStart()
      end
    end
  end
  
  if enter_object.tag == 'Deck' then
    updateDeckDescription(enter_object)
  end
  
  if enter_object.getDescription() == "Changes sex in Munchkin figurine's description." then --sets player model's sex in description
    for zoneColor, enter_object in pairs(sexMaleZones) do sex(enter_object, zoneColor, zone) end
    for zoneColor, enter_object in pairs(sexFemaleZones) do sex(enter_object, zoneColor, zone) end
  end    
  
  if zone == equipmentBonusZones['Red'] or zone == equipmentBonusZones['Orange'] or zone == equipmentBonusZones['Yellow'] or zone == equipmentBonusZones['Green'] or zone == equipmentBonusZones['Blue'] or zone == equipmentBonusZones['Purple'] then
    if enter_object.tag == 'Card' then
      handZoneRot = zone.getRotation()[2]
      enterObjRot = enter_object.getRotation()[2]
      relativeRot = enterObjRot - handZoneRot
      if relativeRot >= 44 and relativeRot <= 136 or relativeRot >= -136 and relativeRot <= -44 or relativeRot >= 224 and relativeRot <= 316 or relativeRot >= -314 and relativeRot <= -224 then
        enter_object.addTag("Sideways")
      else
        enter_object.removeTag("Sideways")
      end
    end
  end
 
  updateZoneCounter(zone)
  
  if enter_object.tag == 'Figurine' or enter_object.tag == 'Tileset' then
    for zoneNumb, object in pairs(levelZones) do --shows current level on levelCounters
      if object == zone then
        objColor = enter_object.getVar('color')
        if objColor != nil then -- make sure there is a variable to read
          currentLevel = tonumber(zoneNumb)
          if epicMode == true then 
            tokenFlip = math.floor(epicTokens[objColor].getRotation()[3] + 0.1)
            if zoneNumb < 11 then
              flipValue = 180 
            else
              flipValue = 0 
            end
            if tokenFlip == flipValue then
              epicTokens[objColor].flip()
            end              
          elseif epicMode == false then
            if zoneNumb > 10 then
              currentLevel = tonumber(20 - currentLevel + 1)
            end
          end      
          levelCounters[objColor].setValue(currentLevel)
          if Player[objColor].steam_name != nil then
            figurineName = Player[objColor].steam_name
          else
            figurineName = objColor
          end
          epicText = epicTokens[objColor].getVar("epicText")
          playerFigs[objColor].setName('Lv. '..currentLevel..' '..figurineName..''..epicText..' Munchkin') --changes name of munchkin to show player level
          playerAssistFigs[objColor].setName('Lv. '..currentLevel..' '..figurineName..''..epicText..' Assist') --change assist token to show level
          printToAll('--- [b]'..figurineName..'[/b] is'..epicText..' Lv. [i]'..currentLevel..'[/i] ---')
        end
      end
    end
  end
end --onObjectEnterScriptingZone

function updateDeckDescription(deck)

  for _, zone in ipairs(deck.getZones()) do
    current_zone = getObjectFromGUID(zone.guid)
    if findIndexOfValueInTable(equipmentBonusZones, current_zone) != nil then
      for key, value in pairs(equipmentBonusZones) do
        if zone == value then
          deckCombatPower = 0
          for _, object in ipairs(deck.getObjects()) do
            if tonumber(object.description) ~= nil then
              deckCombatPower = deckCombatPower + tonumber(object.description)
            end
          end
          deck.setDescription(deckCombatPower)               
        end
      end
    end    
  end

end --updateDeckDescription

function betweenTwoLimits(value, lowerLimit, upperLimit)
  if value >= lowerLimit and value <= upperLimit then
    return true
  else
    return false
  end
end --betweenTwoLimits

function updateZoneCounter(zone)
  if findIndexOfValueInTable(equipmentBonusZones, zone) != nil then 
    totalCombatPower = 0
    for _, object in pairs(zone.getObjects()) do
      description = object.getDescription()
      if(tonumber(description) ~= nil) then
        if object.hasTag("Sideways") == false then
          totalCombatPower = totalCombatPower + tonumber(description)
        end
      end  
    end
    counterIndex = findIndexOfValueInTable(equipmentBonusZones, zone)
    equipBonusCounters[counterIndex].setValue(totalCombatPower)
  end
end --updateZoneCounter

function onObjectEnterContainer(object, enter_object)
  if object.type == 'Deck' then

    updateDeckDescription(object)  
  end
  for _, zone in ipairs(object.getZones()) do
    updateZoneCounter(zone)
  end
end --onObjectEnterContainer

function onObjectLeaveContainer(object, leave_object)
  if object.type == 'Deck' then
    updateDeckDescription(object)  
  end
  for _, zone in ipairs(object.getZones()) do
    updateZoneCounter(zone)
  end
  if leave_object.hasTag('Player Object') then
    initializeObjects()
  end
end --onObjectLeaveContainer

function sex(enter_object, zoneColor, zone)
  if enter_object == zone then
    genCardRot = sexCards[zoneColor].getRotation()
    genCardPos = sexCards[zoneColor].getPosition()
    if zone == sexMaleZones[zoneColor] then
      sexMessage1 = '[00F6FF]Male[-]'
      sexMessage2 = '[00F6FF]--- [b]'..Player[zoneColor].steam_name..'[/b] is a [i]male[/i] ---[-]'
      sexCards[zoneColor].setPositionSmooth(genCardPos:setAt('y', 2), false, false) --set sex card in the air for a smooth flip
      sexCards[zoneColor].setRotationSmooth(genCardRot:setAt('z', 180), false, false) --flips sex card
    else
      sexMessage1 = '[FF00FA]Female[-]'
      sexMessage2 = '[FF00FA]--- [b]'..Player[zoneColor].steam_name..'[/b] is a [i]female[/i] ---[-]'
      sexCards[zoneColor].setPositionSmooth(genCardPos:setAt('y', 2), false, false)
      sexCards[zoneColor].setRotationSmooth(genCardRot:setAt('z', 0), false, false)
    end
    playerFigs[zoneColor].setDescription(sexMessage1) --change description of main figure to show sex
    sexTokens[zoneColor].setName(sexMessage1) --sets sex token name to sex
    printToAll(sexMessage2) 
  end
end --sex

function onObjectLeaveScriptingZone(zone, leave_object)
  if leave_object.getDescription() == "Changes sex in Munchkin figurine's description." then --sets player model's sex to sexless for leaving sex zone
    for zoneColor, leave_object in pairs(sexMaleZones) do 
      sexless(leave_object, zoneColor, zone)
    end
    for zoneColor, leave_object in pairs(sexFemaleZones) do 
      sexless(leave_object, zoneColor, zone)
    end
  end

  if leave_object.tag == 'Deck' and #leave_object.getZones() == 0 then
    leave_object.setDescription('')
  end  
  if leave_object.tag == 'Card' then
    leave_object.removeTag("Sideways")   
  end
 
  updateZoneCounter(zone)
end --onObjectLeaveScriptingZone

function sexless(leave_object, zoneColor, zone)
  if leave_object == zone then
    playerFigs[zoneColor].setDescription('Sexless')
    sexTokens[zoneColor].setName('Sexless')
  end
end --sexless

function has_value (tab, val)
  for index, value in ipairs(tab) do
    if value == val then
      return true
    end
  end
  return false
end --has_vlaue

function findIndexOfValueInTable(table, value)
  local index={}
  for k,v in pairs(table) do
    index[v]=k
  end
  return index[value]
end --findIndexOfValueInTable

function validDescription(string)
  pattern = "[+-1234567890]"
  if string == '' then
    return false
  end
  for i = 1, #string, 1 do
    local character = string:sub(i,i)
    if string.match(character, pattern) == false then
      return false
    end
  end
  return true
end --validDescription

function moveCardsAboveDestination(object, destination, distance)
  object.setPosition(destination.getPosition():setAt('y', distance))
end --moveCardsAboveDestination

function cleanUp()
  local cleanUpZones = {'Monster Support', 'Player Support'}
  for _, zoneName in pairs(cleanUpZones) do
    if (equipmentBonusZones[zoneName].getObjects() != nil and equipmentBonusZones[zoneName].getObjects() !={}) then
      objectsToMove = equipmentBonusZones[zoneName].getObjects()
      for i = #objectsToMove, 1, -1 do
        local objectTags = objectsToMove[i].getTags()
        if #objectTags > 0 then
          local tagName = objectTags[1]
          if tagName == 'Door' or tagName == 'Treasure' or tagName == 'Bosses' or tagName == 'Fairy Dust' or tagName == 'Munchkinomicon' or tagName == 'Side Quests' then
            local discardName = string.format('%s Discard', tagName)
            local discardZone = deckZones[discardName]
            objectsToMove[i].setRotation(discardZone.getRotation())
            moveCardsAboveDestination(objectsToMove[i], discardZone, 10 + i/2)
          end
        end
      end
    end
  end
end --cleanUp

function onPlayerTurn()
  cleanUp()
end --onPlayerTurn

tick_count = 0

function onFixedUpdate()
  tick_count = tick_count + 1
  if tick_count >= 90 then
    tick_count = 0
  end 
end --onFixedUpdate

function onObjectRotate(object, spin, flip)
  if object.tag == 'Card' then
    if #object.getZones() > 0 then
      for _, zone in ipairs(object.getZones()) do
        if zone != equipmentBonusZones['Monster Support'] and zone != equipmentBonusZones['Player Support'] then
          handZone = getObjectFromGUID(zone.guid)
          handZoneRot = handZone.getRotation()[2]
          objectRot = spin - handZoneRot
          if objectRot >= 45 and objectRot <= 135 or objectRot >= -135 and objectRot <= -45 or objectRot >= 225 and objectRot <= 315 or objectRot >= -315 and objectRot <= -225 then
            object.addTag("Sideways")
          else
            object.removeTag("Sideways")
          end
          updateZoneCounter(zone)
        end
      end
    end
  end      
end --onObjectRotate

function toggleEpicTokens(player, isOn)
  if isOn == 'False' then
    epicMode = false
    maxLevel = 10
    playBoard.setState(1)
    playBoard = getObjectFromGUID('da6519')
    playBoard.interactable = false
    for _, playerColor in pairs(playerColors) do
      epicTokens[playerColor].setVar("epicText", "")
      epicBool[playerColor] = false
    end
  else
    epicMode = true
    maxLevel = 20
    playBoard.setState(2)
    playBoard = getObjectFromGUID('8ae96a')
    playBoard.interactable = false
    for _, playerColor in pairs(playerColors) do
      if epicTokens[playerColor].getRotation()[3] == 180 then
        epicTokens[playerColor].setVar("epicText", " EPIC")
        epicBool[playerColor] = true
      end
    end
  end
  for _, playerColor in pairs(playerColors) do
    if Player[playerColor].seated == true then
      hideObject(epicTokens[playerColor], not epicMode )
    end
  end
end --toggleEpicTokens

function findDeck(zone)
  local objects = zone.getObjects()
  for _, item in ipairs(objects) do
    if item.tag == 'Deck' then  
        return item
    end
  end
  for _, item in ipairs(objects) do
    if item.tag == 'Card' then
        return item
    end
  end
  return nil
end --findDeck

function toggleSideDecks(player, isOn, id)
  box = sideDeckBoxes[id]
  deckName = string.format('%s Deck', id)
  if isOn == 'True' then
    for _, containedObject in ipairs(box.getObjects()) do
      if containedObject.name == deckName then
        deck = box.takeObject({index = containedObject.index})
        sideDeckObjects[id] = deck
      end
    end
    -- Rotate all side quests deck properly
    if string.match(deckName, 'Side Quests') then
      deck.setRotation({0, 90, 180})
    else
      deck.setRotation({0, 270, 180})
    end
    deck.setPosition(deckZones[id].getPosition())
  else
    -- Handle situation where both Side Quests decks are on the table and one should return to its box
    if string.match(deckName, 'Side Quests') then
      deck = findDeck(deckZones[id])
      tagToCompare = deck.getObjects()[1].tags[1]
      multipleDecks = false
      for _, card in ipairs(deck.getObjects()) do
        if card.tags[1] ~= tagToCompare then
          multipleDecks = true
        end
      end
      if multipleDecks == true then
        if id == 'Side Quests' then otherId = 'Side Quests 2' end
        if id == 'Side Quests 2' then otherId = 'Side Quests' end
        allCardsInTheDeck = deck.getObjects()
        for i = #allCardsInTheDeck, 1, -1 do  
          card = allCardsInTheDeck[i]
          if has_value(card.tags, id) then
            -- Table of takeObject is zero indexed
            deck.takeObject({index = i-1, smooth = false, position = deckZones[id .. ' Discard'].getPosition()})
          end
        end
        Wait.time(
          function()
            deck1 = findDeck(deckZones[id .. ' Discard'])
            deck1.setName(id..' Deck')
            sideDeckBoxes[id].putObject(deck1)
            sideDeckObjects[id] = ''
            deck2 = findDeck(deckZones[otherId])
            deck2.setName(otherId..' Deck')
            sideDeckObjects[otherId] = deck2
          end,
          0.4)
      else
         sideDeckBoxes[id].putObject(sideDeckObjects[id])
        sideDeckObjects[id] = ''
      end
    else
      sideDeckBoxes[id].putObject(sideDeckObjects[id])
      sideDeckObjects[id] = ''
    end
  end
end --toggleSideDecks

function toggleMeeples(player, isOn)
  if isOn == 'False' then
    meepleMode = false
  else
    meepleMode = true 
  end
  for _, playerColor in pairs(playerColors) do
    if Player[playerColor].seated == true then
      for _, meeple in pairs(meeples[playerColor]) do
        hideObject(meeple, not meepleMode)
      end
    end
  end
  hideObject(meepleRuleCard, not meepleMode)
end --toggleMeeples

function toggleFasterPlay(player, isOn)
  if isOn == 'False' then
    fasterPlayMode = false
  else
    fasterPlayMode = true 
  end
end --toggleFasterPlay

function getHandZoneForObject(object)
  for _, zone in ipairs(object.getZones()) do
    if zone.type == "Hand" then
      return zone
    end
  end
  return nil
end --getHandZoneForObject

function isActionAllowed(playerColor, object)
  local handZonesOfPlayer = {playerHandZones[playerColor], secondHandZones[playerColor]}
  local ownerHandZone = getHandZoneForObject(object)
  local allowAction = false
  if ownerHandZone ~= nil then --if the object is in a handzone
    for _, handZone in ipairs(handZonesOfPlayer) do
      if handZone == ownerHandZone then
        allowAction = true
        break
      end
    end
  else --if the object is not in a handzone
    allowAction = true
  end
  return allowAction
end --isActionAllowed 

function onObjectPickUp(playerColor, object)
  local allowAction = isActionAllowed(playerColor, object)
  if allowAction == false then
    Player[playerColor].print(Player[playerColor].steam_name..", you cannot pick up cards in a hand zone that is not yours.")
    object.drop() --cancel pickup of object
  end
end --onObjectPickUp

function tryObjectRotate(object, spin, flip, playerColor, old_spin, old_flip)
  local allowAction = isActionAllowed(playerColor, object)
  if allowAction then
    return true
  else
    Player[playerColor].print(Player[playerColor].steam_name..", you cannot rotate cards in a hand zone that is not yours.")
    return false --cancel rotation
  end
end --tryObjectRotate

function onObjectHover(playerColor, object)
  if object ~= nil then
--    print(object.guid)
  end
end --onObjectHover

function onPlayerChangeColor(color)

  if color ~= 'Grey' and color ~= 'Black' then --when choosing a seat, make all relevant object visible
    playerColor = color      
    playerObjects = { playerFigs[playerColor], playerAssistFigs[playerColor], playerDice[playerColor], sexTokens[playerColor], sexCards[playerColor],
                      	equipBonusCounters[playerColor], CpCounters[playerColor], levelCounters[playerColor], infoCards[playerColor]}
    for _, playerObject in pairs(playerObjects) do
      if DEBUG ~= true then
        hideObject(playerObject, false)
      end
      objectName = playerObject.getName()
      i, j = string.find(objectName, "'")
      if i ~= nil then --If string has the character to find
        if string.sub(objectName, i+1, i+1) == 's' then
          subStringToChange = string.sub(objectName, 1, i + 1)
        else
          subStringToChange = string.sub(objectName, 1, i)
        end
        if string.lower(string.sub(Player[playerColor].steam_name, -1)) == 's' then
          steamName = Player[playerColor].steam_name .. "'"
        else 
          steamName = Player[playerColor].steam_name .. "'s"
        end
        objectName = string.gsub(objectName, subStringToChange, steamName)
        playerObject.setName(objectName)
      end

    end
    if meepleMode then
      for _, meeple in pairs(meeples[playerColor]) do
        hideObject(meeple, false)
      end
    end
    if epicMode then
      hideObject(epicTokens[playerColor], false)
    end
    playerSeated[playerColor] = true
  else --when leaving a seat, make all relevant objects invisible
    for playerColor, _ in pairs(playerSeated) do
      if Player[playerColor].seated == false and playerSeated[playerColor] == true then --Check which color was previously occupied
        playerObjects = { playerFigs[playerColor], playerAssistFigs[playerColor], playerDice[playerColor], sexTokens[playerColor], sexCards[playerColor],
			                          equipBonusCounters[playerColor], CpCounters[playerColor], levelCounters[playerColor], infoCards[playerColor] }
        for _, playerObject in pairs(playerObjects) do
          if DEBUG ~= true then
            hideObject(playerObject, true)
          end
          objectName = playerObject.getName()
          i, j = string.find(objectName, "'")
          if i ~= nil then --If string has the character to find
            if string.sub(objectName, i+1, i+1) == 's' then
              subStringToChange = string.sub(objectName, 1, i + 1)
            else
              subStringToChange = string.sub(objectName, 1, i)
            end
            objectName = string.gsub(objectName, subStringToChange, playerColor .. "'s")
            playerObject.setName(objectName)
          end
        end
        if meepleMode then
          for _, meeple in pairs(meeples[playerColor]) do
            hideObject(meeple, true)
          end
        end
        if epicMode then
          hideObject(epicTokens[playerColor], true)
        end
        playerSeated[playerColor] = false
      end
    end
  end
end --onPlayerChangeColor

function onChat()
--  local handZone = playerHandZones['Blue']
--  local customData = handZone.getCustomObject()
--  local color = handZone.getColorTint()
--  print('fog ', handZone.getData()["FogColor"])
--  print(Color.color)
--  print(Color.color[1]*255, Color.color[2]*255, Color.color[3]*255)
--  print(Color.fromString('Red'))
--  object = getObjectFromGUID('ab2f82')
--  for k, v in pairs(object.getData()) do
--    print('key: ', k)
--    print('value: ', v)
--  end
--  print getColorNameFromObjectColor(handZone)
  --zone = playerHandZones['Red']
  --playerColor = Player.getVar('color')
  --print(zone.getVar('color') == Player.color)
--  print(validDescription('你所有的基地都屬於我們'))

end --onChat