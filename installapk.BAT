@echo off
setlocal EnableDelayedExpansion

set /a count=0

for /f "skip=1 tokens=1" %%i in ('adb devices') do (
	set /a index=!count!+1
	if !index! equ 1 (
		echo 0.在所有的设备上安装
	)
	echo !index!.%%i
	set devices[!count!].value=%%i
	set /a count+=1
)

echo ---------------------

if !count! lss 1 (
	echo 没有找到设备
	goto end
)

:adbinstall
if !count!==1 (
	adb install -t -d -r %1
) else (
	set /p inputTarget=请输入设备序号:
	if !inputTarget! equ 0 (
		goto installForAllDevices
	)
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
goto end

:installForAllDevices
echo 所有的设备上安装
set /a currentIndex=0
:loopDevices
for /f "delims==. tokens=3" %%i in ('set devices[!currentIndex!]') do (
	echo %%i
	adb -s %%i install -t -d -r %1
)

set /a currentIndex=!currentIndex!+1
if !currentIndex! neq !count! (
	goto loopDevices
)	
	
echo ---------------------

:end

pause
