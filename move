local moves =
{
  [keys.numPad8] = turtle.forward,
  [keys.numPad2] = turtle.back,
  [keys.numPad4] = turtle.turnLeft,
  [keys.numPad6] = turtle.turnRight,
  [keys.numPad1] = turtle.down,
  [keys.numPad7] = turtle.up,
  [keys.numPadDivide] = turtle.dig,
  [keys.numPad3] = turtle.digDown,
  [keys.numPad9] = turtle.digUp,
  [keys.numPadAdd] = turtle.place,
  [keys.numPadEnter] = turtle.placeDown,
  [keys.numPadSubtract] = turtle.placeUp
}

local actions = { { ['repeat'] = 0, ['actions'] = {} } }
local next_repeat = 0

function is_numeric(key)
  return key >= 2 and key <= 11
end

function numeric_value(key)
  if key == 11 then
    return 0
  else 
    return (key-1)
  end
end

function do_repeated(action, number)
  repeats = math.max(number, 1)
  for i=1,repeats do
    action()
  end
end

function do_actions(actionsList)
  for _, action in ipairs(actionsList) do
    action()
  end
end

function add_actions(actionsList, upper_action)
  for _, action in ipairs(actionsList) do
    table.insert(upper_action['actions'], action)
  end
end


while true do
  local event, key = os.pullEvent( "key" ) -- limit os.pullEvent to the 'key' event

  current_action = actions[#actions]
  if(is_numeric(key)) then
    next_repeat = next_repeat * 10 + numeric_value(key)
  elseif (key == keys.leftBracket) then
    table.insert(actions, { ['repeat'] = next_repeat, ['actions'] = {} })
    next_repeat = 0
  elseif (key == keys.rightBracket) then
    if #actions > 1 then
      if #actions == 2 then
        do_repeated( function() do_actions(current_action['actions']) end, current_action['repeat'] )
      elseif #actions > 2 then
        do_repeated( function() add_actions(current_action['actions'], actions[#actions-1]) end, current_action['repeat'] )
      end
      table.remove(actions)
    end
  else
    local func = moves[key]
    if(func) then
      if #actions > 1 then
        do_repeated( function()
          table.insert(current_action['actions'], func)
        end, next_repeat)
      else
        do_repeated( func, next_repeat )
      end
      next_repeat = 0
    end
  end
end
