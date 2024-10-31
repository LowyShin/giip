#!/bin/bash

# Usage: create_logrotate.sh server_name file_path ssh_user

# 引数の数を確認
if [ "$#" -ne 3 ]; then
    echo "使用法: $0 サーバー名 ファイルパス SSHUSER"
    exit 1
fi

SERVER="$1"
FILE_PATH="$2"
SSHUSER="$3"

# ログファイル名と設定ファイル名を取得
FILE_NAME=$(basename "$FILE_PATH")
CONFIG_NAME="${FILE_NAME%.*}"

# リモートサーバーでファイルの存在を確認
echo "ファイルをチェックします。"
ssh "${SSHUSER}@${SERVER}" "test -e '$FILE_PATH'"
if [ $? -ne 0 ]; then
    echo "ファイル $FILE_PATH はサーバー $SERVER に存在しません。"
    exit 1
else
    echo "$SERVER に $FILE_PATH が確認できました！"
fi

# ログファイルの所有者とグループを取得
echo "$FILE_PATH の所有者を持ってきます。"
OWNER_GROUP=$(ssh "${SSHUSER}@${SERVER}" "stat -c '%U %G %s' '$FILE_PATH'")
OWNER=$(echo $OWNER_GROUP | cut -d' ' -f1)
GROUP=$(echo $OWNER_GROUP | cut -d' ' -f2)
FSIZE=$(echo $OWNER_GROUP | cut -d' ' -f3)

echo "$FILE_PATH の所有者は $OWNER : $GROUP になっています。(File Size : $FSIZE)"

# logrotate設定の内容を作成
CONFIG_CONTENT="
$FILE_PATH {
    su $OWNER $GROUP
    daily
    rotate 10
    missingok
    notifempty
    compress
    delaycompress
    copytruncate
}
"

# 一時的なローカルファイルを作成
TEMP_CONFIG="/tmp/$CONFIG_NAME.logrotate"
echo "$CONFIG_CONTENT" > "$TEMP_CONFIG"

# ローカルで作成したファイルをリモートサーバーにコピー
echo "logrotateファイルを作成してサーバーに伝送します。"
scp "$TEMP_CONFIG" "${SSHUSER}@${SERVER}:/tmp/"
echo "logrotateファイルのコピーが完了しました。"

# リモートサーバーにlogrotate設定ファイルを作成
# ssh -t "${SSHUSER}@${SERVER}" "echo \"$CONFIG_CONTENT\" | sudo tee /etc/logrotate.d/$CONFIG_NAME > /dev/null"
echo "logrotateファイルの権限をrootに変更します。"
ssh -t "${SSHUSER}@${SERVER}" "sudo mv /tmp/$CONFIG_NAME.logrotate /etc/logrotate.d/$CONFIG_NAME && sudo chown root:root /etc/logrotate.d/$CONFIG_NAME && sudo chmod 644 /etc/logrotate.d/$CONFIG_NAME"


if [ $? -eq 0 ]; then
    echo "サーバー $SERVER に $FILE_PATH のlogrotate設定を作成しました。"
else
    echo "サーバー $SERVER にlogrotate設定を作成できませんでした。"
    exit 1
fi

# ローカルの一時ファイルを削除
# rm "$TEMP_CONFIG"
