DEVICE_JSON_URL="https://raw.githubusercontent.com/Black-Iron-Project/OTA/v15"
DEVICE_CHANGELOG_URL="https://raw.githubusercontent.com/Black-Iron-Project/OTA/v15/changelogs/"
CHANGED_FILE="$(git diff --name-only HEAD~1 | head -1)"

if ! [[ "${CHANGED_FILE}" =~ "json" ]]; then
    echo "Skipping since no json file was changed!"
    exit 0
fi

STATUS="$(jq -r '.status' "${CHANGED_FILE}")"
DEVICE="$(jq -r '.device' "${CHANGED_FILE}")"
PHOTO="banner.jpeg"
BUILD_DATE="$(date +'%Y-%m-%d' -d $(jq '.datetime' ${CHANGED_FILE}))"
BUILD_TYPE="${jq -r '.build_type' "${CHANGED_FILE}"}"
CHANGELOG="${DEVICE_CHANGELOG_URL}${DEVICE}/$(jq -r '.filename' "${CHANGED_FILE}")"
SFLINK="$(jq -r '.url' "${CHANGED_FILE}")"
DEVICE_NAME="$(jq -r '.device_name' "${CHANGED_FILE}")"
BLKIV="$(jq -r '.blkiv' "${CHANGED_FILE}")"
XDA="$(jq -r '.xda_thread' "${CHANGED_FILE}")"
USERNAME="$(jq -r '.tg_username' "${CHANGED_FILE}")"
DEV_GRP="$(jq -r '.device_group' "${CHANGED_FILE}")"
ROM="https://github.com/Black-Iron-Project/OTA/blob/v15/changelog.md"
if [[ $STATUS = "Active" ]]
then

         curl -X POST -F photo=@"${PHOTO}" https://api.telegram.org/bot"${TOKEN}"/sendPhoto -F chat_id="${CHAT_ID}" -F parse_mode=HTML -F "caption=BlackIron ${BLKIV}
New OFFICIAL Update for ${DEVICE_NAME} is Out

Build Version : ${BLKIV}
Build Date : ${BUILD_DATE}
Build Type : ${BUILD_TYPE}
Codename : ${DEVICE}
By : @${USERNAME}

Download : <a href='${SFLINK}'>SourceForge</a>
XDA thread : <a href='${XDA}'>XDA</a>
Changelog : <a href='${CHANGELOG}.txt'>Device</a> | <a href='${ROM}'>ROM</a>

 Support : @BlackIronProject
 Channel : @BlkiUpdate
 Device Group : ${DEV_GRP}

#BLKI #${DEVICE}"
else
echo "Device is inactive so dropped notification sent"
curl -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
-d "chat_id=${CHAT_ID}" \
-d "text=Sad news! %0A%0A${DEVICE_NAME} has been dropped from official support.%0A%0AIf you'd like to apply to maintain, please follow the button below." \
-d "reply_markup={\"inline_keyboard\":[[{\"text\":\"Apply Here\",\"url\":\"https://test.link\"}]]}"
fi
