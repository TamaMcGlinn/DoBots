function safeSelect(slot)
  if slot >= 1 and slot <= 16 then
    turtle.select(slot)
  else
    print("error: slot number " .. slot .. " invalid")
    print("enter a slot number between 1-16")
    print("before pressing Select")
  end
end

local begin_loop_key = keys.leftBracket
local end_loop_key = keys.rightBracket
local select_key = keys.numPad5

local moves =
{
  [keys.numPad8] = turtle.forward,
  [keys.numPad2] = turtle.back,
  [keys.numPad4] = turtle.turnLeft,
  [keys.numPad6] = turtle.turnRight,
  [keys.numPad1] = turtle.down,
  [keys.numPad7] = turtle.up,
  [keys.numPad9] = turtle.dig,
  [keys.multiply] = turtle.digUp,
  [keys.numPad3] = turtle.digDown,
  [keys.numPadAdd] = turtle.place,
  [keys.numPadEnter] = turtle.placeDown,
  [keys.numPadSubtract] = turtle.placeUp,
  [select_key] = safeSelect
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

function add_action_bound_to_number(action_table, action, number)
  table.insert(action_table, function ()
    action(number)
  end)
end

function execute_command(key)
  for k,v in pairs(keys) do
    if key == v then
      print(k)
    end
  end

  current_action = actions[#actions]

  if(is_numeric(key)) then
    next_repeat = next_repeat * 10 + numeric_value(key)
  elseif (key == begin_loop_key) then
    table.insert(actions, { ['repeat'] = next_repeat, ['actions'] = {} })
    next_repeat = 0
  elseif (key == end_loop_key) then
    print("endloop")
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
        if key == select_key then
          add_action_bound_to_number(current_action['actions'], func, next_repeat)
        else
          do_repeated( function()
            table.insert(current_action['actions'], func)
          end, next_repeat)
        end
      else
        if key == select_key then
          func (next_repeat)
        else
          do_repeated( func, next_repeat )
        end
      end
      next_repeat = 0
    end
  end -- if key == ...
end -- function execute_command

local running = true
while running do
  local event, key, senderChannel,
    replyChannel, message, senderDistance = os.pullEventRaw()

  if event == "terminate" then
    print ("good bye!")
    running = false
  elseif(event == "key") then
    execute_command(key)
  end
end
