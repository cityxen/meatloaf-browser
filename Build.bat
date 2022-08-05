@echo off
echo Build Script: Building %1
call genkickass-script.bat -t C64 -o prg_files -m false -s false -l "RETRO_DEV_LIB"
call KickAss.bat mlb.asm
copy prg_files\\mlb.spr x:\\www\\html\\m64\\in\\ML.X.SPR
mv prg_files\\mlb.all.prg prg_files\\mlb.prg
exomizer sfx systrim -o prg_files\\mlb-exo.prg prg_files\\mlb.prg
copy prg_files\\mlb-exo.prg x:\\www\\html\\m64\\MLB.PRG
copy prg_files\\mlb-exo.prg E:\\dev\\github\\cityxen\\meatloaf-specialty\\data\\BUILD_CBM\\mlb.prg
copy prg_files\\mlb-exo.prg mlb.prg
ftp -s:ftp.u64
del mlb.prg
