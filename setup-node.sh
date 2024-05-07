#!/bin/bash

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
. ~/.nvm/nvm.sh

read -p "다운로드 할 nvm 버전을 입력해주세요: " nvm_version

nvm install $nvm_version

read -p "${nvm_version} 을 Default로 사용하시겠습니까?: (yes or no)" is_default

if [ "${is_default}" = "yes" ]; then
  echo "🚌 default 설정 하는 중"
  nvm alias default v${nvm_version}
fi

echo "🎉 nvm 목록"
nvm ls