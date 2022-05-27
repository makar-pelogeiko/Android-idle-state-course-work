cd ..
for /l %%x in (1, 1, 4) do (
   echo %%x itteration
   call :testFunc %%x
)
cd Tests
goto:eof

  :watcherFunc
  ::31 in loop = about 3 min
  ::11 in loop = about 1 min
::FOR /L %%i IN (1,1,11) DO timeout 5 && adb shell input tap 950 1533
adb shell input tap 950 1533 && timeout 3
adb shell input tap 950 1533 && timeout 3
timeout 40
goto:eof

  :testFunc
::battery stop charging
adb shell dumpsys battery unplug
::timeout 6
:: unlock
::adb shell "input keyevent 26"^
:: " && input swipe 550 2263 550 300 500"
adb shell input swipe 550 2263 550 300 500

::start power tutor
adb shell input keyevent KEYCODE_APP_SWITCH
adb shell input tap 790 1200
::start/stop profiler
adb shell input tap 790 1200
::system Viewer
adb shell input tap 790 1650
::start view
adb shell input tap 1180 320
:: get home
adb shell input keyevent KEYCODE_APP_SWITCH
adb shell input keyevent KEYCODE_HOME 

::prepare to experiment
adb shell dumpsys batterystats --reset
adb shell sh ./sdcard/Download/Test_Android_IDLE/get_battery_stats > Tests\Results\watching\%~1watch_before.txt
adb shell sh ./sdcard/Download/Test_Android_IDLE/get_freq_stats > Tests\Results\watching\%~1watch_freq_before.txt
echo %TIME% > Tests\Results\watching\%~1watch_time.txt
:: open pdf file to read 
adb shell "input tap 171 1000"
:: watching is emulated
call :watcherFunc
:: get back to desktop
adb shell input keyevent KEYCODE_HOME
::get batery info
echo %TIME% >> Tests\Results\watching\%~1watch_time.txt
adb shell sh ./sdcard/Download/Test_Android_IDLE/get_battery_stats > Tests\Results\watching\%~1watch_after.txt
adb shell sh ./sdcard/Download/Test_Android_IDLE/get_freq_stats > Tests\Results\watching\%~1watch_freq_after.txt
adb shell dumpsys batterystats > Tests\Results\watching\%~1watch_batterystats.txt
::adb bugreport Tests\Results\watching\%~1watch_bugreport.zip
::close all aps
adb shell input keyevent KEYCODE_APP_SWITCH
adb shell input swipe 760 880 760 0 400 && timeout 1 && adb shell input swipe 760 880 760 0 400

::get info from power tutor
adb shell input tap 790 1200 && timeout 1
adb exec-out screencap -p > Tests\Results\watching\%~1watch_power.png
adb shell input keyevent KEYCODE_BACK
adb shell input tap 790 1200
adb shell input keyevent KEYCODE_APP_SWITCH
adb shell input keyevent KEYCODE_HOME

::switch the screen off
adb shell "input keyevent "KEYCODE_POWER""
::battery continue charging
adb shell dumpsys battery reset
goto:eof 