#!/bin/bash

NAME="Pepsy Kernel (XIAOMI-SDM845)"
VERSION=" v0.3"

curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="$NAME$VERSION build started!" -d chat_id=@pepsykernel;
curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="Changelog:" -d chat_id=@pepsykernel;
curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="$(cat changelog.txt)" -d chat_id=@pepsykernel;

bash beryllium.sh
bash dipper.sh
bash equuleus.sh
# bash perseus.sh
bash polaris.sh
bash ursa.sh

