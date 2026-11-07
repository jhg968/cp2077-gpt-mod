# Autoloot 3.14.0 한국어 번역 업데이트 v1

## 설치

1. Autoloot 3.14.0 원본을 활성화합니다.
2. 이 ZIP을 별도 모드로 설치하고 MO2에서 기존 KR 패치보다 아래에 배치하거나 기존 번역 파일을 이 버전으로 교체합니다.
3. 최종 적용 파일: bin/x64/plugins/cyber_engine_tweaks/mods/AutoLoot/language/kr-kr/uiStrings.json
4. 한국어로 게임을 실행합니다. 게임 재시작이 가장 확실한 적용 방법입니다.

원본 Lua, 개인 config/config.json, 루팅 설정·세이브 파일은 포함하거나 수정하지 않습니다. 기존 KR에 다른 종류의 변경 파일이 포함되어 있다면 이 JSON 업데이트와 별개로 최신 원본을 덮어쓰는지 확인해야 합니다.

## 비교 및 변경

제공된 기존 uiStrings.json의 표시 문구 56개를 공백·줄바꿈을 포함해 그대로 유지하고 최신 템플릿의 누락 문구 14개를 추가했습니다. 총 70개입니다. 기존 버스트 모드 및 최대 지속시간 문구는 이미 번역되어 있어 변경하지 않았습니다.

추가된 문구:
- CET 및 Native Settings의 자동 루팅 자동 저장 제한: 이름·설명 4개.
- CET 및 Native Settings 모드 정보: 버튼·안내·소개 본문 6개.
- 트리거 미설정 안내 2개.
- 모드 정보 헤더·푸터 2개.

모드 버전 메타데이터는 v3.14.0으로 갱신했습니다. 기존 메타데이터의 v3.7.7은 번역 파일에 기재된 값일 뿐, 실제 사용하던 모드 버전을 증명하지 않습니다. 파일의 exportOrder 및 ##MOD_TITLE##, ##MOD_VERSION##, ##MOD_AUTHOR## 치환자를 유지합니다.

## .placeholder 파일

원본 언어 폴더의 .placeholder는 0바이트 파일이며 빈 폴더를 배포 압축에 포함시키기 위한 용도입니다. 번역 내용은 들어 있지 않고, 번역 로더는 uiStrings.json을 읽습니다. .placeholder를 별도로 첨부하거나 수정할 필요가 없습니다. 원본에 있는 파일은 그대로 두면 됩니다.

## 검증

- 원본 ZIP 및 제공 JSON 파싱 확인.
- 최신 표시 문구 70개 키·자료형 포함, 기존 56개 번역 동일 확인.
- 새 문구 14개 및 정보 표시 치환자 보존 확인.
- 원본 ui_new.lua의 cloneTable, replaceTableEntries, loadAllLanguageFiles, loadLocalizedStrings를 LuaJIT에서 실행.
- 한국어 파일 로드 후 모든 항목이 예상 번역과 동일한지, 영어 기본값 및 한국어 재전환이 정상인지 확인.
- UTF-8 BOM 없음, 배포 게임 파일이 JSON 1개뿐인지 확인.
- 실제 게임/CET/Native Settings의 글꼴·배치는 검증하지 못했습니다.
