mencoder "$1" -ovc xvid -xvidencopts bitrate=480:max_bframes=0 -oac mp3lame -lameopts mode=0:cbr:br=128 -vf-add scale=300:240,expand=320:240 -vf-add harddup -ofps 25.0 -srate 44100 -o "$1.100.avi"
