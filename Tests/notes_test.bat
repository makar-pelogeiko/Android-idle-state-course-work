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
adb shell sh ./sdcard/Download/Test_Android_IDLE/get_battery_stats > Tests\Results\notes\%~1note_before.txt
echo %TIME% > Tests\Results\notes\%~1note_time.txt
:: start Notes app, create new note, tap for printing text 
adb shell "input tap 171 236" && timeout 1
adb shell "input tap 1282 2424" && timeout 1
adb shell "input tap 494 600" && timeout 1
::typing
call:typeFunc
:: save Note, get back to desktop
adb shell "input tap 980 155"^
 " && input keyevent "KEYCODE_BACK""
::get batery info
echo %TIME% >> Tests\Results\notes\%~1note_time.txt
adb shell sh ./sdcard/Download/Test_Android_IDLE/get_battery_stats > Tests\Results\notes\%~1note_after.txt
adb shell dumpsys batterystats > Tests\Results\note\%~1note_batterystats.txt
::adb bugreport Tests\Results\notes\%~1note_bugreport.zip
::close all aps
adb shell input keyevent KEYCODE_APP_SWITCH
adb shell input swipe 760 880 760 0 400
::switch the screen off
adb shell "input keyevent "KEYCODE_POWER""
::battery continue charging
adb shell dumpsys battery reset
goto:eof
 
  :typeFunc
 :: <space>lorem ipsum<space>lorem ipsum<>
 ::about 3 min = 30 in loop
 ::about 1 min = 10 in loop
FOR /L %%i IN (1,1,10) DO adb shell "input tap 760 2441"^
 " && input tap 1330 2050"^
 " && input tap 1242 1800"^
 " && input tap 522 1800"^
 " && input tap 364 1800"^
 " && input tap 1164 2222"^
 " && input tap 760 2441"^
 " && input tap 1080 1800"^
 " && input tap 1365 1800"^
 " && input tap 312 2000"^
 " && input tap 950 1800"^
 " && input tap 1164 2222"^
 " && input tap 760 2441"^
 " && input keyevent "KEYCODE_L" "KEYCODE_O" "KEYCODE_R" "KEYCODE_E" "KEYCODE_M" "KEYCODE_SPACE" "KEYCODE_I" "KEYCODE_P" "KEYCODE_S" "KEYCODE_U" "KEYCODE_M""
goto:eof