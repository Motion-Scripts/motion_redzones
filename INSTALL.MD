# Basic Install Guide
1. Install PolyZone if it isn't already installed https://github.com/mkafrin/PolyZone/releases/latest
2. Download latest release.
3. Add script to your Fivem resources folder.
4. Add `ensure jmhr-redzones` to `server.cfg`
5. Start to config the script
- Add any zones you need in shared/config.lua
- Setup webhooks in shared/server_config.lua
- Setup kill tracking settings in shared/server_config.lua

# If your ambulance or inventory script isn't supported do the following:
1. Set server_config.customInventory to true or server_config.customAmbulance to true (which ever you need)
2. Open bridge/custom_framework.lua and edit the functions.
3. If you know what you're doing, add it to ambulance.lua or inventory.lua then submit a pull request so other users can use your edit.

# Dependencies
ox_lib
PolyZone
(any supported ambulance & inventory script or add a custom one)