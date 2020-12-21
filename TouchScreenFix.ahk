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
    
    DX := LastX - CurX
    DY := LastY - CurY
    Distance := Sqrt((DX * DX) + (DY * DY))
    ShortMovement := (Distance <= 200)
    
    if (CurInTouchMon and not LastInTouchMon and not ShortMovement) {
        ; we just entered the monitor
        ; wait until mouse back up before restoring
        while GetKeyState("LButton")
            Sleep, 10
        MouseMove, LastX, LastY, 0
    }
    
    if (ShortMovement or not CurInTouchMon) {
        LastX := CurX
        LastY := CurY
    }
    
    Sleep, 20
}


