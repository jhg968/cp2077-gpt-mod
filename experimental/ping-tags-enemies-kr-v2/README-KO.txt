Ping Tags Enemies KR Complete v2 — 로드 오류 수정 포함

이 ZIP은 기존 KR Complete v1의 번역 UI/init와 핵심 파일의 문법 오류 수정을 함께 포함합니다. 원본 모드가 필요합니다.

확인한 원인: 첨부한 PingTagsEnemies.lua(내부 Version 1.3.2)의 21행 elseif 앞에 U+FEFF / UTF-8 EF BB BF 한 개가 있어 LuaJIT 문법 오류가 발생합니다. 그 결과 require가 실패하고 init.lua의 단축키 등록에서도 nil 오류가 발생합니다.

핵심 파일 변경: 이 보이지 않는 문자 1개(3바이트)만 제거했습니다. 나머지 바이트와 줄바꿈, 원본 Version 표기, 기능 코드는 그대로입니다. UI.lua/init.lua는 앞서 제공한 KR v1과 동일하며, 10개 설정 모두 번역된 상태입니다.

MO2 설치:
1. 기존 Ping Tags Enemies KR 및 제가 제공한 KR Complete v1을 비활성화합니다.
2. 최신 원본 모드는 활성화합니다. Settings.lua와 기타 원본 보조 파일이 필요합니다.
3. 이 ZIP을 별도 모드로 설치하고 원본보다 아래에 둡니다.
4. UI.lua, init.lua, PingTagsEnemies.lua 세 파일이 모두 이 v2에서 제공되는지 확인합니다.
5. MO2로 게임을 새로 실행합니다. CET의 Reload All Mods보다는 완전 재실행으로 확인하세요.

수동 설치: 기존 세 파일을 게임 경로 밖에 백업한 뒤 ZIP의 동일 경로 파일로 교체합니다. 원본의 다른 파일은 유지합니다.

확인: 최신 scripting.log에서 Mod PingTagsEnemies loaded! 및 PingTagsEnemies: Loaded.가 나오는지 확인하고, 모드 폴더의 PingTagsEnemies.log에서 새 실행 시간에 오류가 없는지 확인하세요.

Native Settings UI 설치 환경에서는 별도 CET 설정 창이 표시되지 않는 것이 원본 동작입니다. 모드 설정의 핑으로 적 태그 메뉴에서 태그 대상 5개/기능 설정 5개를 확인하세요.

검증: 원본 문법 오류를 LuaJIT에서 동일하게 재현. 3바이트만 제거한 수정본 전체 문법 검사 통과. 번역 init와 통합한 모의 실행에서 Settings 로드/UI 초기화/관찰자 6개 등록/전체 태그 해제 키 콜백 확인. UI/init는 v1과 바이트 일치. ZIP CRC 검증. 실제 게임 실행 및 게임 엔진 API 동작은 아직 검증하지 못했습니다.

파일:
bin/x64/plugins/cyber_engine_tweaks/mods/PingTagsEnemies/UI.lua
bin/x64/plugins/cyber_engine_tweaks/mods/PingTagsEnemies/init.lua
bin/x64/plugins/cyber_engine_tweaks/mods/PingTagsEnemies/PingTagsEnemies.lua
