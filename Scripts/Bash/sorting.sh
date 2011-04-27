#!/bin/bash

################################################
#
# Functions
#
################################################

DIR=$(pwd)

Torrents()
{
if [ -e "$DIR/Torrents" ];then
       echo -n ""
else
       mkdir Torrents
fi

mv $DIR/*.torrent "$DIR/Torrents" 
}


Executibls()
{
if [ -e "$DIR/Executibls" ];then
       echo -n ""
else
       mkdir Executibls
fi

mv $DIR/*.exe "$DIR/Executibls" 
}

Music()
{
if [ -e "$DIR/Music" ];then
       echo -n ""
else
       mkdir Music
fi

mv $DIR/*.mp3 "$DIR/Music" 
mv $DIR/*.wav "$DIR/Music" 
mv $DIR/*.midi "$DIR/Music" 
}

Movies()
{
if [ -e "$DIR/Movies" ];then
       echo -n ""
else
       mkdir Movies
fi

mv $DIR/*.avi "$DIR/Movies" 
mv $DIR/*.mpeg "$DIR/Movies" 
mv $DIR/*.mpg "$DIR/Movies" 
}


Pictures()
{
if [ -e "$DIR/Pictures" ];then
       echo -n ""
else
       mkdir Pictures
fi

mv $DIR/*.jpeg "$DIR/Pictures" 
mv $DIR/*.jpg "$DIR/Pictures" 
mv $DIR/*.gif "$DIR/Pictures" 
mv $DIR/*.png "$DIR/Pictures" 
}

Compressed()
{
if [ -e "$DIR/Compressed" ];then
       echo -n ""
else
       mkdir Compressed
fi

mv $DIR/*.zip "$DIR/Compressed" 
mv $DIR/*.rar "$DIR/Compressed" 
mv $DIR/*.7z "$DIR/Compressed" 
mv $DIR/*.tar "$DIR/Compressed" 
mv $DIR/*.tar.bz2 "$DIR/Compressed" 
mv $DIR/*.tar.gz "$DIR/Compressed" 
}

Documents()
{
if [ -e "$DIR/Documents" ];then
       echo -n ""
else
       mkdir Documents
fi

mv $DIR/*.doc "$DIR/Documents" 
mv $DIR/*.docx "$DIR/Documents" 
mv $DIR/*.xsl "$DIR/Documents" 
mv $DIR/*.pdf "$DIR/Documents" 
mv $DIR/*.xlsx "$DIR/Documents" 
mv $DIR/*.txt "$DIR/Documents" 
}

Other()
{
if [ -e "$DIR/Other" ];then
       echo -n ""
else
       mkdir Other
fi

mv $DIR/*.* "$DIR/Other" 
}


################################################
#
# Main Program
#
################################################

Music
Movies
Pictures
Compressed
Documents
Executibls
Torrents
Other
