cd ..
for /l %%x in (1, 1, 4) do (
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
adb shell sh ./sdcard/Download/Test_Android_IDLE/get_battery_stats > Tests\Results\gaming\%~1game_before.txt
adb shell sh ./sdcard/Download/Test_Android_IDLE/get_freq_stats > Tests\Results\gaming\%~1game_freq_before.txt
echo %TIME% > Tests\Results\gaming\%~1game_time.txt
:: open game to play 
adb shell "input tap 735 1063"
:: wait for loading
timeout 16
:: playing is emulated
call:playerFunc
:: get back to desktop
adb shell input keyevent KEYCODE_HOME
::get batery info
echo %TIME% >> Tests\Results\gaming\%~1game_time.txt
adb shell sh ./sdcard/Download/Test_Android_IDLE/get_battery_stats > Tests\Results\gaming\%~1game_after.txt
adb shell sh ./sdcard/Download/Test_Android_IDLE/get_freq_stats > Tests\Results\gaming\%~1game_freq_after.txt
adb shell dumpsys batterystats > Tests\Results\gaming\%~1game_batterystats.txt
::adb bugreport Tests\Results\gaming\%~1game_bugreport.zip
::close all aps
adb shell input keyevent KEYCODE_APP_SWITCH
adb shell input swipe 760 880 760 0 400

::get info from power tutor
adb shell input tap 790 1200 && timeout 1
adb exec-out screencap -p > Tests\Results\gaming\%~1game_power.png
adb shell input keyevent KEYCODE_BACK
adb shell input tap 790 1200
adb shell input keyevent KEYCODE_APP_SWITCH
adb shell input keyevent KEYCODE_HOME

::switch the screen off
adb shell "input keyevent "KEYCODE_POWER""
::battery continue charging
adb shell dumpsys battery reset
goto:eof

::1800 in cycle = 1 hour
::90 in cycle = 3 min
::30 in cycle = 1 min
  :playerFunc
  ::first game
  adb shell "input tap 750 1580"
FOR /L %%i IN (1,1,30) DO timeout 1 && adb shell input swipe 618 1900 735 1820 1000