# Sombra Zigbee EdgeDriver

SmartThings Edge driver for Sombra Shades.

## Files
- `main.lua` — entrypoint using lazy load.
- `sub_drivers/sombra_shades.lua` — sub-driver with Sombra Shades fingerprint.

## Fingerprint
- Manufacturer: `Sombra Shades`
- Model ID: `SOMBRA/Z-M`

## Notes
- The driver is configured for SmartThings lazy loading via `lazy_load = true`.
- `sub_drivers/sombra_shades.lua` matches devices using the new manufacturer/model fingerprint.
- Level logic: 0% = fully open, 100% = fully closed (inverted from standard convention).

## Packaging
- Added `metadata.lua` to define SmartThings Edge driver metadata.
- Use `./package.sh` to create a deployable package archive named `sombra-zigbee-edge-driver.zip`.

## Tests
- Added a Sombra Shades-focused test case at `drivers/SmartThings/zigbee-window-treatment/src/test/test_zigbee_window_treatment_screen_innovations.lua`.
