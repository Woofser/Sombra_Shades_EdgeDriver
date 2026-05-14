local capabilities = require "st.capabilities"
local log = require "log"

local function device_added(driver, device)
  log.info("Sombra Shades device added: " .. device.id)
  device:send_event(capabilities.windowShade.windowShade.closed())
  device:send_event(capabilities.windowShadeLevel.windowShade.level(100))
end

local function device_init(driver, device)
  log.info("Initializing Sombra Shades device: " .. device.id)
end

local function info_changed(driver, device, event, args)
  log.info("Sombra Shades info changed for device: " .. device.id)
end

local function refresh(driver, device, command)
  log.info("Sombra Shades refresh requested for device: " .. device.id)
  device:send_event(capabilities.refresh.refresh())
end

local function open_shade(driver, device, command)
  log.info("Sombra Shades open command received for device: " .. device.id)
  device:send_event(capabilities.windowShade.windowShade.open())
  device:send_event(capabilities.windowShadeLevel.windowShade.level(0))
end

local function close_shade(driver, device, command)
  log.info("Sombra Shades close command received for device: " .. device.id)
  device:send_event(capabilities.windowShade.windowShade.closed())
  device:send_event(capabilities.windowShadeLevel.windowShade.level(100))
end

local function set_level(driver, device, command)
  local level = command.args.level or 0
  log.info("Sombra Shades setLevel command received: " .. tostring(level))
  device:send_event(capabilities.windowShadeLevel.windowShade.level(level))

  if level == 0 then
    device:send_event(capabilities.windowShade.windowShade.open())
  elseif level == 100 then
    device:send_event(capabilities.windowShade.windowShade.closed())
  else
    device:send_event(capabilities.windowShade.windowShade.partially_open())
  end
end

local function can_handle(driver, device)
  local manufacturer = (device:get_manufacturer() or ""):lower()
  local model = (device:get_model() or ""):lower()
  return manufacturer == "sombra shades" and model == "sombra/z-m"
end

local sombra_shades = {
  NAME = "Sombra Shades",
  lifecycle_handlers = {
    added = device_added,
    init = device_init,
    infoChanged = info_changed
  },
  capability_handlers = {
    [capabilities.windowShade.ID] = {
      [capabilities.windowShade.commands.open.NAME] = open_shade,
      [capabilities.windowShade.commands.close.NAME] = close_shade
    },
    [capabilities.windowShadeLevel.ID] = {
      [capabilities.windowShadeLevel.commands.setLevel.NAME] = set_level
    },
    [capabilities.refresh.ID] = {
      [capabilities.refresh.commands.refresh.NAME] = refresh
    }
  },
  can_handle = can_handle
}

return sombra_shades
