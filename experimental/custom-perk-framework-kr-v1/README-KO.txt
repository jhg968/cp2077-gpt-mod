Custom Perk Framework KR 호환 보완 v1

첨부한 Custom Perk Framework.zip 원본 기준 번역입니다. 원본 meta.ini 버전은 2.14.0.0이며, init.lua 안의 settings.version 1.0.0은 원본 그대로 유지합니다. 최신 원본 모드가 필요합니다.

기존 KR에서 확인한 문제:
- 캐릭터 화면 버튼과 트리 좌우 화살표의 tap 입력 처리가 제거됩니다.
- Popup.reds가 최신 루트 앵커/크기 설정과 상단/우측 여백을 구형 배치로 되돌립니다.
- 기존 팝업은 문자열을 직접 한국어로 바꾸지만 레벨 등 일부 문구는 영어로 남습니다.

보완:
- 원본의 공식 한국어 Localization/Korean.reds에 팝업 문구 12개를 번역했습니다. 원본 Provider가 이미 kr-kr을 등록하므로 Provider는 수정하지 않습니다.
- 최신 CharacterScreenButton.reds에서 Additional Perk Trees 표시 문구만 추가 특전 트리로 바꾸고 click/tap을 유지합니다.
- 최신 init.lua에서 Native Settings의 입력 장치 메뉴와 초기화 로그만 번역합니다. 입력 장치 순서/enum/기본값/설정 저장 코드는 유지합니다.
- Popup.reds는 포함하지 않아 최신 팝업 배치와 탐색 입력 처리를 원본에서 그대로 사용합니다.

MO2 적용:
1. 기존 Custom Perk Framework KR을 비활성화합니다. 새 파일을 기존 KR 폴더에 병합하지 마세요.
2. 첨부 최신 Custom Perk Framework 원본을 활성화합니다.
3. 이 ZIP을 별도 모드로 설치하고 원본 아래에 배치합니다.
4. Popup.reds는 원본에서 제공되고, Localization/Korean.reds와 CharacterScreenButton.reds 및 CET init.lua는 새 패치가 제공하는지 확인합니다.
5. 게임을 완전히 다시 실행하고 redscript_rCURRENT.log에서 컴파일 완료를 확인합니다.

수동 적용: 구형 KR의 Popup.reds가 원본을 덮어썼다면 최신 원본을 먼저 다시 적용해 복구하고, 이 ZIP의 세 파일을 적용합니다. 사용자 config.json은 초기화하지 않습니다.

검증: 팝업의 번역 키 12개와 한국어 테이블 정확히 일치, 원본 kr-kr 등록 확인, 코드 파일 세 개는 표시 문자열 외 바이트 동일, Popup.reds 덮어쓰기 없음. LuaJIT 문법 및 Native Settings 유무 모의 실행, 장치 5개 선택 시 enum 값/저장 결과 원본과 일치. ZIP CRC 통과. 실제 REDscript 컴파일/게임 실행은 아직 미검증입니다.

Custom Perk Framework를 사용하는 별도 특전 모드의 트리 이름/설명은 해당 모드가 제공하므로 이 패치에서 번역하지 않습니다.
