#!/bin/bash

# ~./ssh 폴더 생성
if [ ! -d ~/.ssh ]; then
  mkdir ~/.ssh
  echo "create ~/.ssh directory"
fi

cd ~/.ssh

# github email 기준 pub key 생성
read -p "깃허브 계정 이메일을 입력해주세요: " email
read -p "public/private key filename을 입력해주세요: " filename

echo "public/private key는 .ssh/id_rsa_$filename 폴더 안에 저장됩니다."
prefix_filename="id_rsa_$filename"
mkdir -p ~/.ssh/$prefix_filename

echo "✅ 이 후 콘솔의 추가 질문에 모두 enter를 입력해주세요"
echo $filename | ssh-keygen -t rsa -C "$email"
echo "✅ https://github.com/settings/keys 접속, 로그인 후 Github 계정에 아래의 ssh 공개 키를 등록해주세요"

cat ./$filename.pub

echo "✅ ssh 키를 등록 했다면 yes를 입력해주세요"
while true; do
    read input
    if [ "$input" = "yes" ]; then
        echo "✅ 정말 ssh를 등록 하셨나요?"
            read confirmation
            if [ "$confirmation" = "yes" ]; then
                echo "✅ 알겠습니다 :)"
                break
            else
                echo "✅ 다시 확인해주세요."
            fi
    else
        echo "✅ yes를 입력해주세요"
    fi
done

echo "✅ ssh-add agent에 비밀키 등록"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/$filename


# git ssh config file 생성
config_file=~/.ssh/config

# ~/.ssh/config 파일이 없으면 생성합니다.
if [ ! -f "$config_file" ]; then
    touch $config_file
    echo "✅ ssh config 파일을 $config_file 경로에 생성하였습니다."
else
    echo "✅ $config_file 이미 존재하므로 스크립트를 계속 실행해주세요"
fi

# prefix_filename 폴더에 public/private key 이동
mv $filename ./$prefix_filename
mv $filename.pub ./$prefix_filename

# config 파일에 Host 정보를 추가합니다.
echo -e "\nHost github.com-$filename\n\tHostName github.com\n\tUser git\n\tIdentityFile ~/.ssh/$prefix_filename/$filename" >> $config_file
echo "✅ $config_file 내 새로 입력한 github.com-$filename 호스트 정보가 추가되었습니다."

# script를 실행한 경로로 이동
cd -

echo "🚌 가져올 레포의 SSH 링크를 입력해주세요"

while true; do
    read input
    if [ "$input" == "finish" ]; then
        echo "🔚 모든 입력을 완료했습니다. 프로그램을 종료합니다."
        break
    else
        # SSH 형식인지 확인하고 파일 이름을 추출합니다.
        if [[ "$input" =~ ^git@github.com:([[:alnum:]\._-]+)/([[:alnum:]\._-]+)\.git$ ]]; then
            filename="${BASH_REMATCH[1]}"
            echo "🚌 Cloning $input..."
            git clone $input
        else
            echo "⛔️ 유효하지 않은 SSH 링크 형식입니다. 올바른 형식으로 다시 입력해주세요."
            echo "🔚 모두 입력했다면 'finish'을 입력해 주세요"
        fi
    fi
done


echo "🎉 생성된 폴더와 파일 목록"
ls -al ~/.ssh/$prefix_filename
cat $config_file | grep tail -n 5