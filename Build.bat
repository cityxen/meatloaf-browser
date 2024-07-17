@echo off
echo Build Script: Building %1
php update_revision.php
call genkickass-script.bat -t C64 -o prg_files -m false -s false -l "RETRO_DEV_LIB"
call KickAss.bat mlb.asm

exomizer sfx systrim -o prg_files\\mlb-exo prg_files\\mlb

xcopy prg_files\\mlb.prg x:\\www\\tech.cityxen.net\\html\\m64\\mlb\\mlb.prg /Y
xcopy prg_files\\mlb.d64 x:\\www\\tech.cityxen.net\\html\\m64\\mlb\\mlb.d64 /Y

ftp -s:ftp.u64
