#!/bin/sh
giip에서 가져오게되는 json포멧 형식의 파일을 행렬에 넣는 간단한 스크립트입니다. 
원리방식은 간단히 json이 가지고 있는 파일 형태의 {}[]를 sed명령어로 소거 시키고,
구분자를 , 로 지정하여 가져온 json포멧형식의 내용을 쪼개어 행렬로 넣습니다. 

sed -i 's/[{]/ /g' test
sed -i 's/[}]/ /g' test
sed -i 's/[[]/ /g' test
sed -i 's/[]]/ /g' test

IFS=$','
arr=(`cat test`)
echo ${arr[*]}
echo ${arr[2]}
