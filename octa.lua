-- octa
-- simple drone synthesizer
-- v1.0.0 @sushi_and_sushi
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
  UI.Slider.new(7, 18, 4, 44, 0, 0, 1, {0.84}),
  UI.Slider.new(23, 18, 4, 44, 0, 0, 1, {0.84}),
  UI.Slider.new(38, 18, 4, 44, 0, 0, 1, {0.84}),
  UI.Slider.new(54, 18, 4, 44, 0, 0, 1, {0.84}),
  UI.Slider.new(70, 18, 4, 44, 0, 0, 1, {0.84}),
  UI.Slider.new(86, 18, 4, 44, 0, 0, 1, {0.84}),
  UI.Slider.new(101, 18, 4, 44, 0, 0, 1, {0.84}),
  UI.Slider.new(117, 18, 4, 44, 0, 0, 1, {0.84})
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

function load_hz_list(index, hz_value)
  hz_list = {
    engine.osc1_hz,
    engine.osc2_hz,
    engine.osc3_hz,
    engine.osc4_hz,
    engine.osc5_hz,
    engine.osc6_hz,
    engine.osc7_hz,
    engine.osc8_hz
  }
  hz_list[index](hz_value)
end

function load_amp_list(index, amp_value)
  amp_list = {
    engine.osc1_amp,
    engine.osc2_amp,
    engine.osc3_amp,
    engine.osc4_amp,
    engine.osc5_amp,
    engine.osc6_amp,
    engine.osc7_amp,
    engine.osc8_amp
  }
  amp_list[index](amp_value/63)
end

function init()
  screen.aa(1)

  -- Init UI
  tabs = UI.Tabs.new(1, {1,2,3,4,5,6,7,8})

  for i = 1,8 do
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
  params:add_separator("o c t a")

  params:add {type="number", id="cemitone", name="Cemitone", min=-64, max=64, default=0, action=function(value) engine.cemitone(value) end}

  dest = {"192.168.", 9000} -- init port
  params:add_group("Hz setup",24)
  for i = 1,8 do
    params:add_separator(i)
    params:add {type="number", id="osc"..i.."_hz", name="Osc"..i.." hz", min=0, default=220, action=function(value) load_hz_list(i, value) end}
    params:add_control("osc"..i.."_amp", "Osc"..i.." Volume", controlspec.UNIPOLAR)
    params:set_action("osc"..i.."_amp", function(value)
      load_amp_list(i, value)
      osc.send(dest, "/volume "..i, {value})
      end)
    params:set("osc"..i.."_amp", 0)
  end
    --params:add {type="number", id="osc1_type", name="Osc1 Type", min=0, max=3, default=0,
    --action=function(value) engine.osc1_type(value) end}

  params:add_group("OSC setup",3)
  params:add_text("osc_IP", "OSC IP", "192.168.")
  params:set_action("osc_IP", function() dest = {tostring(params:get("osc_IP")), tonumber(params:get("osc_port"))} end)
  params:add_text("osc_port", "OSC port", "9000")
  params:set_action("osc_port", function() dest = {tostring(params:get("osc_IP")), tonumber(params:get("osc_port"))} end)
  params:add{type = "trigger", id = "refresh_osc", name = "refresh OSC [K3]", action = function()
    params:set("osc_IP","none")
    params:set("osc_port","none")
    osc_communication = false
  end}

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
  if osc_communication ~= true then
    params:set("osc_IP",from[1])
    params:set("osc_port",from[2])
    osc_communication = true
  end

  for i=1,8 do
    if path == "/volume " .. i then
      assign_param("amp", i, args[1])
      slider[i]:set_value(args[1])
    end
    if path == "/hz " .. i then
      assign_param("hz", i, args[1]+cemitone)
    end
    -- if path == "/pan " .. i then
    --   engine.set("Pan" .. i .. ".Position", args[1])
    --   print(args[1])
    -- end
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
