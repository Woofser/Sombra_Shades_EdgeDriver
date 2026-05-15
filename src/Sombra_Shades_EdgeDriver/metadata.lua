local metadata = {
  name = "sombra-zigbee-edge-driver",
  version = "1.0.0",
  description = "SmartThings Edge driver for Sombra Shades.",
  author = "Woofser",
  manufacturer = "Sombra Shades",
  model = "SOMBRA/Z-M",
  driver = "main.lua",
  supported_capabilities = {
    "windowShade",
    "windowShadeLevel",
    "refresh"
  },
  device_fingerprints = {
    {
      manufacturer = "Sombra Shades",
      model = "SOMBRA/Z-M"
    }
  }
}

return metadata
