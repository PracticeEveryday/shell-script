#!/bin/bash

# .gitignore 파일에 추가할 파일 이름 입력 받음
echo ".gitignore 파일에 추가할 파일 또는 폴더를 입력해주세요(done을 입력하면 종료됩니다.): "

while :
do
    read -p "> " item
    if [ "$item" == "done" ]; then
        break
    else
        # 입력된 아이템이 존재하는지 확인
        if [ -e "$item" ]; then
            # 입력된 아이템이 파일인지 폴더인지 확인
            if [ -f "$item" ]; then
                echo "$item" >> .gitignore
            elif [ -d "$item" ]; then
                echo "$item/" >> .gitignore
            fi
        else
            echo "$item does not exist."
        fi
    fi
done


# .gitignore 파일을 스테이징 영역에 추가
git add .gitignore

# 입력 받은 파일을 추적에서 제외
git rm --cached $(cat .gitignore)

# 변경사항을 커밋
git commit -m "Added files to .gitignore and untracked them"
