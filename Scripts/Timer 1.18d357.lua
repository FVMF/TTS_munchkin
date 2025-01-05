---Digital Clock Bottom
function onLoad()
  HIDING_HEIGHT_BUTTON = -50
  SHOWING_HEIGHT_BUTTON = -0.17
  sideTableArea = getObjectFromGUID('3c4625')
  deckZones = Global.getTable('deckZones')
  playerHandZones = Global.getTable('playerHandZones')
  secondHandZones = Global.getTable('secondHandZones')
  sideDeckBoxes = Global.getTable('sideDeckBoxes')
  textObjects = Global.getTable('textObjects')
  topClock = getObjectFromGUID("67a2fc")
  drawFromBottomOffset = { ['Red'] = 1, ['Orange'] = 1, ['Yellow'] = 1, ['Green'] = 1, ['Blue'] = 1, ['Purple'] = 1 }
  self.Clock.showCurrentTime() --in case I forget to set current time before saving
  topClock.Clock.showCurrentTime()
  noteCard = getObjectFromGUID('1befa1')
  
  doorDeck = nil
  treasDeck = nil
  drawBottomTreasure = false
  drawBottomDoor = false
  butVars() --set button variables
  --Buttons are 0 indexed!
                                 --[1] == click_function, [2] == label, [3] == position
  buttonsInfo = { --[[index 0]]  { 'lootRoom', 'Loot the\nRoom', {1.50, 0.80, -0.17} },
                  --[[index 1]]  { 'kickDoor', 'Kick Open\nthe Door', {1.03, 0.80, -0.17} },
                  --[[index 2]]  { 'treasureFaceDown', 'Face Down\nTreasure', {-1.03, 0.80, -0.17} },
                  --[[index 3]]  { 'treasureFaceUp', 'Face Up\nTreasure', {-1.50, 0.80, -0.17} },
                  --[[index 4]]  { 'cleanUp', 'Cleanup\nCards', {1.03, 0.40, -0.17} }, 
                  --[[index 5]]  { 'dealEightToMe', 'Deal 8\nCards to Me', {-1.03, 0.40, -0.17} },
                  --[[index 6]]  { 'startTheGame', 'Start the\ngame', {0, 1.60, -0.17} },
                  --[[index 7]]  { 'fightBoss', 'Fight a\nBoss', {4.8, -2.15, -0.17} },
                  --[[index 8]]  { 'drawFairyDust', 'Draw Fairy\nDust card', {5.3, -2.15, -0.17} },
                  --[[index 9]]  { 'drawMunchkinomicon', 'Draw Spell\ncard', {5.85, -2.15, -0.17} }, 
                  --[[index 10]] { 'drawSideQuest', 'Draw Side\nQuests card', {6.35, -2.15, -0.17} },
                  --[[index 11]] { 'listenDoor', 'Listen at\nthe Door', {1.03, 0.80, -0.17} },
                  --[[index 12]] { 'timerTenS', '10s', {-0.55, 0.20, -0.17} }, 
                  --[[index 13]] { 'timerTenS', '10s', {0.55, 2.78, -0.17} },
                }
  
  for i, buttonParams in ipairs(buttonsInfo) do
    local params = {
       click_function = buttonParams[1],
       function_owner = self,
       label = buttonParams[2],
       position = buttonParams[3],
       rotation = { 90,180,0 },
       width = 240,
       height = 200,
       hover_color = { r=1.0, b=0.5, g=0.5 },
       press_color = { r=1, b=0, g=0 },
       font_size = 43,
       }
    --Buttonindexes start at 0, ipairs index (i) starts at 1
    local buttonIndex = i - 1
    --The cleanUp function is defined in Global
    if buttonIndex == 4 then
      params.function_owner = Global
    end
    --The two timesTenS buttons have different settings
    if buttonIndex >= 12 then
      params.width = 100
      params.height = 100
      if buttonIndex == 13 then
        params.rotation = {90,0,0}
      end
    end
    self.createButton(params)
  end
  --Hide all buttons except for the button to start the game
  for i = 0, 13, 1 do
    if i ~= 6 then 
      changeButtonHeight(i, HIDING_HEIGHT_BUTTON)
    end
  end
end --onLoad()

--Test code for drawing cards from bottom (for Door and Treasure decks)
function toggleFunction(params)
  print(params.player.color)
  if params.id == "Draw bottom treasure deck" then
    if params.isOn == "True" then
      drawBottomTreasure = true
    elseif params.isOn == "False" then
      drawBottomTreasure = false
    end
  elseif params.id == "Draw bottom door deck" then 
    if params.isOn == "True" then 
      drawBottomDoor = true
    elseif params.isOn == "False" then
      drawBottomDoor = false
    end
  end
--  print("Door check: ", drawBottomDoor) 
--  print("Treasure check: ", drawBottomTreasure)
end --toggleFunction

function timerTenS()
  self.setValue(11)
  self.Clock.pauseStart()
  topClock.setValue(11)
  topClock.Clock.pauseStart()
  broadcastToAll('10 second timer started', {r=1, b=0, g=0})
  changeButtonHeight(12, HIDING_HEIGHT_BUTTON)
  changeButtonHeight(13, HIDING_HEIGHT_BUTTON)
  Wait.time(
    function()
      self.Clock.showCurrentTime()
      topClock.Clock.showCurrentTime()
      changeButtonHeight(12, SHOWING_HEIGHT_BUTTON)
      changeButtonHeight(13, SHOWING_HEIGHT_BUTTON)
    end,
    12)  
end --timerTenS

--Makes sure that a card drawn from a deck with takeObject() will be dealt to the rightmost position of the hand zone
function customDeal(deck, playerColor, handZone, fromBottom)
  if fromBottom == true then
    card = deck.takeObject({position = { 0,0,0 }, top = false, flip = true})
  else
    card = deck.takeObject({position = { 0,0,0 }, top = true, flip = true})
  end
  handZonePos = handZone.getPosition()
  rot = deck.getRotation()
  rot[2] = rot[2] + handZone.getRotation()[2]
  rot[3] = 0
  numberCardsInZone = #handZone.getObjects()
  if numberCardsInZone > 0 then
    rightMostCard = handZone.getObjects()[numberCardsInZone]
    rightMostCardPos = rightMostCard.getPosition()
    posRight = rightMostCard.positionToLocal(rightMostCardPos)
    posRight[3] = posRight[3] + drawFromBottomOffset[playerColor]
    posRight = rightMostCard.positionToWorld(posRight)
  else
    posRight = handZonePos
  end
  card.setPosition(posRight)
  card.setRotation(rot)     
end --customDeal

function lootRoom(clicked_object, clicker)
  if Global.getVar('fasterPlayMode') == true then --with Faster Play rules, loot the room draws from the treasure deck
    deck = findDeck(deckZones["Treasure Deck"])
  else
    deck = findDeck(deckZones["Door Deck"])
  end
  if deck == nil then
    print("[ff0000]----  "..Player[clicker].steam_name..", there's no deck to loot from!  ----[-]") --prints to only host
    if Player[clicker].host == false then 
      printToColor("----  "..Player[clicker].steam_name.. ", there's no loot to loot!  ----", clicker, {r=1, b=0, g=0}) 
    end --prints to button presser if they aren't host
  elseif looting < 3 then
    if looting == 0 then broadcastToAll(Player[clicker].steam_name.. " is looting the room!", clicker) end
    if looting == 1 then broadcastToAll(Player[clicker].steam_name.. " is looting the room! Again...", clicker) end
    if looting == 2 then broadcastToAll(Player[clicker].steam_name.. " continues to loot the room...", clicker) end
    if drawBottomDoor then
      customDeal(deck, clicker, playerHandZones[clicker], true)
    else 
      deck.dealToColor(1, clicker)
    end
    looting = looting + 1
    checkLastCard(deck, deckZones["Door Deck"], deckZones["Door Discard"])
  elseif looting == 3 then
    looting = 4 --disables button until next turn
    print('[ff0000]----  Loot the Room! button has been hit 3 times and is now disabled until End Turn is pressed.  ----[-]')
    if Player[clicker].host == false then printToColor("----  "..Player[clicker].steam_name.. ", you've looted all you can loot this turn.  ----", clicker, {r=1, b=0, g=0}) end
  end
end --lootRoom

function listenDoor(clicked_object, clicker)
  doorDeck = findDeck(deckZones["Door Deck"])
  bossesDeck = findDeck(deckZones["Bosses"])
  if doorDeck == nil then
    print("[ff0000]----  "..Player[clicker].steam_name.. ", there's no Door deck!  ----[-]")
    if Player[clicker].host == false then 
      printToColor ("----  "..Player[clicker].steam_name.. ", how are you going to listen at the door if there isn't one???  ----", clicker, {r=1, b=0, g=0}) 
    end
  else
    doorDeck.dealToColor(1, clicker)
    checkLastCard(doorDeck, deckZones["Door Deck"], deckZones["Door Discard"])
    changeButtonHeight(11, HIDING_HEIGHT_BUTTON) --Hide listen at the door button
    changeButtonHeight(1, SHOWING_HEIGHT_BUTTON) --Show kick the door button
    if bossesDeck ~= nil then
      changeButtonHeight(7, SHOWING_HEIGHT_BUTTON) --Show fight the boss button
    end
  end  
end --listenDoor

function kickDoor(clicked_object, clicker)
  doorDeck = findDeck(deckZones["Door Deck"])
  bossesDeck = findDeck(deckZones["Bosses"])
  if doorDeck == nil then
    print("[ff0000]----  "..Player[clicker].steam_name.. ", there's no Door deck!  ----[-]")
    if Player[clicker].host == false then 
      printToColor ("----  "..Player[clicker].steam_name.. ", how are you going to kick the door if there isn't one???  ----", clicker, {r=1, b=0, g=0}) 
    end
  elseif kicking < 5 then
    if kicking == 0 then
      changeButtonHeight(0, SHOWING_HEIGHT_BUTTON) --After clicking kick the door button for the first time, show loot the room button
    end
    if kicking >= 0 and Global.getTable('sideDeckObjects')['Bosses'] ~= '' then --Hide fight a boss button when clicking this button 
      changeButtonHeight(7, HIDING_HEIGHT_BUTTON)
    end
    KickDoorRoll(clicker) --broadcast a kick the door down string based on a random # between 1-20
    if Global.getTable('epicBool')[clicker] == true then
      numberOfCards = 2 --flip open 2 door cards
    else
      numberOfCards = 1 --flip open 1 door card
    end
    for i=1, numberOfCards do

      local faceup = {}
      faceup.position = {-1.5 + kickPos, 1.5, 0.0}
      faceup.flip = true
      doorDeck.takeObject(faceup)
      checkLastCard(doorDeck, deckZones["Door Deck"], deckZones["Door Discard"])
      kicking = kicking + 1
      kickPos = kickPos - 2.25

    end
  elseif kicking == 5 then
    kicking = 6
    print('[ff0000]----  Kick the Door! button has been hit 5 times and is now disabled until End Turn is pressed.  ----[-]')
    if Player[clicker].host == false then printToColor("----  "..Player[clicker].steam_name..", I think that's enough door kicking this turn.  ----", clicker, {r=1, b=0, g=0}) end
  end
end --kickDoor

function treasureFaceDown(clicked_object, clicker)
  local plural = nil
  treasDeck = findDeck(deckZones["Treasure Deck"])
  if treasDeck == nil then
    print("[ff0000]----  "..Player[clicker].steam_name..", there's no Treasure deck!  ----[-]")
    if Player[clicker].host == false then 
      printToColor ("----  "..Player[clicker].steam_name..", there are no treasures to take!  ----", clicker, {r=1, b=0, g=0})
    end
  elseif treasDown < 21 then
    if treasDown == 1 then
      broadcastToAll(Player[clicker].steam_name.." drew "..treasDown.." treasure", clicker)
    else
      broadcastToAll(Player[clicker].steam_name.." drew "..treasDown.." treasures", clicker) --add plural
    end
    if drawBottomTreasure then
      customDeal(treasDeck, clicker, playerHandZones[clicker], true)
    else 
      treasDeck.dealToColor(1, clicker)
    end
    treasDown = treasDown + 1
    checkLastCard(treasDeck, deckZones["Treasure Deck"], deckZones["Treasure Discard"]) 
    if treasDown == 21 then
      treasDown = 22
      print("[ff0000]----  "..Player[clicker].steam_name..", Face Down Treasure button has been hit 20 times and is now disabled until End Turn is pressed.  ----[-]")
      if Player[clicker].host == false then printToColor("----  "..Player[clicker].steam_name..", that's enough treasure for this turn.  ----", clicker, {r=1, b=0, g=0}) end
    end
  end
end --treasureFaceDown

function moveObjectUp(object, distance)
  object.setPosition(object.getPosition():setAt('y', distance))
end --moveObjectUp

function treasureFaceUp(clicked_object, clicker)
  treasDeck = findDeck(deckZones["Treasure Deck"])
  if treasDeck != nil then
    drawTreasures(clicker)
  else
    print("[ff0000]----  "..Player[clicker].steam_name..", there's no Treasure deck!  ----[-]")
    if Player[clicker].host == false then 
      printToColor ("----  "..Player[clicker].steam_name..", you can't find any treasure  ----", clicker, {r=1, b=0, g=0})
    end
  end
end --treasureFaceUp

function changeButtonHeight(index, height)
  for i, button in ipairs(self.getButtons()) do
    if i == index+1 then
      currentPos = button.position
    end
  end
  self.editButton({index = index, position = currentPos:setAt('z', height)})
end --changeButtonHeight

function takeCardFromBox(cardName, box)
  for _, containedObject in ipairs(box.getObjects()) do
    if containedObject.name == cardName then
      card = box.takeObject({index = containedObject.index})
      return card
    end
  end 
end --takeCardFromBox

function putCardOnTopOfDeck(card, deck)
  Wait.frames(function() moveCardsAboveDeck(card, deck) end)
  card.setRotation(deck.getRotation())
end --putCardOnTopOfDeck

function startTheGame(clicked_object, clicker)
  decks = {['doorDeck'] = findDeck(deckZones["Door Deck"]), ['treasDeck'] = findDeck(deckZones["Treasure Deck"]), ['bossesDeck'] = findDeck(deckZones["Bosses"]), ['fairyDustDeck'] = findDeck(deckZones["Fairy Dust"]), ['munchkinomiconDeck'] = findDeck(deckZones["Munchkinomicon"]), ['sideQuestsDeck'] = findDeck(deckZones["Side Quests"])}
  if(decks['doorDeck'] == nil and decks['treasDeck'] == nil) then
    print("[ff0000]----  "..Player[clicker].steam_name..", the Door Deck and Treasure Deck are missing  ----[-]")
    Player[clicker].pingTable(deckZones["Door Deck"].getPosition())
    Player[clicker].pingTable(deckZones["Treasure Deck"].getPosition())
  elseif decks['doorDeck'] == nil then
    print("[ff0000]----  "..Player[clicker].steam_name..", the Door Deck is missing  ----[-]")
    Player[clicker].pingTable(deckZones["Door Deck"].getPosition())
  elseif decks['treasDeck'] == nil then
    print("[ff0000]----  "..Player[clicker].steam_name..", the Treasure Deck is missing  ----[-]")
    Player[clicker].pingTable(deckZones["Treasure Deck"].getPosition())
  else
    Global.setVar('gameStarted', true)
    --Delete all sidetables and their contents
    for _, object in ipairs(sideTableArea.getObjects()) do
      object.destruct()
    end
    --Delete all 3D textobjects
    for _, textObject in pairs(textObjects) do
      textObject.destruct()
    end
    --Show all buttons except lootroom button
    for i = 1, 13, 1 do
      changeButtonHeight(i, SHOWING_HEIGHT_BUTTON)
    end
    changeButtonHeight(6, HIDING_HEIGHT_BUTTON) --Hide start the game button
    if Global.getVar('fasterPlayMode') == true then
      changeButtonHeight(1, HIDING_HEIGHT_BUTTON) --Show listen at the door button instead of kick the door button
    else
      changeButtonHeight(11, HIDING_HEIGHT_BUTTON) --Show kick the door button and hide listen at the door button
    end
    --Hide the buttons of the side decks that are not used
    local sideDecks = Global.getTable('sideDeckObjects')
    local i = 1
    for key, value in pairs(sideDecks) do
      if value == '' then
        changeButtonHeight(i+6, HIDING_HEIGHT_BUTTON)
      end
      i = i + 1
    end
    --Remove checkboxes for game options
    UI.hide('Epic Munchkin')
    UI.hide('Bosses')
    UI.hide('Fairy Dust')
    UI.hide('Munchkinomicon')
    UI.hide('Munchkin Meeples')
    UI.hide('Faster Play')
    UI.hide('Txt Munchkin Meeples')
    UI.hide('Txt Rules')
    UI.hide('Txt Side Decks')
    UI.hide('Topbar')
    UI.hide('Window')
    Turns.enable = true
    --Shuffle all decks
    for _, deck in pairs(decks) do
      if deck != nil then
        deck.shuffle()
      end
    end
    --Deal 8 cards to all seated players
    for _, playerColor in ipairs(getSeatedPlayers()) do
      decks['treasDeck'].dealToColor(4, playerColor)
      decks['doorDeck'].dealToColor(4, playerColor)
      broadcastToAll(Player[playerColor].steam_name.." drew a starting hand!", playerColor)
    end
    --Deal 3 Side Quests cards to all players when playing with Side Quests side deck
    if sideDecks['Side Quests'] ~= '' then
      for _, playerColor in ipairs(getSeatedPlayers()) do
        for i = 1, 3, 1 do
          customDeal(sideDecks['Side Quests'], clicker, secondHandZones[clicker], false)
        end
      end
    end
    --Put Munchkinomicon card on top of Treasure deck when playing with Munchkinomicon side deck
    if sideDecks['Munchkinomicon'] ~= '' then
      local deck = findDeck(deckZones['Treasure Deck'])
      local box = sideDeckBoxes['Munchkinomicon']
      local cardName = 'Munchkinomicon'
      card = takeCardFromBox(cardName, box)
      putCardOnTopOfDeck(card, deck)
    end
    --Put Sparkly Good Fairy on top of Door deck when playing with Fairy Dust side deck
    quantityDoorDeck = decks['doorDeck'].getQuantity()
    if sideDecks['Fairy Dust'] ~= '' then
      local deck = findDeck(deckZones['Door Deck'])
      local box = sideDeckBoxes['Fairy Dust']
      local cardName = 'Sparkly Good Fairy'
      card = takeCardFromBox(cardName, box)
      cutNumber = math.ceil(quantityDoorDeck/2)
      newDecks = deck.cut(cutNumber)
      newDecks[2].setPosition(newDecks[1].getPosition():setAt('y', 5))
      newDecks[2].setRotation({ 0,180,180 })
      Wait.frames(function() newDecks[2].putObject(card) newDecks[2].shuffle() end, 5) 
    end
    --Lock all decks on the table
    for _, deck in pairs(decks) do
      if deck != nil then
        --Need some time to get Sparkly Good Fairy and/or Munchkinomicon card in the deck before locking them
        Wait.time(function() deck.lock() end, 1)
      end
    end
  end
end --startTheGame

function putCardInDeck(card)
  local deck = findDeck(deckZones['Treasure Deck'])
  deck.setLock(false)
  deck.putObject(card)
  deck.lock()
end --putCardInDeck

function dealEightToMe(clicked_object, clicker)
  decks = {['doorDeck'] = findDeck(deckZones["Door Deck"]), ['treasDeck'] = findDeck(deckZones["Treasure Deck"])}
  if(decks['doorDeck'] == nil and decks['treasDeck'] == nil) then
    print("[ff0000]----  "..Player[clicker].steam_name..", we've ran out of Door and Treasure Cards  ----[-]")
    Player[clicker].pingTable(deckZones["Door Deck"].getPosition())
    Player[clicker].pingTable(deckZones["Treasure Deck"].getPosition())
  elseif decks['doorDeck'] == nil then
    print("[ff0000]----  "..Player[clicker].steam_name..", we've ran out of Door Cards  ----[-]")
    Player[clicker].pingTable(deckZones["Door Deck"].getPosition())
  elseif decks['treasDeck'] == nil then
    print("[ff0000]----  "..Player[clicker].steam_name..", we've ran out of Treasure Cards  ----[-]")
    Player[clicker].pingTable(deckZones["Treasure Deck"].getPosition())
  elseif #playerHandZones[clicker].getObjects() >= 8 then
    print("[ff0000]----  "..Player[clicker].steam_name..", you already have 8 or more cards in your hand  ----[-]") 
  else
    for i=1, 4, 1 do
      decks['doorDeck'].dealToColor(1, clicker)
      checkLastCard(decks['doorDeck'], deckZones["Door Deck"], deckZones["Door Discard"])
    end
    for i=1, 4, 1 do
      decks['treasDeck'].dealToColor(1, clicker)
      checkLastCard(decks['treasDeck'], deckZones["Treasure Deck"], deckZones["Treasure Discard"])
    end
    broadcastToAll(Player[clicker].steam_name.." drew a starting hand!", clicker)
    local sideDecks = Global.getTable('sideDeckObjects')
    if sideDecks['Side Quests'] ~= '' then
      numberOfSideQuestsCards = #secondHandZones[clicker].getObjects()
      loopTimes = 3 - numberOfSideQuestsCards
      for i = 1, loopTimes, 1 do
        drawSideQuest(clicked_object, clicker)
      end
    end
  end
end --dealEightToMe

function drawTreasures(clicker)
  if treasUp < 20 then
    if treasUp == 10 then --reset Treasure offset
      treasPos = 0
    end
    local params = {
        position = { -10.0 + treasPos, 1.5, 1.8 },
        rotation = { 0, 180, 0 },
        flip = true,
        }
    if treasUp >= 10 then
      params.position[3] = -1.4
    end
    treasDeck.takeObject(params)
    checkLastCard(treasDeck, deckZones["Treasure Deck"], deckZones["Treasure Discard"])
    treasUp = treasUp + 1
    treasPos = treasPos + 2.25
  elseif treasUp == 20 then
    changeButtonHeight(3, HIDING_HEIGHT_BUTTON)
    print("[ff0000]----  "..Player[clicker].steam_name..", Face Up Treasure button has been hit 20 times and is now disabled until End Turn is pressed.  ----[-]")
    if Player[clicker].host == false then printToColor ("----  "..Player[clicker].steam_name..", you've revealed enough treasure this turn!  ----", clicker, {r=1, b=0, g=0}) end
  end --after 20 treasures end turn must be clicked to reset
end --drawTreasures

function fightBoss(clicked_object, clicker)
  local deck = findDeck(deckZones["Bosses"])
  if deck == nil and Global.getVar('gameStarted') == true then
    broadcastToAll(Player[clicker].steam_name..", we've run out of Bosses cards to draw!  ----[-]", clicker)
    Player[clicker].pingTable(deckZones["Bosses"].getPosition())
  elseif clicker ~= Turns.turn_color then
    broadcastToAll(Player[clicker].steam_name..", it's not your turn pal!  ----[-]", clicker)  
  else
    broadcastToAll(Player[clicker].steam_name.." is looking for a Boss fight!", clicker)
    if deck.tag == 'Deck' then
      local faceup = {}
      faceup.position = {-1.5 + kickPos, 1.5, 0.0}
      faceup.rotation = {0, 180, 0}
      faceup.flip = true
      deck.takeObject(faceup)
      kicking = kicking + 1
      kickPos = kickPos - 2.25
      checkLastCard(deck, deckZones["Bosses"], deckZones["Bosses Discard"])
    elseif deck.tag == 'Card' then --when drawing the last card
      deck.setPositionSmooth({-1.5 + kickPos, 1.5, 0.0}, false, false)
      deck.setRotationSmooth({0, 180, 0}, false, false)
    end
  end
end --fightBoss

function drawFairyDust(clicked_object, clicker)
  local deck = findDeck(deckZones["Fairy Dust"])
  if deck == nil and Global.getVar('gameStarted') == true then
    broadcastToAll(Player[clicker].steam_name..", we've run out of Fairy Dust cards to draw!  ----[-]", clicker)
    Player[clicker].pingTable(deckZones["Fairy Dust"].getPosition())
  else
    deck.dealToColor(1, clicker)
    broadcastToAll(Player[clicker].steam_name.." drew 1 Fairy Dust card.", clicker)
  end
end --drawFairyDust

function drawMunchkinomicon(clicked_object, clicker)
  local deck = findDeck(deckZones["Munchkinomicon"])
  if deck == nil and Global.getVar('gameStarted') == true then
    broadcastToAll(Player[clicker].steam_name..", we've run out of Munchkinomicon cards to draw!  ----[-]", clicker)
    Player[clicker].pingTable(deckZones["Fairy Dust"].getPosition())
  else
    deck.dealToColor(1, clicker)
    broadcastToAll(Player[clicker].steam_name.." drew 1 Munchkinomicon card.", clicker)
    checkLastCard(deck, deckZones["Munchkinomicon"], deckZones["Munchkinomicon Discard"])
  end
end --drawMunchkinomicon

function drawSideQuest(clicked_object, clicker)
  local deck = findDeck(deckZones["Side Quests"])
  if deck == nil and Global.getVar('gameStarted') == true then
    broadcastToAll(Player[clicker].steam_name..", we've run out of Side Quests cards to draw!  ----[-]", clicker)
    Player[clicker].pingTable(deckZones["Fairy Dust"].getPosition())
  elseif #secondHandZones[clicker].getObjects() >= 3 then
    broadcastToAll(Player[clicker].steam_name..", you already have the maximum amount of active Side Quests cards.  ----[-]") 
  else
    deck.deal(1, clicker, 2) -- index 2 deals cards to second hand zone
    broadcastToAll(Player[clicker].steam_name.." drew 1 Munchkin Quests card.", clicker)
 --   customDeal(deck, clicker, secondHandZones[clicker], false)
    checkLastCard(deck, deckZones["Side Quests"], deckZones["Side Quests Discard"])
  end
end --drawSideQuest

function checkLastCard(deck, deckZone, discardZone)
  if deck.remainder != nil then
    lastCard = deck.remainder 
    discardDeck = findDeck(discardZone)
    if discardDeck != nil then
      moveObjectUp(lastCard, 10)
      discardDeck.flip()
      discardDeck.shuffle()
      discardDeck.setPosition(deckZone.getPosition())
    end
  end
end --checkLastCard

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

function onPlayerTurnEnd()
  if Global.getVar('gameStarted') then
    self.Clock.showCurrentTime()
    topClock.Clock.showCurrentTime()
    if Global.getTable('sideDeckObjects')['Bosses'] ~= '' then
      if Global.getVar('fasterPlayMode') == true then
        changeButtonHeight(7, HIDING_HEIGHT_BUTTON) --Hide fight the boss button when using faster play rules
      else
         changeButtonHeight(7, SHOWING_HEIGHT_BUTTON)
      end 
    end
    for i = 0, 3, 1 do
      changeButtonHeight(i, SHOWING_HEIGHT_BUTTON)
    end
    changeButtonHeight(0, HIDING_HEIGHT_BUTTON)
    butVars() --reset button variables at end of turn
    if Global.getVar('fasterPlayMode') == true then
      --Show listen at the door button instead of kick the door button
      changeButtonHeight(1, HIDING_HEIGHT_BUTTON) 
      changeButtonHeight(11, SHOWING_HEIGHT_BUTTON)
    end
  end
end --onPlayerTurnEnd

--function onUpdate()
--  if Turns.enable == false then --if turns are disabled turn off anti-spam variables
--    butVars() --keeps button variables off if turns are off
--  end
--end --onUpdate

function butVars() --set button variables
  doorSpam = false
  looting = 0
  kicking = 0
  kickPos = 0
  treasSpam = false
  treasDown = 1
  treasUp = 0
  treasPos = 0
end --butVars

function KickDoorRoll(clicker) --Player inputs whatever they want onto the card and is printed when the door is kicked down
  if noteCard != nil then
    str = noteCard.getDescription()
    lines = {}
    for s in str:gmatch("[^\n]+") do
      table.insert(lines, s)
    end
    broadcastToAll(Player[clicker].steam_name..lines[math.random(#lines)], clicker)
  else
    broadcastToAll(Player[clicker].steam_name..' is kicking down the door', clicker)
  end
end --KickDoorRoll

function moveCardsAboveDeck(object, deck)
  local quantity = deck.getQuantity()
  local deckHeight = deck.getPosition()['y'] + (quantity/2) * 0.01 
  object.setPosition(deck.getPosition():setAt('y', deckHeight + 0.1))
end --moveCardsAboveDeckk

function onChat()
--  print(#secondHandZones['Red'].getObjects())
--  deck = findDeck(deckZones["Door Deck"])
--  box = sideDeckBoxes['Fairy Dust']
--  for _, containedObject in ipairs(box.getObjects()) do
--    if containedObject.name == 'Sparkly Good Fairy' then
--      card = box.takeObject({index = containedObject.index}) 
--, callback_function = function(obj) obj.setPosition({obj.getPosition().x, obj.getPosition().y + 10, obj.getPosition().x}) obj.setRotation({0,0,180}) moveCardsAboveDeck(obj, deck, 10) end})
--      Wait.frames(function() moveCardsAboveDeck(card, deck, 6) end)
--      card.setRotation({0, 180, 180})
--    end
--  end
--  if deck != nil then
--    newDecks = deck.cut(22)
--  end
--  Global.call('moveCardsAboveDeck', {newDecks[2], newDecks[1], 10})
--  deck = getObjectFromGUID('d1b7af')
--  handZone = getObjectFromGUID('8c44ce')
--  print(#handZone.getObjects())
-- if drawBottomTreasure then
--    if #handZone.getObjects() > 0 then
--      posRight = handZone.getObjects()[#handZone.getObjects()].getPosition()
--      posRight[1] = posRight[1] + 2
--    else
--      posRight = {0, 3.54, -21.48}
--    end
--    card = deck.takeObject({position = posRight, top = false, flip = true})
--  end 
end --onChat