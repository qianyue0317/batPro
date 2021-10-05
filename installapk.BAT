@echo off
setlocal EnableDelayedExpansion

set /a count=0

for /f "skip=1 tokens=1" %%i in ('adb devices') do (
	set /a index=!count!+1
	echo !index!.%%i
	set devices[!count!].value=%%i
	set /a count+=1
)

echo ---------------------

:adbinstall
if !count!==1 (
	adb install %1
) else (
	set /p inputTarget=�������豸���:
	if !inputTarget! GTR  !count!+1  (
		echo ����������
		goto adbinstall
	)
	if !inputTarget! LSS 1 (
		echo ��������С
		goto adbinstall
	)
	set /a tempTarget=!inputTarget!-1
	for /f "delims==. tokens=3" %%i in ('set devices[!tempTarget!]') do (
		echo %%i
		adb -s %%i install %1
	)
	
)
echo ---------------------

pause