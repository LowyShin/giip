; giip Agent using AHK
; Author : Lowy
; Create at 151108
; Ver 1.51 170313 Lowy
; Skip if main script exist and if not exist, then download
; Ver 1.45 160310 Lowy
; Remove Script of delete Internet Temp File
; Ver 1.33
; for RU original
; if Script Error, click error message and enter
; enable mobile network bug

lwStart:
; Define variables
StringRight, sChkVM, A_ComputerName, 1

; initialize
IfExist, giipAgent-%A_ComputerName%.wsf
{
	; FileDelete, giipAgent-%A_ComputerName%.wsf

	; Start
	Sleep, 3000

	StartPoint:
	; Set system environment
	CoordMode, Pixel, Screen
	CoordMode, Mouse, Screen

	loop{
		; when error, close it
		imagesearch, x, y, 0, 0, a_screenwidth, a_screenheight, ico_err.png
		if errorlevel = 0
		{
			mouseclick, l, x, y
			sleep, 1000
			mouseclick, l, x, y
			sleep, 1000
			Send, {enter}
			sleep, 1000
		}

		run, giipAgent-%A_ComputerName%.wsf
		sleep, 3000

		; when error, close it
		imagesearch, x, y, 0, 0, a_screenwidth, a_screenheight, ico_err.png
		if errorlevel = 0
		{
			mouseclick, l, x, y
			sleep, 1000
			mouseclick, l, x, y
			sleep, 1000
			Send, {enter}
			sleep, 1000
		}
		sleep, 10000

	}
}else{
	;IfNotExist, giipAgent-%A_ComputerName%.wsf
	run, giipAgentDownload.wsf
	sleep, 3000
	goto, lwStart
}
EndPoint:
