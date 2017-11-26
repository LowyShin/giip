#jq 명령어를 bin/ 루트에 설치하고 사용할수있도록 합니다. jq명령어는 json 포멧형식을 열에 따라 깔끔하게 정리하여 볼수있게끔
출력을 도와줍니다.
#test.txt 는 json 포멧 형태의 내용이 들어있는 파일의 예시이므로 준비가 되어져있어야합니다.
cd /usr/local/bin/
wget http://stedolan.github.io/jq/download/linux64/jq
chmod a+x jq
cat test.txt | jq .

# 필요없는 구분자내용 지우기.
sed '/[{}]/d' test.txt > test.txt
sed 's/[,]//g' test.txt > test.txt
sed 's/\[//g' test.txt > test.txt
sed '/\]/d' test.txt > test.txt


# 행렬 지정 및 출력 확인하기.
IFS=$'\n' 
arr=(`cat test.txt`)
echo ${arr[*]}
