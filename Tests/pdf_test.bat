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
adb shell sh ./sdcard/Download/Test_Android_IDLE/get_battery_stats > Tests\Results\reading\%~1read_before.txt
:: open pdf file to read 
adb shell "input tap 670 236" && timeout 4
:: reading is emulated
call:readerFunc
:: get back to desktop
adb shell input keyevent KEYCODE_HOME
::get batery info
adb shell sh ./sdcard/Download/Test_Android_IDLE/get_battery_stats > Tests\Results\reading\%~1read_after.txt
adb shell dumpsys batterystats > Tests\Results\reading\%~1read_batterystats.txt
::adb bugreport Tests\Results\reading\%~1read_bugreport.zip
::close all aps
adb shell input keyevent KEYCODE_APP_SWITCH
adb shell input swipe 760 880 760 0 400 && timeout 1 && adb shell input swipe 760 880 760 0 400
::switch the screen off
adb shell "input keyevent "KEYCODE_POWER""
::battery continue charging
adb shell dumpsys battery reset
goto:eof

  :readerFunc
  ::34 in loop about 3 min
  ::12 in loop about 1 min
FOR /L %%i IN (1,1,12) DO timeout 5 && adb shell input swipe 1000 2222 1000 750 400
goto:eof