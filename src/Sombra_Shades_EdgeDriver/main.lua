local Driver = require "st.driver"
local log = require "log"
local sombra_shades = require "sub_drivers.sombra_shades"

local driver = Driver("sombra-zigbee-edge-driver", {
  lazy_load = true,
  sub_drivers = {
    sombra_shades
  }
})

log.info("Starting Sombra Zigbee EdgeDriver driver with lazy load")
driver:run()
