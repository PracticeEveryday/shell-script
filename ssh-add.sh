#!/bin/bash

# ~./ssh 폴더 생성
if [ ! -d ~/.ssh ]; then
  mkdir ~/.ssh
  echo "create ~/.ssh directory"
fi
cd ~/.ssh

# github email 기준 pub key 생성
read -p "Enter your GitHub email address: " email
read -p "Enter your public/private key filename: " filename

echo "✅ 이 후 콘솔의 추가 질문에 모두 enter를 입력해주세요"

echo $filename | ssh-keygen -t rsa -C "$email"
echo "https://github.com/settings/keys 접속, 로그인 후 Github 계정에 아래의 ssh 공개 키를 등록해주세요"

cat ./$filename.pub

echo "ssh 키를 등록 했다면 yes를 입력해주세요"
while true; do
    read input
    if [ "$input" = "yes" ]; then
        echo "정말 ssh를 등록 하셨나요?"
            read confirmation
            if [ "$confirmation" = "yes" ]; then
                echo "알겠습니다 :)"
                break
            else
                echo "다시 확인해주세요."
            fi
    else
        echo "yes를 입력해주세요"
    fi
done

echo "ssh-add 비밀키 등록 cli 실행"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/$filename

cd -

echo "🚌 가져올 레포의 SSH 링크를 입력해주세요"

while true; do
    read input
    if [ "$input" == "Done" ]; then
        echo "다시 한 번 입력해주세요"
            echo "알겠습니다 :)"
            break
    else
        echo $input Clonning...
        git clone $input

        echo "🚌 가져올 레포의 SSH 링크를 입력해주세요"
        echo "모두다 입력 했다면 Done을 입력해 주세요"
    fi
done


echo "📝reference: https://velog.io/@sonypark/GitHubSSH%EB%A5%BC-%EC%9D%B4%EC%9A%A9%ED%95%B4-%EC%97%AC%EB%9F%AC%EA%B0%9C%EC%9D%98-%EA%B9%83%ED%97%88%EB%B8%8C-%EA%B3%84%EC%A0%95-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0-6mk3iesh0u"

