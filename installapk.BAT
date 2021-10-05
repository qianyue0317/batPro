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
	adb install -t -d -r %1
) else (
	set /p inputTarget=请输入设备序号:
	if !inputTarget! GTR  !count!+1  (
		echo 编号输入过大
		goto adbinstall
	)
	if !inputTarget! LSS 1 (
		echo 编号输入过小
		goto adbinstall
	)
	set /a tempTarget=!inputTarget!-1
	for /f "delims==. tokens=3" %%i in ('set devices[!tempTarget!]') do (
		echo %%i
		adb -s %%i install -t -d -r %1
	)
	
)
echo ---------------------

pause
