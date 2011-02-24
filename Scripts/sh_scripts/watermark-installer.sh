#!/bin/bash
git clone git://github.com/svetlyak40wt/yafotkiuploader.git
sudo cp -rv ./yafotkiuploader/YaFotkiLib /bin/YaFotkiLib
sudo cp -v ./yafotkiuploader/yafotki /bin/yafotki
rm -frv ./yafotkiuploader
rm -frv ./YaFotkiUploader-.tar.bz2
git clone git://github.com/stillru/PersonalPakage.git
sudo cp ./PersonalPakage/watermark /bin/watermark
rm -frv ./PersonalPakage/
sudo nano /bin/watermark
done
