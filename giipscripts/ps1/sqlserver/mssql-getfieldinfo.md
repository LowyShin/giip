# mssql-getfieldinfo.ps1

### 환경 정보 수정

- ServerList.json
  - 스크립트 실행 장소에서 인식 가능한 IP나 hostname, domain등 모두 가능.
```json
{
    "Servers": [
        "ANADB11A",
        "SELECTDB30",
        "ADMDB11",
    ]
}

```
- dbre_tool_conf.json
  - User ID : DB접속욕 ID
  - Password : DB접속 비번
  - Server 는 수정 필요없음
```json
{
    "CommonConnectionString": "Server={ServerName};Database=master;User ID=lowyshin;Password=mypwd;"
}
```

### 사용예
```ps1
powershell ./getfieldinfo-mssql.ps1 -SvrList "ServerList.json"
```

### 결과 저장

스크립트가 실행된 장소에 evidence라는 디렉토리가 생성되고 ServerList에 있는 서버명의 파일이 csv형식으로 생성됨
