-- octa
-- simple drone synthesizer
-- v0.01 @sushi_and_sushi
--
-- octa engine
-- KEY 2 toggle back oscillator
-- KEY 3 toggle next oscillator
-- ENC 3 Volume control for the selected oscillator

engine.name = 'Octa'

local UI = require "ui"

local SCREEN_FRAMERATE = 15
local screen_refresh_metro
local screen_dirty = true

local tabs
local slider = {
    UI.Slider.new(6, 18, 4, 44, 1, 0, 1, {0.84}),
    UI.Slider.new(22, 18, 4, 44, 1, 0, 1, {0.84}),
    UI.Slider.new(38, 18, 4, 44, 1, 0, 1, {0.84}),
    UI.Slider.new(54, 18, 4, 44, 1, 0, 1, {0.84}),
    UI.Slider.new(70, 18, 4, 44, 1, 0, 1, {0.84}),
    UI.Slider.new(86, 18, 4, 44, 1, 0, 1, {0.84}),
    UI.Slider.new(102, 18, 4, 44, 1, 0, 1, {0.84}),
    UI.Slider.new(118, 18, 4, 44, 1, 0, 1, {0.84})
  }

function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end

function assign_param(assign_type, num, value)
  if assign_type == "hz" then
    for i=1,8 do
      if num == i then
        params:set("osc" .. i .. "_hz", midi_to_hz(value))
      end
    end
  elseif assign_type == "amp" then
    for i=1,8 do
      if num == i then
        params:set("osc" .. i .. "_amp", value)
      end
    end
  end
end

function init()
  screen.aa(1)
  
  -- Init UI
  tabs = UI.Tabs.new(1, {1,2,3,4,5,6,7,8})

  for i=1,8 do
    slider[i].active = false
  end

  screen_refresh_metro = metro.init()
  screen_refresh_metro.event = function()
    if screen_dirty then
      screen_dirty = false
      redraw()
    end
  end
  screen_refresh_metro:start(1 / SCREEN_FRAMERATE)
  
  -- parameter
  params:add_separator()
  params:add {type="number", id="cemitone", name="cemitone", min=-64, max=64, default=0,
  action=function(value) engine.cemitone(value) end}
  
  params:add_separator()
  params:add {type="number", id="osc1_hz", name="Osc1 hz", min=0, default=220,
  action=function(value) engine.osc1_hz(value) end}
  params:add_control("osc1_amp", "Osc1 Volume", controlspec.UNIPOLAR)
  params:set_action("osc1_amp", function(value) engine.osc1_amp(value/127) end)
  params:set("osc1_amp", 1)
  --params:add {type="number", id="osc1_type", name="Osc1 Type", min=0, max=3, default=0,
  --action=function(value) engine.osc1_type(value) end}
  
  params:add_separator()
  params:add {type="number", id="osc2_hz", name="Osc2 hz", min=0, default=220,
  action=function(value) engine.osc2_hz(value) end}
  params:add_control("osc2_amp", "Osc2 Volume", controlspec.UNIPOLAR)
  params:set_action("osc2_amp", function(value) engine.osc2_amp(value/127) end)
  params:set("osc2_amp", 1)

  params:add_separator()
  params:add {type="number", id="osc3_hz", name="Osc3 hz", min=0, default=220,
  action=function(value) engine.osc3_hz(value) end}
  params:add_control("osc3_amp", "Osc3 Volume", controlspec.UNIPOLAR)
  params:set_action("osc3_amp", function(value) engine.osc3_amp(value/127) end)
  params:set("osc3_amp", 1)

  params:add_separator()
  params:add {type="number", id="osc4_hz", name="Osc4 hz", min=0, default=220,
  action=function(value) engine.osc4_hz(value) end}
  params:add_control("osc4_amp", "Osc4 Volume", controlspec.UNIPOLAR)
  params:set_action("osc4_amp", function(value) engine.osc4_amp(value/127) end)
  params:set("osc4_amp", 1)

  params:add_separator()
  params:add {type="number", id="osc5_hz", name="Osc5 hz", min=0, default=220,
  action=function(value) engine.osc5_hz(value) end}
  params:add_control("osc5_amp", "Osc5 Volume", controlspec.UNIPOLAR)
  params:set_action("osc5_amp", function(value) engine.osc5_amp(value/127) end)
  params:set("osc5_amp", 1)

  params:add_separator()
  params:add {type="number", id="osc6_hz", name="Osc6 hz", min=0, default=220,
  action=function(value) engine.osc6_hz(value) end}
  params:add_control("osc6_amp", "Osc6 Volume", controlspec.UNIPOLAR)
  params:set_action("osc6_amp", function(value) engine.osc6_amp(value/127) end)
  params:set("osc6_amp", 1)

  params:add_separator()
  params:add {type="number", id="osc7_hz", name="Osc7 hz", min=0, default=220,
  action=function(value) engine.osc7_hz(value) end}
  params:add_control("osc7_amp", "Osc7 Volume", controlspec.UNIPOLAR)
  params:set_action("osc7_amp", function(value) engine.osc7_amp(value/127) end)
  params:set("osc7_amp", 1)

  params:add_separator()
  params:add {type="number", id="osc8_hz", name="Osc8 hz", min=0, default=220,
  action=function(value) engine.osc8_hz(value) end}
  params:add_control("osc8_amp", "Osc8 Volume", controlspec.UNIPOLAR)
  params:set_action("osc8_amp", function(value) engine.osc8_amp(value/127) end)
  params:set("osc8_amp", 1)
  
  -- control settigns
  m = midi.connect(1)

  poly_flag = {0,0,0,0,0,0,0,0}
  note = {60,60,60,60,60,60,60,60}
  sound = {0,0,0,0,0,0,0,0}
  voice = 0
  f = 100
  cemitone = 0
  
  choose_num = {}
  for i = 0, 120 do
    choose_num[i] = 0
  end
  
  m.event = function(data)
    local d = midi.to_msg(data)

    function flag_control(flag_num, note_num)
      if d.type == "note_on" then
        poly_flag[flag_num] = flag_num
        choose_num[note_num] = flag_num
        voice = voice + 1
      elseif d.type == "note_off" then
        poly_flag[flag_num] = 0
        choose_num[note_num] = 0
        voice = voice - 1
      end
    end
    
    for i = 0,120 do
      if d.type == "note_on" and d.note == i then
        print("note " .. i .. " on.")
        if poly_flag[1] == 0 then
          flag_control(1, i)
          assign_param("hz", 1, d.note)
        elseif poly_flag[2] == 0 then
          flag_control(2, i)
          assign_param("hz", 2, d.note)
        elseif poly_flag[3] == 0 then
          flag_control(3, i)
          assign_param("hz", 3, d.note)
        elseif poly_flag[4] == 0 then
          flag_control(4, i)
          assign_param("hz", 4, d.note)
        elseif poly_flag[5] == 0 then
          flag_control(5, i)
          assign_param("hz", 5, d.note)
        elseif poly_flag[6] == 0 then
          flag_control(6, i)
          assign_param("hz", 6, d.note)
        elseif poly_flag[7] == 0 then
          flag_control(7, i)
          assign_param("hz", 7, d.note)
        elseif poly_flag[8] == 0 then
          flag_control(8, i)
          assign_param("hz", 8, d.note)
        end
        tab.print(poly_flag)
        print("choose number " .. choose_num[i])
        print(voice .. " voices.")
      end
      
      if d.type == "note_off" and d.note == i then
        print("note " .. i .. " off.")
        if choose_num[i] == 1 then
          flag_control(1, i)
        elseif choose_num[i] == 2 then
          flag_control(2, i)
        elseif choose_num[i] == 3 then
          flag_control(3, i)
        elseif choose_num[i] == 4 then
          flag_control(4, i)
        elseif choose_num[i] == 5 then
          flag_control(5, i)
        elseif choose_num[i] == 6 then
          flag_control(6, i)
        elseif choose_num[i] == 7 then
          flag_control(7, i)
        elseif choose_num[i] == 8 then
          flag_control(8, i)
        end
        tab.print(poly_flag)
        print("choose number " .. choose_num[i])
        print(voice .. " voices.")
      end
    end
  end
end

function osc_in(path, args, from)
  for i=1,8 do
    if path == "/volume " .. i then
      assign_param("amp", i, args[1])
      slider[i]:set_value(args[1])
    end
    if path == "/hz " .. i then
      assign_param("hz", i, args[1]+cemitone)
    end
    if path == "/pan " .. i then
      engine.set("Pan" .. i .. ".Position", args[1])
      print(args[1])
    end
    if path == "/group_a" and i <= 4 then
      assign_param("amp", i, args[1])
      slider[i]:set_value(args[1])
    end
    if path == "/group_b" and i >= 5 then
      assign_param("amp", i, args[1])
      slider[i]:set_value(args[1])
    end
    if path == "/cemitone" then
      params:set("cemitone", args[1]/2)
    end
  end

  redraw()
end
osc.event = osc_in

-- Encoder input
function enc(n, delta)
  if n == 3 then
    for i=1,8 do
      if tabs.index == i then
        slider[i]:set_value_delta(delta / 127)
        params:delta("osc" .. i .. "_amp", delta)
      end
    end
  end
  
  screen_dirty = true
  redraw()
end

-- Key input
function key(n, z)
  if n == 3 and z == 1 then
    tabs:set_index_delta(1, true)
  elseif n == 2 and z == 1 then
    tabs:set_index_delta(-1, true)
  end
  
  for i=1,8 do
    slider[i].active = tabs.index == i
  end
  
  screen_dirty = true
  redraw()
end


-- Redraw
function redraw()
  screen.clear()
  tabs:redraw()
  
  for i=1,8 do
    slider[i]:redraw()
  end
  
  screen.update()
end
