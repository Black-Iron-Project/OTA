DEVICE=$1
TG_USERNAME=$2
DEVICE_NAME=$3
XDA_THREAD=$4
GHUN=$5
NAME=$6
DEVGRP=$7

DATETIME=$(grep "ro.lineage.version" out/target/product/$DEVICE/system/build.prop | cut -d "-" -f 4 )
FILENAME=$(find out/target/product/$DEVICE/Blackiron*.zip | cut -d "/" -f 5)
ID=$(sha256sum out/target/product/$DEVICE/Blackiron*.zip | cut -d " " -f 1)
FILEHASH=$(md5sum out/target/product/$DEVICE/Blackiron*.zip | cut -d " " -f 1)
SIZE=$(wc -c out/target/product/$DEVICE/Blackiron*.zip | awk '{print $1}')
URL="https://sourceforge.net/projects/black-iron-project/files/$DEVICE/$FILENAME/download"
VERSION=$(grep "ro.build.version.release=" out/target/product/$DEVICE/system/build.prop | cut -d "=" -f 2)
STATUS="Active"
BLKIV=$(grep "ro.lineage.version" out/target/product/$DEVICE/system/build.prop | cut -d '-' -f 2 | cut -d "_" -f 1 )
DONATE_URL="http://www.paypal.me/ralf979"
WEBSITE_URL="https://lol.lol/"
NEWS_URL="https://t.me/BlkiUpdate"
DEV_GRP=$DEVGRP
JSON_FMT='{\n\t"error":false,\n\t"filename":"%s",\n\t"datetime":%s,\n\t"size":%s,\n\t"url":"%s",\n\t"filehash":"%s",\n\t"version":"%s",\n\t"status":"%s",\n\t"blkiv":"%s",\n\t"id":"%s",\n\t"tg_username":"%s",\n\t"device_name":"%s",\n\t"device":"%s",\n\t"device_group":"%s",\n\t"xda_thread":"%s",\n\t"maintainers": [{\n\t\t"main_maintainer":false,\n\t\t"github_username":"%s",\n\t\t"name":"%s"\n\t}],\n\t"donate_url":"%s",\n\t"website_url":"%s",\n\t"news_url":"%s",\n\t"forum_url":"%s"\n}'

printf "$JSON_FMT" "$FILENAME" "$DATETIME" "$SIZE" "$URL" "$FILEHASH" "$VERSION" "$STATUS" "$BLKIV" "$ID" "$TG_USERNAME" "$DEVICE_NAME" "$DEVICE" "$DEV_GRP" "$XDA_THREAD" "$GHUN" "$NAME" "$DONATE_URL" "$WEBSITE_URL" "$NEWS_URL" "$XDA_THREAD" > OTA/builds/$DEVICE.json
echo OTA/builds/$DEVICE.json file created

if [[ $DEVICE == *"_"* ]]; then
    BUILD_DATE=$(echo $FILENAME | cut -d "-" -f 4)
else
    BUILD_DATE=$(echo $FILENAME | cut -d "-" -f 3)
fi
BUILD_YEAR=${BUILD_DATE:0:4}
BUILD_MONTH=${BUILD_DATE:4:2}
BUILD_DAY=${BUILD_DATE:6:2}
CHANGELOG=$(echo "Changelog - $BUILD_YEAR/$BUILD_MONTH/$BUILD_DAY\n")

if [ -d "OTA/changelogs/$DEVICE" ]
then
printf "$CHANGELOG" > OTA/changelogs/$DEVICE/$FILENAME.txt
echo OTA/changelogs/$DEVICE/$FILENAME.txt file created "(make sure to update the changelog file)"
else
mkdir -p OTA/changelogs/$DEVICE
printf "$CHANGELOG" > OTA/changelogs/$DEVICE/$FILENAME.txt
echo OTA/changelogs/$DEVICE/$FILENAME.txt file created "(make sure to update the changelog file)"
fi
