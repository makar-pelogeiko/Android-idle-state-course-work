cd ..
for /l %%x in (1, 1, 25) do (
   echo %%x itteration
   call :testFunc %%x
)
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
::prepare to experiment
adb shell dumpsys batterystats --reset
adb shell sh ./sdcard/Download/Test_Android_IDLE/get_battery_stats > Tests\Results\gaming\%~1watch_before.txt
:: open game to play 
adb shell "input tap 735 1063"
:: wait for loading
timeout 16
:: playing is emulated
call:playerFunc
:: get back to desktop
adb shell input keyevent KEYCODE_HOME
::get batery info
adb shell sh ./sdcard/Download/Test_Android_IDLE/get_battery_stats > Tests\Results\gaming\%~1game_after.txt
adb shell dumpsys batterystats > Tests\Results\gaming\%~1game_batterystats.txt
::adb bugreport Tests\Results\gaming\%~1game_bugreport.zip
::close all aps
adb shell input keyevent KEYCODE_APP_SWITCH
adb shell input swipe 760 880 760 0 400
::switch the screen off
adb shell "input keyevent "KEYCODE_POWER""
::battery continue charging
adb shell dumpsys battery reset
goto:eof

::1800 in cycle = 1 hour
::90 in cycle = 3 min
::30 in cycle = 1 min
  :playerFunc
FOR /L %%i IN (1,1,30) DO timeout 1 && adb shell input swipe 2131 1050 2131 1050 1000