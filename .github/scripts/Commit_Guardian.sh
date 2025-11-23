#!/bin/bash
TARGET_FILES=("UIKit/CampusUI/Resources/KuringMaps-Info.plist" "Networks/Resources/KuringLink-Info.plist")

echo "🩺 커밋 방지 필요 여부 체크 중"

GUARDED_FILES=($(git ls-files -v | grep '^h'))

if [ ${#TARGET_FILES[@]} -gt 0 ]; then
  echo "✅ 커밋 방지 처리가 되어있습니다"
  exit 0
else
  echo "💊 커밋 방지 코드를 실행합니다"
fi

cd ../..

for TARGET_FILE in "${TARGET_FILES[@]}"; do
  git update-index --assume-unchanged $TARGET_FILE
done

echo "✅ 커밋 방지 처리가 완료되었습니다"
