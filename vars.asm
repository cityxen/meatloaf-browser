////////////////////////////////////////////////////
// Some vars

.const X0_POS = $a0
.const Y0_POS = $80

.const X1_POS = $19
.const Y1_POS = $e4
.const X2_POS = $19
.const Y2_POS = $e4
.const X3_POS = $19
.const Y3_POS = $e4
.const X4_POS = $19
.const Y4_POS = $e4
.const X5_POS = $19
.const Y5_POS = $e4
.const X6_POS = $19
.const Y6_POS = $e4


.encoding "petscii_upper"
drive_text:
.text "dRIVE:"
.byte 0
drive_status_text:
.text "sTATUS:"
.byte 0

.encoding "screencode_mixed"
top_bar_text:
.text "re"
.encoding "petscii_upper"
.text "mEATLOAF bROWSER                 f1-help"
.encoding "screencode_mixed"
.byte 146
.byte 0
load_loading:
.byte 156
.text "LOADING "
.byte 0
dir_presskey_text:
.byte $0d
.byte 150
.text "PRESS ANY KEY"
.byte 0
enter_filename_text:
.byte $0d
.text "ENTER MANUALLY:"
.byte 0
device_not_present_text:
.byte 28
.text "rERROR"
.byte 146
.text "e:"
.byte 28
.text "DEVICE e"
.byte 0
device_not_present_text2:
.byte 28
.text " NOT PRESENT"
.byte $0d
.byte 0
drive_number_text:
.text "0809101112131415161718192021222324252627282930"
drive_number:
.byte 8
filename_length:
.byte 255
filename_buffer: // reserve space for filename buffer
.encoding "screencode_upper"
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
filename1:
.encoding "screencode_upper"
.text "http://ml.cityxen.biz/m64/mlb/ml.1.spr"
.byte 0
filename2:
.text "http://ml.cityxen.biz/m64/mlb/ml.2.spr"
.byte 0
filename3:
.text "http://ml.cityxen.biz/m64/mlb/ml.3.spr"
.byte 0
filename_lan1:
.text "http://10.1.10.200/m64/mlb/ml.1.spr"
.byte 0
filename_lan2:
.text "http://10.1.10.200/m64/mlb/ml.2.spr"
.byte 0
filename_lan3:
.text "http://10.1.10.200/m64/mlb/ml.3.spr"
.byte 0
filename_disk1:
.text "ml.1.spr"
.byte 0
filename_disk2:
.text "ml.2.spr"
.byte 0
filename_disk3:
.text "ml.3.spr"
.byte 0
color_byte:
.byte 1
color_byte_underline:
.byte 1
drive_override_load_address_lo:
.byte $00
drive_override_load_address_hi:
.byte $30
sprite_enable_store:
.byte 0
color_white:
.encoding "screencode_mixed"
.text "e"
.byte 0

