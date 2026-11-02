Untrack Quest Ultimate / Quest Tracking Toggle 3.6.0 KR 보완 v1

원본 모드: anygoodname. 기존 한국어 번역을 유지하면서 원본의 공식 번역 파일 방식으로 3.6.0 신규 항목을 추가한 패치입니다. 3.6.0 원본 모드가 필요합니다.

분석:
- 기존 KR은 uiStrings.json 하나를 제공하므로 핵심 기능 파일을 되돌리지는 않습니다.
- 최신 원본은 번역에 없는 항목에 기본 영어를 사용하는 구조입니다. 따라서 기존 KR에서 새 설정이 영어로 나오는 것이 주요 문제입니다.
- 원본 3.6.0의 문자열 구조와 비교해 누락은 4개이며 기존 번역 104개에 삭제/타입 불일치는 없습니다.

보완:
CET 창과 Native Settings 각각의 gamePatches.patchMq061Quests.title/tooltips를 번역했습니다. 기존 번역 104개는 그대로 유지하고 총 108개 UI 문자열을 포함합니다. 파일의 대상 버전 표기는 v3.6.0으로 갱신했습니다.

신규 옵션은 차량 이용/전투 시 Welcome To Paradise 퀘스트가 강제로 다시 추적되는 게임 2.5 문제를 완화합니다. 직접 추적 해제한 목표에만 적용하며 퀘스트 로직 자체의 완전한 수정은 아닙니다. 원본의 기본 켜짐 설정은 이 번역 파일이 변경하지 않습니다. 정확한 대상 퀘스트 식별을 위해 화면 제목에는 원문의 Welcome To Paradise를 유지했습니다.

MO2 적용:
1. 기존 Untrack Quest Ultimate KR을 비활성화합니다.
2. Untrack Quest Ultimate 3.6.0 원본은 활성화합니다.
3. 이 ZIP을 별도 모드로 설치하고 원본 아래에 배치합니다.
4. bin/x64/plugins/cyber_engine_tweaks/mods/QuestTrackingToggle/language/kr-kr/uiStrings.json의 최종 제공자가 이 패치인지 확인합니다.
5. MO2로 게임을 새로 실행합니다. 원본의 실제 CET 폴더명은 QuestTrackingToggle이며 바꾸지 마세요.

게임의 한국어 UI 설정에서 모드의 게임 패치 범주를 열어 Welcome To Paradise 옵션의 제목/설명을 확인하세요. CET 창과 Native Settings UI 모두 번역을 포함합니다. 원본 기준 게임 2.5에서는 해당 기능을 제공합니다.

수동 적용: 기존 uiStrings.json을 게임 경로 밖에 백업하고 ZIP의 동일 경로 파일로 교체합니다. init.lua, Ref.lua, mod_user_settings.json 등은 변경하지 마세요.

검증: 3.6.0 기본 번역 테이블에서 추출한 108개 문자열 경로와 정확히 일치, 기존 104개 문자열 보존, JSON 파싱/왕복 저장, 원본 replaceTableEntries 함수를 LuaJIT에서 실행해 누락 없이 한국어가 병합되는지 확인, ZIP CRC 통과. 실제 CET/게임 내 표시와 새 퀘스트 우회 기능 자체의 동작은 아직 미검증입니다.

문제가 있으면 최신 scripting.log와 QuestTrackingToggle 폴더 내 개별 로그, 표시 화면을 첨부해주세요.
