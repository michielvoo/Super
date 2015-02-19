Applies two clipping masks to background layer 1

![screenshot](screenshot.png?raw=true "screenshot")

This program first sets up background layer 1 with a 32 by 32 tilemap using color 1 in palette 0 (blue) and character 1 in the background layer 1 character segment.

Then it sets up the two available windows. First their left and right boundaries are set in `WIN1L`, `WIN1R`, `WIN2L` and `WIN2R`. The both windows are assigned to background layer 1, and their clipping mode is set to clip outside their boundaries (in `W12SEL`).

Before enabling clipping for background layer 1 on the main screen in `TMW`, the combined clipping mode for both windows is set to `AND` in `WBGLOG`. This results in the pattern that is visible in the screenshot.
