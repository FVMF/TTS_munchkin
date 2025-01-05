--Munchkin TTS Red
color = 'Red'

function onLoad()
  pos = {19.61, 1.34, -11.95}
  rot = {270, 0, 0}
  -- Set some default values for the die behaviour
  lifespan     = 10            
  spin_speed   = 2            
  rise_speed   = 3
  grow_speed   = 3
  font_size    = 3
  flash_max    = true
  flash_speed  = 0.2 --change color 5 times per second
  log_chat     = true
  roll_active  = false
  rv = self.getRotationValues() or false
end
 
-- Have the onDrop and onRandomise functions trigger our effect
function onDrop(c) 
  trigger(c) 
end

function onRandomize(c) 
  trigger(c) 
end
 
-- Trigger effect - this is the main function which is called when dropped or rolled
function trigger(c) 
  --it's possible to trigger the effect multiple times, before the die stops rolling, so we check and then set a flag to prevent multiple triggers
  if roll_active then return false end
  roll_active = true
  --wait until the dice stops rolling before activating the trigger
  Wait.condition(function()
    --disable flag
    roll_active = false 
    --get the value of the current rotation and assign is to var s
    local s = self.getRotationValue() or false 
    --check we have a valid rotation value to report, if not we exit
    if not s or not rv then 
      log("Dice "..self.guid.." does not have a valid rotation value set! Unable to show roll value.")
      return false
    end
    --get current position of die
    local pos   = self.getPosition() + Vector({0, 1+(font_size/5), 0}) 
    --spawn a TextTool object
      local obj = spawnObject({
      type      = "3DText",
      position  = pos,
    })
    obj.TextTool.setValue(tostring(s))
    obj.TextTool.setFontColor(color)
    obj.TextTool.setFontSize(font_size*24)
    --wait a single frame before continuing, to allow the TextTool object to spawn
    Wait.frames(function()
      --make it non-interactable
      obj.interactable = false
      obj.auto_raise   = false
      --raise TextTool into the air (function is below)
      rise(obj, pos)
      --spin TextTool (function is below)
      spin(obj, {0,spin_speed*18,0})
      --grow TextTool (or shrink, if given a negative value at the top) (function is below)
      grow(obj, font_size*24)
      --print to chat, if enabled
      if log_chat then
        local name = c
        if self.getName() and self.getName() ~= "" then
          name = name.." | "..self.getName()
        end
        printToAll("["..name.."] "..Player[c].steam_name.." rolled a "..s, c)
      end
      --if max value of die is rolled and flash is enabled, trigger flash 
      if flash_max and s==rv[#rv].value then
        flash(self)
        flash(obj)
      end
      --after the length of lifetime has passed, destroy the TextTool object
      Wait.time(function()
        obj.destruct()
        end, lifespan)
    end, 1)
  end, 
  --condition to check for the wait function
  function() return self.resting end, 
  --time to wait for the wait function
  30,
  --function to call if wait time is exceeded
  function()
    log("Timeout exceeded waiting for dice to come to a stop")
    roll_active = false
  end)
end
 
-- below are various utility functions, used by the main function above. they are mostly self-explanatory
function rise(obj, pos)
  if not getObjectFromGUID(obj.guid) then 
    return false 
  end
  obj.setPosition(pos)
  pos[2] = pos[2] + (rise_speed/100)
  Wait.frames(function() rise(obj, pos) end, 1)
end
 
function spin(obj, rot)
  if not getObjectFromGUID(obj.guid) then 
    return false 
  end
  obj.setRotationSmooth(rot, false, true)
  rot[2] = rot[2] + spin_speed
  Wait.time(function() spin(obj, rot) end, 0.005)
end 
 
function grow(obj, font_size)
  if not getObjectFromGUID(obj.guid) then 
    return false 
  end
  obj.TextTool.setFontSize(font_size)
  Wait.time(function() grow(obj, font_size*((grow_speed+100)/100)) end, 0.1)
end
 
function flash(obj, i)
  if not getObjectFromGUID(obj.guid) or (i and i > (1/flash_speed) * lifespan) then 
    return false 
  end
  local c = i or 1
  local col = self.getColorTint()
  if c % 2 == 0 then
    col = randomColor()
  end
  if obj.tag == "3D Text" then
    obj.TextTool.setFontColor(col)
  else
    obj.highlightOn(col, 0.1)
  end
  Wait.time(function() flash(obj, c+1) end, flash_speed)
end
 
function randomColor()
  local r = math.random(0, 255)
  local g = math.random(0, 255)
  local b = math.random(0, 255)
  return {r/255, g/255, b/255}
end

function onPlayerTurn()
  if Player[color].seated == true then
    self.setPositionSmooth(pos, false, false)
    self.setRotationSmooth(rot, false, false)
  end
end --function onPlayerTurn