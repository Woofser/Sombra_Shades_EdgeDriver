#!/usr/bin/env bash
set -euo pipefail

PACKAGE_NAME="sombra-zigbee-edge-driver.zip"
rm -f "$PACKAGE_NAME"
zip -r "$PACKAGE_NAME" main.lua metadata.lua README.md package.sh sub_drivers drivers

echo "Created package: $PACKAGE_NAME"
