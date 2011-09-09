# Автор - Степан Илличевский
# mailto: still.ru@gmail.com
# 
# Version 0.2.0

echo "Start converting images."
echo "Step one: Create resized structure"
find . -type d | cpio -pvdm resized > /dev/null
echo "Directory structure created..."
echo "Step first: Converting EPS to jpg..."
find * -name '*.eps' -exec gs -sDEVICE=jpeg -dJPEGQ=100 -dNOPAUSE -dBATCH -dEPSFitPage -dSAFER -r300 -sOutputFile='{}'.jpg '{}' \; -print
echo "Step second: Converting tiff files to created structure..."
find * -name '*.tif' -exec  convert '{}' -colorspace RGB '{}'.jpg \; -print
echo "Step last: Converting jpg files to created structure..."
find * -name '*.jpg' -exec  convert '{}' -resize 1000x1000 resized/'{}' \; -print
echo "...Done."
echo "Step three: Move resized folder."
mv resized ..
echo "Done! All files resized!"
