#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance, Force
CoordMode, Mouse, Screen

; get touch monitor position
SysGet, MonCount, MonitorCount
Loop, %MonCount%
{
	SysGet, TouchMon, Monitor, %A_Index%
	Width := TouchMonRight - TouchMonLeft
	Height := TouchMonBottom - TouchMonTop
	if (Width = 1024) && (Height = 600)
		break
}

; loop
MouseGetPos, LastX, LastY
Loop
{
	MouseGetPos, CurX, CurY
    CurInTouchMon := ((CurX >= TouchMonLeft)
                  and (CurX <= TouchMonRight) 
                  and (CurY >= TouchMonTop) 
                  and (CurY <= TouchMonBottom))
    
    LastInTouchMon := ((LastX >= TouchMonLeft)
                   and (LastX <= TouchMonRight) 
                   and (LastY >= TouchMonTop) 
                   and (LastY <= TouchMonBottom))
    
    if (CurInTouchMon and not LastInTouchMon) {
        ; we just entered the monitor
        ; wait until mouse back up before restoring
        while GetKeyState("LButton")
            Sleep, 10
        if (not GetKeyState("Alt"))
            MouseMove, LastX, LastY, 0
    }
    
    if (not CurInTouchMon) {
		LastX := CurX
		LastY := CurY
    }
    
	Sleep, 10
}

^Esc::ExitApp

