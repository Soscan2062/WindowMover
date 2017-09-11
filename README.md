# WindowMover
AHK script to accurately position windows into predefined areas of the screen.

Instructions:
1. Choose the window positioning.
(Only full screen for first window and split or video split for second is currently supported.)
2. Click on the window titles you want to assign to the positions. 
The order is primary window, top secondary window, bottom secondary window.
3. Click ok.

Known limitations:
* Supports 2 monitors and up to 24 open windows.
* I'm pretty sure a secondary window to the left will cause a problem.

Possible future features (in order of most to least likely):
* Clicking additional windows will just bring them to front.
* Add ability to adjust vid change within window and save it to appdata
* More positions for both primary and secondary
* Hover over button and tool tip will show screen shot of window.
* Possible addition of 3+ window support.
* Possible drag and drop. May be slower to do but interface would feel better.
* Collage view of open windows to pick from instead of list.

Change log:
* V1.01 9/11/17
  * Corrected error with win3 top location
  * Code cleanup 
  * Added bring to front for additional windows
* V1.0 8/23/17
  * Initial push
  * Minor formatting changes
  * Added versioning