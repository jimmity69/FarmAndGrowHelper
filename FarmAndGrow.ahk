;Farm and Grow Game Hotkeys and reference tool
;9/10/2015 - Robert Foote
;Some code copied directly from AutoHotkey Documentation
;
;I found it frustrating the game speed-control keyboard shortcuts 0,1,2,4 don't work from the numpad (0 is far from 1 on the regular number keys, but on the numpad all 4 keys are adjacent.)
;I wrote this script to remap the numpad keys, so I could use them to send the regular keystrokes.
;
;For use with Farm and Grow Game as found on: http://www.kongregate.com/games/CuriousGaming/farm-and-grow?acomplete=farm#
;
;
#Persistent  ; Keep the script running until the user exits it.
#SingleInstance ; Allow only 1 instance at a time
;#NoTrayIcon ;UNCOMMENT to disable tray menu when compiled to .exe
If (A_IsCompiled)
{
	menu, tray, NoIcon
}
	

;BEGIN Global variables
G_Version = 0.5b
G_ScriptName = Farm & Grow Helper
;StringLeft, G_ScriptName, A_ScriptName, InStr(A_ScriptName, .)-1 ;StrLen(A_ScriptName)-4 ;remove file extension
G_StartX := 690
G_StartY := 30
G_StartW := 550
G_StartH := 300
G_WidthOffset := 20
G_HeightOffset := 15
G_LV_Contents := Object()
;Productivity
G_LV_Contents.Insert([1, "Furrow Plough", "Time to complete field tasks reduced by 30%", 10, 1, 25, 1, 25, "Productivity"]) ;%
G_LV_Contents.Insert([2, "Gardening", "Allows planting of grain", 15, 2, 50, 1, 25, "Productivity"])
G_LV_Contents.Insert([3, "Crop Rotation", "+1 yield for grain and vegetables", 20, 2, 50, 1, 25, "Productivity"])
G_LV_Contents.Insert([4, "Tilling", "Grain and vegetables grow 50% faster", 30, 3, 75, 2, 50, "Productivity"]) ;%
G_LV_Contents.Insert([5, "Fertilizer", "Additional +1 yield for grain and vegetables", 40, 4, 100, 2, 50, "Productivity"])
G_LV_Contents.Insert([6, "Coppicing", "Doubles yield when harvesting wood", 50, 5, 125, 3, 75, "Productivity"])
G_LV_Contents.Insert([7, "", "      Total to complete tree:", 165, 17, 425, 9, 225, "Productivity"])

;Infrastructure 
G_LV_Contents.Insert([1, "Roads", "25% increase to movement speed", 10, 1, 25, 1, 25, "Infrastructure"]) ;% 
G_LV_Contents.Insert([2, "Pastures", "Pastures allow keeping of animals ", 20, 2, 50, 1, 25, "Infrastructure"])
G_LV_Contents.Insert([3, "Windmill", "Building allows milling of grain into flour", 25, 3, 75, 2, 50, "Infrastructure"])
G_LV_Contents.Insert([4, "Bakery", "Allows baking task (flour -> bread) in the house", 30, 3, 75, 2, 50, "Infrastructure"])
G_LV_Contents.Insert([5, "Well", "Health improvement building", 40, 4, 100, 2, 50, "Infrastructure"])
G_LV_Contents.Insert([6, "Brick Oven", "Reduces time taken to bake bread by 50%", 50, 5, 125, 3, 75, "Infrastructure"])  ;%
G_LV_Contents.Insert([7, "", "      Total to complete tree:", 175, 18, 450, 9, 225, "Infrastructure"])

;Enlightenment
G_LV_Contents.Insert([1, "Crafting", "Increase income of town labour to 8 gold", 10, 1, 25, "X", "X", "Enlightenment"])
G_LV_Contents.Insert([2, "Horse & Cart", "More goods available to buy at the market", 15, 2, 50, "X", "X", "Enlightenment"])
G_LV_Contents.Insert([3, "Sanitation", "+1 Health every year. Increases maximum health", 20, 2, 50, "X", "X", "Enlightenment"])
G_LV_Contents.Insert([4, "Bartering", "Better prices at the market", 30, 3, 75, "X", "X", "Enlightenment"])
G_LV_Contents.Insert([5, "Profession", "Increase income of town labour to 15 gold", 40, 4, 100, "X", "X", "Enlightenment"])
G_LV_Contents.Insert([6, "University", "Doubles benefit of school education", 50, 5, 125, "X", "X", "Enlightenment"])
G_LV_Contents.Insert([7, "", "      Total to complete tree:", 165, 17, 425, "XX", "XX", "Enlightenment"])

;END - Global variables

;BEGIN - GUI For game reference information...
;BEGIN - List View example and other code modified from AutoHotkey_L Documentation...
;BEGIN File menu
Menu, FileMenu, Add, Pause Icon, MenuHandler
Menu, FileMenu, Icon, Pause Icon, %A_AhkPath%, -207 ;Use icon with resource identifier 207
Menu, FileMenu, Add, Exit, Exit
If !(A_IsCompiled) ;for testing
{
	Menu, FileMenu, Add,
	;Menu, MySubmenu, Standard
	;Menu, FileMenu, add, AHK_Standard, :MySubmenu
	Menu, FileMenu, Standard
}
Menu, MyMenuBar, Add, &File, :FileMenu
;BEGIN Edit menu
Menu, EditMenu, Add, NULL, MenuHandler
Menu, MyMenuBar, Add, &Edit, :EditMenu
;BEGIN View menu
Menu, ViewMenu, Add, NULL, MenuHandler
Menu, MyMenuBar, Add, &View, :ViewMenu
menu, ViewMenu, Disable, NULL
;BEGIN Help menu
Menu, HelpMenu, Add, About, MenuHandler
Menu, MyMenuBar, Add, &Help, :HelpMenu

Gui, Menu, MyMenuBar
;Gui, +Resize  ; Make the window resizable.
;Gui, Add, Button, gExit, Exit This Example

;BEGIN TABS
TempH := G_StartH - (G_HeightOffset *2)
TempW := G_StartW - (G_WidthOffset *2)
Gui, Add, Tab2, vMyTabView w%TempW% h%TempH%, Skill Tree|Notes|Appearance|Screen Clips|Settings
;BEGIN TAB1 - Skill Tree List View
;xm+10 yp+30
; Create the ListView with two columns, Name and Size:
TempH := TempH - (G_HeightOffset *4.75)
Gui, Add, ListView, vMyListView Grid w380 h%TempH% gMyListView, No|Name|Description|Know|Trips|Gold|TWC|GWC|Category
TempY := G_StartH - (G_HeightOffset *4)
Gui, Add, Button, xm+20 y%TempY% gButton_Handler, All
Gui, Add, Button, x+10 y%TempY% gButton_Handler, Productivity
Gui, Add, Button, x+10 y%TempY% gButton_Handler, Infrastructure
Gui, Add, Button, x+10 y%TempY% gButton_Handler, Enlightenment
;From: http://www.autohotkey.com/board/topic/57768-tabbed-guis-borders/
Gui, Tab, 5
Gui, Add, Checkbox, vMyCheckbox, Sample checkbox 
Gui, Add, Radio, vMyRadio Checked, Sample radio1 
Gui, Add, Radio,, Sample radio2 
Gui, Tab, 2 
Gui, Add, Edit, vMyEdit ;r5  ; r5 means 5 rows tall. 
;Gui, Tab, 4

Gui, +Resize  ; Make the window resizable.
;Gui, Tab,  ; i.e. subsequently-added controls will not belong to the tab control. 
;Gui, Add, Button,vMyButton default xm, OK  ; xm puts it at the bottom left corner. 

/*
; Gather a list of file names from a folder and put them into the ListView:
Loop, %A_MyDocuments%\*.*
    LV_Add("", A_LoopFileName, A_LoopFileSizeKB)

LV_ModifyCol()  ; Auto-size each column to fit its contents.
LV_ModifyCol(2, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.
*/

For index, EachVal in G_LV_Contents
	LV_Add("Test", EachVal[1], EachVal[2], EachVal[3], EachVal[4], EachVal[5], EachVal[6], EachVal[7], EachVal[8], EachVal[9])

LV_ModifyCol()  ; Auto-size each column to fit its contents.
LV_ModifyCol(1, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.


; DISPLAY the window and return. The script will be notified whenever the user double clicks a row.
Gui, +AlwaysOnTop
Gui, Show, x%G_StartX% y%G_StartY%, %G_ScriptName%
gosub EnableKeyMap
return

Button_Handler:
Enlightenment:
;MsgBox A_GuiEvent: %A_GuiControl%

LV_Delete()
For index, EachVal in G_LV_Contents
{
	If (A_GuiControl = "All") or (A_GuiControl = EachVal[9])
		LV_Add("Test", EachVal[1], EachVal[2], EachVal[3], EachVal[4], EachVal[5], EachVal[6], EachVal[7], EachVal[8], EachVal[9])
}
	
	

LV_ModifyCol()  ; Auto-size each column to fit its contents.
LV_ModifyCol(1, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.

Return

MyListView:
if A_GuiEvent = DoubleClick
{
    LV_GetText(RowText, A_EventInfo)  ; Get the text from the row's first field.
    ToolTip You double-clicked row number %A_EventInfo%. Text: "%RowText%"
	sleep, 3000
	Tooltip
}
return

MenuHandler:
MsgBox You selected %A_ThisMenuItem% from menu %A_ThisMenu%.
return


/*
GuiDropFiles:  ; Support drag & drop.
Loop, Parse, A_GuiEvent, `n
{
    SelectedFileName = %A_LoopField%  ; Get the first file only (in case there's more than one).
    break
}
Gosub FileRead
return
*/

GuiSize:
if ErrorLevel = 1  ; The window has been minimized.  No action needed.
    return
; Otherwise, the window has been resized or maximized. Resize the Edit control to match.
WidthOffset := G_WidthOffset
HeightOffset := G_HeightOffset
NewTabsWidth := A_GuiWidth - WidthOffset 
NewTabsHeight := A_GuiHeight - HeightOffset
NewWidth := NewTabsWidth - WidthOffset*.95
NewHeight := NewTabsHeight - HeightOffset*4.5
newY := A_GuiHeight - (G_HeightOffset *2.65)
GuiControl, Move, MyTabView, W%NewTabsWidth% H%NewTabsHeight%
GuiControl, Move, MyListView, W%NewWidth% H%NewHeight%
GuiControl, Move, MyEdit, W%NewWidth% H%NewHeight%
;GuiControl, Move, MyButton , y%newY%
GuiControl, Move, All , y%newY%
GuiControl, Move, Productivity , y%newY%
GuiControl, Move, Infrastructure , y%newY%
GuiControl, Move, Enlightenment , y%newY%
return

GuiClose:  ; Indicate that the script should exit automatically when the window is closed.
Exit:
ExitApp
;END - List View example from AutoHotkey_L Documention...

EnableKeyMap:
;BEGIN - Key mappings
;Default key delays didn't send properly to the game's Flash plug-in, so numpad strokes were unreliable.
;The following line was added to correct this. 
;Different values may be required for different systems.
SetKeyDelay 0, 60

;When I Play Using FireFox on Kongregate.com the title bar reads: Play Farm and Grow, a free online game on Kongregate - Mozilla Firefox 
;The following line limits the remapping behavior to only when a window with a title that starts with "Play Farm and Grow" is the active window
;(without this line this script might produce unexpected results when using the numpad with other applications, because I have set it up to send the appropriate keystrokes regardless of the state of the NUMLOCK state.)
#IfWinActive, Play Farm and Grow
	NumpadIns::
	Numpad0::
	Send 0
	return

	NumpadEnd::
	Numpad1::
	Send 1
	return

	NumpadDown::
	Numpad2::
	Send 2
	return
	
	NumpadLeft::
	Numpad4::
	Send 4
	return

;END - Key mappings
return



	
	
