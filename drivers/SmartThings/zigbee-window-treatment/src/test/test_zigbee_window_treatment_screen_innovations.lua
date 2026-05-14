-- test_zigbee_window_treatment_screen_innovations.lua
-- A Sombra Shades-focused test case adapted for the current driver.

local capabilities = require "st.capabilities"
local sombra_shades = require "sub_drivers.sombra_shades"

local function build_test_device()
  local events = {}
  return {
    events = events,
    send_event = function(self, event)
      table.insert(events, event)
    end,
    get_events = function(self)
      return events
    end
  }
end

local function assert_equals(actual, expected, message)
  if actual ~= expected then
    error(message or string.format("Expected %s but got %s", tostring(expected), tostring(actual)))
  end
end

local function find_event(events, capability_id)
  for _, event in ipairs(events) do
    if event.capability == capability_id then
      return event
    end
  end
  return nil
end

local function test_open_shade_sets_level_zero()
  local device = build_test_device()
  local command = {}

  sombra_shades.capability_handlers[capabilities.windowShade.ID][capabilities.windowShade.commands.open.NAME](nil, device, command)

  local events = device:get_events()
  assert_equals(#events, 2, "Expected two events for open command")

  local shade_event = find_event(events, capabilities.windowShade.ID)
  local level_event = find_event(events, capabilities.windowShadeLevel.ID)

  assert_equals(shade_event.value, "open", "Expected shade open event")
  assert_equals(level_event.value, 0, "Expected level 0 when opening")
end

local function test_close_shade_sets_level_hundred()
  local device = build_test_device()
  local command = {}

  sombra_shades.capability_handlers[capabilities.windowShade.ID][capabilities.windowShade.commands.close.NAME](nil, device, command)

  local events = device:get_events()
  assert_equals(#events, 2, "Expected two events for close command")

  local shade_event = find_event(events, capabilities.windowShade.ID)
  local level_event = find_event(events, capabilities.windowShadeLevel.ID)

  assert_equals(shade_event.value, "closed", "Expected shade closed event")
  assert_equals(level_event.value, 100, "Expected level 100 when closing")
end

local function test_set_level_partial_updates_shade()
  local device = build_test_device()
  local command = { args = { level = 50 } }

  sombra_shades.capability_handlers[capabilities.windowShadeLevel.ID][capabilities.windowShadeLevel.commands.setLevel.NAME](nil, device, command)

  local events = device:get_events()
  assert_equals(#events, 2, "Expected two events for setLevel command")

  local level_event = find_event(events, capabilities.windowShadeLevel.ID)
  local shade_event = find_event(events, capabilities.windowShade.ID)

  assert_equals(level_event.value, 50, "Expected level event value to match requested level")
  assert_equals(shade_event.value, "partiallyOpen", "Expected partially open when level is between 0 and 100")
end

local function test_set_level_zero_opens_shade()
  local device = build_test_device()
  local command = { args = { level = 0 } }

  sombra_shades.capability_handlers[capabilities.windowShadeLevel.ID][capabilities.windowShadeLevel.commands.setLevel.NAME](nil, device, command)

  local events = device:get_events()
  local shade_event = find_event(events, capabilities.windowShade.ID)
  local level_event = find_event(events, capabilities.windowShadeLevel.ID)

  assert_equals(shade_event.value, "open", "Expected open when level is 0")
  assert_equals(level_event.value, 0, "Expected level 0 event")
end

local function test_set_level_hundred_closes_shade()
  local device = build_test_device()
  local command = { args = { level = 100 } }

  sombra_shades.capability_handlers[capabilities.windowShadeLevel.ID][capabilities.windowShadeLevel.commands.setLevel.NAME](nil, device, command)

  local events = device:get_events()
  local shade_event = find_event(events, capabilities.windowShade.ID)
  local level_event = find_event(events, capabilities.windowShadeLevel.ID)

  assert_equals(shade_event.value, "closed", "Expected closed when level is 100")
  assert_equals(level_event.value, 100, "Expected level 100 event")
end

local function run_all_tests()
  test_open_shade_sets_level_zero()
  test_close_shade_sets_level_hundred()
  test_set_level_partial_updates_shade()
  test_set_level_zero_opens_shade()
  test_set_level_hundred_closes_shade()
  print("Sombra Shades test suite passed")
end

if not package.loaded["luaunit"] then
  run_all_tests()
end
