@echo off

set bin_dir=C:\Users\Miki\AppData\Local\Arduino15\packages\arduino\tools\avr-gcc\5.4.0-atmel3.6.1-arduino2/bin/
set     gpp=%bin_dir%avr-g++
set objcopy=%bin_dir%avr-objcopy
set avrsize=%bin_dir%avr-size
set avrdude=C:\Users\Miki\AppData\Local\Arduino15\packages\arduino\tools\avrdude\6.3.0-arduino14/bin/avrdude

:begin
cls
echo Wut?
echo 1. build
echo 2. upload
echo 3. clean
echo 4. exit
choice /C 1234
if %errorlevel%==1 call :build
if %errorlevel%==2 call :upload
if %errorlevel%==3 call :clean
if %errorlevel%==4 goto :EOF
pause
goto :begin

:clean
    if exist tmp (
        del /Q tmp\*
        rmdir tmp
    )
    if exist bin (
        del /Q bin\*
        rmdir bin
    )
exit /B 0

:build
    @echo on
    if not exist tmp mkdir tmp
    if not exist bin mkdir bin

    %gpp% -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wno-error=narrowing -MMD -flto -mmcu=atmega168 -DF_CPU=8000000L -DARDUINO=10809 -DARDUINO_AVR_PRO -DARDUINO_ARCH_AVR "-IC:\\Users\\Miki\\AppData\\Local\\Arduino15\\packages\\arduino\\hardware\\avr\\1.6.23\\cores\\arduino" "-IC:\\Users\\Miki\\AppData\\Local\\Arduino15\\packages\\arduino\\hardware\\avr\\1.6.23\\variants\\eightanaloginputs" "main.cpp" -o "tmp/main.o"

    %gpp% -w -Os -g -flto -fuse-linker-plugin -Wl,--gc-sections -mmcu=atmega168 -o "tmp/main.elf" "tmp/main.o" "C:\\Users\\Miki\\AppData\\Local\\Temp\\arduino_build_569088/..\\arduino_cache_334928\\core\\core_arduino_avr_pro_cpu_8MHzatmega168_37cdb82ff933feae5b10ce32c5331653.a" "-LC:\\Users\\Miki\\AppData\\Local\\Temp\\arduino_build_569088" -lm

    %objcopy% -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 "tmp/main.elf" "tmp/main.eep"

    %objcopy% -O ihex -R .eeprom "tmp/main.elf" "bin/main.hex"
    REM %avrsize% -A "main.elf"
    @echo off
exit /B 0

:upload
    %avrdude% -CC:\Users\Miki\AppData\Local\Arduino15\packages\arduino\tools\avrdude\6.3.0-arduino14/etc/avrdude.conf -v -patmega168 -carduino -PCOM3 -b19200 -D -Uflash:w:bin/main.hex:i
exit /B 0


