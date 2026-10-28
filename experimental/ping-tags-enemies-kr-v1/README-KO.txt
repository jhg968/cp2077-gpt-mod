Ping Tags Enemies 최신 첨부본 기준 KR 보완 v1

기존 KR UI에서 주석 처리됐던 설정 7개까지 포함하여 최신 원본의 설정 10개를 모두 번역합니다. 첨부된 원본에는 버전 표기가 없어 버전 번호를 임의 지정하지 않았습니다.

포함 파일:
bin/x64/plugins/cyber_engine_tweaks/mods/PingTagsEnemies/UI.lua
bin/x64/plugins/cyber_engine_tweaks/mods/PingTagsEnemies/init.lua

MO2 적용:
1. 기존 Ping Tags Enemies KR 모드를 비활성화합니다.
2. Ping Tags Enemies 최신 원본은 활성화한 채 유지합니다.
3. 이 ZIP을 별도 번역 모드로 설치하고 원본보다 아래에 배치합니다.
4. MO2 파일 충돌에서 UI.lua와 init.lua가 이 패치의 파일로 적용되는지 확인합니다.
5. MO2로 게임을 새로 실행합니다. 원본 모드 폴더 이름을 변경해 사용 중이라면 실제 폴더와 ZIP 경로가 일치해야 합니다.

수동 적용: 기존 UI.lua/init.lua를 게임 경로 밖에 백업한 뒤 ZIP의 두 파일로 교체합니다. Settings.lua, PingTagsEnemies.lua 및 다른 원본 파일은 유지합니다.

번역 범위: 설정 대상 5개(NPC, 액세스 포인트, 카메라, 해킹 가능한 컴퓨터, 터렛), 기능 설정 5개(꺼진 카메라 태그 방지, 카메라 끌 때 해제, 액세스 포인트 해킹 후 해제, NPC 사망 시 해제, 안구 사이버웨어 하이라이트 태그), 범주/탭/창 제목, 전체 태그 해제 단축키 설명. Native Settings UI에 설명문이 표시됩니다. 원본 CET 대체 창은 설명문을 따로 표시하지 않는 구조를 유지합니다.

원본의 설정 키/경로/기본값/콜백/게임 동작 코드/줄바꿈을 유지하고 표시 문자열만 바꿨습니다. 이 패치가 기존 설정을 초기화하거나 강제로 켜지 않습니다.

확인: Native Settings의 핑으로 적 태그 메뉴에서 태그 대상 5개와 기능 설정 5개가 보이는지 확인하세요. Native Settings 미설치 시 CET 오버레이의 모드 창에서도 10개가 표시됩니다. Lua 오류가 발생하면 최신 scripting.log를 첨부해주세요.

검증: 최신 첨부 원본과 비교해 문자열 외 코드 동일, 10개 활성 설정 유지, 키/경로/기본값 동일. LuaJIT 문법 검사, Native Settings 모의 등록 10개 및 콜백 저장, CET 대체 창 모의 표시 10개 및 저장 동작 비교 통과. ZIP CRC 확인. 게임 실행과 첨부되지 않은 핵심 모듈의 2.5 호환성은 검증하지 못했습니다.
