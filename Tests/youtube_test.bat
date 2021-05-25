cd ..
adb shell svc wifi enable && timeout 20
for /l %%x in (1, 1, 25) do (
   echo %%x itteration
   call :testFunc %%x
)
adb shell svc wifi disable
cd Tests
goto:eof

  :testFunc
::battery stop charging
adb shell dumpsys battery unplug
::timeout 6
:: unlock
::adb shell "input keyevent 26"^
:: " && input swipe 550 2263 550 300 500"
adb shell input swipe 550 2263 550 300 500
::wifi On
::-----
::prepare to experiment
adb shell dumpsys batterystats --reset
adb shell sh ./sdcard/Download/Test_Android_IDLE/get_battery_stats > Tests\Results\youtube\%~1youtube_before.txt
echo %TIME% > Tests\Results\youtube\%~1youtube_time.txt
:: open html file 
adb shell "input tap 450 1900 && input tap 300 1716" && timeout 3
:: open link 
adb shell "input tap 600 360"
:: open full screen 
timeout 7 && adb shell "input tap 600 360 && input tap 1369 816"
:: watching is emulated
call:watcherFunc
:: get back to desktop
adb shell input keyevent KEYCODE_HOME
::get batery info
echo %TIME% >> Tests\Results\youtube\%~1youtube_time.txt
adb shell sh ./sdcard/Download/Test_Android_IDLE/get_battery_stats > Tests\Results\youtube\%~1youtube_after.txt
adb shell dumpsys batterystats > Tests\Results\youtube\%~1youtube_batterystats.txt
::adb bugreport Tests\Results\youtube\%~1youtube_bugreport.zip
::close all aps
adb shell input keyevent KEYCODE_APP_SWITCH
adb shell input swipe 760 880 760 0 400 && timeout 1 && adb shell input swipe 760 880 760 0 400 && timeout 1 && adb shell input swipe 760 880 760 0 400
::switch the screen off
adb shell "input keyevent "KEYCODE_POWER""
::battery continue charging
adb shell dumpsys battery reset
goto:eof

  :watcherFunc
  ::52 in loop = about 3 min
  ::17 in loop = about 1 min
FOR /L %%i IN (1,1,17) DO timeout 3 && adb shell input tap 560 500
goto:eof