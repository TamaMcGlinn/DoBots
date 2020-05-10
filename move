local moves =
{
  [keys.numPad8] = turtle.forward,
  [keys.numPad2] = turtle.back,
  [keys.numPad4] = turtle.turnLeft,
  [keys.numPad6] = turtle.turnRight,
  [keys.numPad1] = turtle.down,
  [keys.numPad7] = turtle.up,
  [keys.numPad9] = turtle.dig,
  [keys.numPad3] = turtle.digDown,
  [keys.multiply] = turtle.digUp,
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

modem = peripheral.wrap("right")

local arg = { ... }
if(#arg > 1) then
  error("Expected single integer argument on commandline for wireless channel")
end

channel_mapping = { ['baldrick'] = 1, ['darling'] = 2, ['farmer'] = 3 }
if(#arg == 0) then
  channel = channel_mapping[os.getComputerLabel()]
else
  mapped_channel = channel_mapping[arg[1]]
  if mapped_channel then
    channel = mapped_channel
  else
    channel=tonumber(arg[1])
  end
end

modem.open(channel)

function execute_command(key)
  for k,v in pairs(keys) do
    if key == v then
      print(k)
    end
  end

  current_action = actions[#actions]

  if(key == keys.numPad5) then
    turtle.select(next_repeat)
    next_repeat = 0
  elseif(is_numeric(key)) then
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
  end -- if key == ...
end -- function execute_command

local running = true
while running do
  local event, key, senderChannel, 
    replyChannel, message, senderDistance = os.pullEventRaw()

  if event == "terminate" then
    print ("good bye!")
    modem.close(channel)
    running = false
  elseif(event == "modem_message") then
    execute_command(message)
  elseif(event == "key") then
    execute_command(key)
  end
end
