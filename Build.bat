@echo off
echo Build Script: Building %1
php update_revision.php
call genkickass-script.bat -t C64 -o prg_files -m false -s false -l "RETRO_DEV_LIB"
call KickAss.bat mlb.asm
exomizer sfx systrim -o prg_files\\mlb-exo prg_files\\mlb
xcopy prg_files\\mlb  prg_files\\mlb.prg /Y
xcopy prg_files\\mlb.prg x:\\www\\html\\m64\\mlb /Y
xcopy prg_files\\mlb.prg x:\\www\\html\\m64\\mlb.prg /Y
xcopy prg_files\\mlb.prg E:\\dev\\github\\cityxen\\meatloaf-specialty\\data\\BUILD_CBM\\mlb.prg /Y
xcopy prg_files\\mlb.prg mlb.prg
ftp -s:ftp.u64
del mlb.prg
