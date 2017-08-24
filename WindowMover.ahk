﻿;Version 1.0
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
;~ #NoTrayIcon
#Persistent
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;CoordMode, Mouse, Windows
CoordMode, Pixel, Window
#SingleInstance Force
;~ SetTitleMatchMode 2
SetTitleMatchMode RegEx
DetectHiddenWindows Off
#WinActivateForce
SetControlDelay 1
SetWinDelay 0
SetKeyDelay 50, 5
;SetMouseDelay -1
;SetBatchLines -1
StringCaseSense Off 

;initalize global variables
wh := Object() ;wh = array of window hwnd, location corresponds to c starting at 1
xwin := 412 ;x start loc for window buttons
xguiwin := 700 ;gui width start
winh1 := winh2 := winh3 := "" ;variables to store hwnd of currently selected windows
gosub Startup
return

ButtonOK:
Gui Submit, NoHide
;move windows accordingly
;1 will be maximized on first window
;2 will be top on side window
;3 will be bottom on side window
;coordinates determined by radio selections

;get screen size
SysGet, mCount, 80 ;get monitor count

;manually adjust these for your monitor setup
SysGet, Mon1, Monitor
SysGet, Mon2, Monitor, 1
Mon2Vid := 150
Mon2Split := (Mon2Bottom-Mon2Top)/2
Mon2Width := Mon2Right - Mon2Left

;win1
WinRestore, ahk_id %winh1%
WinMove, ahk_id %winh1%,,0,0
WinMaximize, ahk_id %winh1%
;win2
if (win21=1) { ;fullscreen
    WinRestore, ahk_id %winh2%
    ;~ WinMove, ahk_id %winh2%,,1920,-254
    WinMove, ahk_id %winh2%,,%Mon2Left%, %Mon2Top%
    WinMaximize, ahk_id %winh2%
} else if (win22=1) { ;split, vid on bottom
    WinRestore, ahk_id %winh2%
    ;~ WinMove,  ahk_id %winh2%,,1920,-254, 1050, 990
    Mon2SplitTopHeight := Mon2Split + Mon2Vid
    Mon2SplitBottomTop := Mon2Top + Mon2Split + Mon2Vid
    Mon2SplitBottomHeight := Mon2Split - Mon2Vid
    
    WinMove,  ahk_id %winh2%,, %Mon2Left%, %Mon2Top%, %Mon2Width%, %Mon2SplitTopHeight%
    WinRestore, ahk_id %winh3%
    ;~ WinMove, ahk_id %winh3%,,1920, 736, 1050, 690
    WinMove, ahk_id %winh3%,, %Mon2Left%, %Mon2SplitBottomTop%, %Mon2Width%, %Mon2SplitBottomHeight%
} else if (win23=1) { ;split, even.
    WinRestore, ahk_id %winh2%
    ;~ WinMove,  ahk_id %winh2%,,1920,-254, 1050, 840
    WinMove,  ahk_id %winh2%,, %Mon2Left%, %Mon2Top%, %Mon2Width%, %Mon2Split%
    WinRestore, ahk_id %winh3%
    ;~ WinMove, ahk_id %winh3%,,1920, 586, 1050, 840
    WinMove, ahk_id %winh3%,, %Mon2Left%, %Mon2Split%, %Mon2Width%, %Mon2Split%
} else {
    MsgBox, error occurred.
    ExitApp
}

;anything after the 3 will just be brough to front...hopefully
;~ Loop
;~ {
   ;~ c := 3 + A_Index
   ;~ if (win%c%="") 
      ;~ break
   ;~ winx := win%c%
   ;~ WinRestore,  ahk_id %winx%
   ;~ WinActivate,  ahk_id %winx%
;~ }

WinActivate, ahk_id %winh1%
ExitApp

;reset window assignments and rerun window grabbing
ButtonReset:
Gui Destroy
;reinitalize global variables
wh := Object() ;wh = array of window hwnd, location corresponds to c starting at 1
winh1 := winh2 := winh3 := "" ;variables to store hwnd of currently selected windows
Startup:
;for ease of programming, all new controls should go BELOW the window button creation loop
Gui,Add,Text,x20 y6 w160 h13,1. Choose layout for each monitor
Gui,Add,Text,x404 y6 w140 h13,2. Choose programs to adjust
Gui,Add,Radio,x28 y42 w100 h13 gwin1F vwin11 Checked ,Fullscreen
Gui,Add,Radio,x28 y60 w100 h13 gwin1M vwin12,Middle split
Gui,Add,Radio,x230 y12 w100 h13 gwin2F vwin21 Group Checked,Fullscreen
Gui,Add,Radio,x230 y48 w150 h13 gwin2VV vwin22 Checked,Vertical split, vid on bottom
Gui,Add,Radio,x230 y30 w150 h13 gwin2V vwin23,Vertical split, even
;simulated window positions
Gui,Add,Button,x16 y80 w200 h100 vw1 +Wrap,Window 1
Gui,Add,Button,x228 y66 w100 h200 vw2 +Wrap Hidden,Window 2
Gui,Add,Button,x228 y66 w100 h100 vw2t +Wrap Hidden,Window 2, Top
Gui,Add,Button,x228 y166 w100 h100 vw2b +Wrap Hidden,Window 2, Bottom
Gui,Add,Button,x228 y66 w100 h120 vw2tv +Wrap, Window 2, Top
Gui,Add,Button,x228 y186 w100 h80 vw2bv +Wrap, Window 2, Vid on bottom

Gui,Add,Button,x22 y364 w65 h28,OK
Gui,Add,Button,x88 y364 w65 h28,Cancel

;get all windows and add buttons for each one
c := 1 ; c=loop counter for usable windows
WinGet windows, List,,,^$
Loop %windows%
{
   id := windows%A_Index%
   WinGetTitle wt, ahk_id %id% ;wt = window title
   WinGet, s, style, %wt%
   if !instr(s, "0x94000") ;this style seems to identify if the window actually exists
   {
    if (c>12) ;too many windows, add new row and extend screen
    {
        xwin := 412 + 275 +10
        xguiwin := 700 + 275+ 10
        ywin := 28+(c-1-12)*32
    } else {
        ywin := 28+(c-1)*32
    }
    winlbl := wt
     wh[c] := id
    
     if (StrLen(winlbl)>100) {
        StringLeft, winlbl, winlbl, 100
        Gui,Add,Button,x%xwin% y%ywin% w275 h30 Left 0x400 +Wrap gwin%c%, %winlbl%
    } else {
        Gui,Add,Button,x%xwin% y%ywin% w275 h30 +Wrap gwin%c%, %winlbl%
    }
    c += 1
   }
}

Gui,Add,Button,x154 y364 w65 h28,Reset

Gui,Show,w%xguiwin% h450,Created with GUI Creator by maestrith
return

;move the boxes around to illustrate window positioning
win1F:
Gui Submit, NoHide
GuiControl, Show, w1
return
win1M:
Gui Submit, NoHide
GuiControl, Hide, w1
return
win2F:
Gui Submit, NoHide
GuiControl, Show, w2
GuiControl, Hide, w2t
GuiControl, Hide, w2b
GuiControl, Hide, w2tv
GuiControl, Hide, w2bv
return
win2V:
Gui Submit, NoHide
GuiControl, Hide, w2
GuiControl, Show, w2t
GuiControl, Show, w2b
GuiControl, Hide, w2tv
GuiControl, Hide, w2bv
return
win2VV:
Gui Submit, NoHide
GuiControl, Hide, w2
GuiControl, Hide, w2t
GuiControl, Hide, w2b
GuiControl, Show, w2tv
GuiControl, Show, w2bv
return
;window click commands
win1:
win2:
win3:
win4:
win5:
win6:
win7:
win8:
win9:
win10:
win11:
win12:
win13:
win14:
win15:
win16:
win17:
win18:
win19:
win20:
win21:
win22:
win23:
win24:
win25:
MouseGetPos, , , , winButton
;###########################################################
;this can change due to other gui controls being added in later
StringReplace, winBNum, winButton, Button ;buttosn start at 14 due to where they're input in the gui
ControlGetText, winTitle, %winButton%
winhwnd := wh[winBNum-13]
if (winh1="") {
    winh1 := winhwnd
    GuiControl, , w1, %winTitle%
} else if (winh2="") {
    winh2 := winhwnd
    GuiControl, , w2t, %winTitle%
    GuiControl, , w2tv, %winTitle%
} else if (winh3="") {
    winh3 := winhwnd
GuiControl, , w2b, %winTitle%
GuiControl, , w2bv, %winTitle%
} else { ;these are windows to just bring to front
    MsgBox, add bring to front later
}
Gui Submit, NoHide
return

ButtonCancel:
GuiEscape:
GuiClose:
ExitApp

