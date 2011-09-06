echo "Start converting images."
echo "Step one: Create resized structure"
find . -type d | cpio -pvdm resized > /dev/null
echo "Directory structure created..."
echo "Step two: Converting jpg files to created structure..."
find * -name '*.jpg' -exec  convert '{}' -resize 1000x1000 resized/'{}'.jpg \;
echo "...Done."
echo "Step three: Move resized folder."
mv resized ..
echo "Done! All files resized!"
