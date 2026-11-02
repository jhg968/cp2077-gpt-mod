Kiroshi Optics Night Vision 1.81 KR 호환 보완 v1

첨부한 Kiroshi Night Vision Mod 1.81 원본을 기준으로 만든 번역 전용 패치입니다. 1.81 원본과 필수 모드가 필요합니다.

기존 KR의 문제: 구형 init.lua가 최신 색상/감마 및 효과 갱신 로직을 되돌리고, 구형 settingsUI.lua가 새 색상 설정을 제거합니다. 이 패치에는 구형 기능 코드가 없습니다.

보완 내용:
- 최신 1.81 settingsUI.lua의 코드/기본값/설정 키/저장 콜백을 유지하며 메뉴 문구를 번역했습니다.
- 색상 프리셋 8개, RGB 3개, 감마, 키보드/컨트롤러 단축키 설정을 유지했습니다.
- item_data.lua의 아이템명/설명을 번역했습니다. 실제 단축키 입력 안내가 뒤에 붙는 원본 구조에 맞춰 설명 끝에 활성화 단축키 안내를 넣었습니다.
- RGB 설명에는 원본 내부 채널 키 대신 번역된 표시 이름을 사용합니다. 설정 키 red/green/blue는 유지합니다.
- init.lua, nightVision.reds, nightVision.archive, 사용자 config.json은 포함하거나 변경하지 않습니다.

MO2 적용:
1. 기존 Kiroshi Optics Night Vision - Korean Translation 모드를 비활성화합니다. 새 패치를 기존 KR에 병합하지 마세요.
2. Kiroshi Night Vision Mod 1.81 원본은 활성화합니다.
3. 이 ZIP을 새 모드로 설치하고 1.81 원본 아래에 배치합니다.
4. 충돌 정보에서 init.lua는 반드시 1.81 원본 파일이 최종 적용되는지 확인합니다. settingsUI.lua/item_data.lua 두 파일은 새 패치가 적용돼야 합니다.
5. 게임을 완전히 다시 실행합니다.

수동 설치: 구형 KR이 원본 init.lua를 덮어썼다면 1.81 원본을 다시 적용해 복구한 뒤 이 번역의 두 파일을 적용합니다. 사용자 설정은 먼저 백업하세요.

확인: 모드 설정의 나이트 비전 CW에서 색상 및 감마/키보드/컨트롤러 항목을 확인하고 나이트 비전을 켜고 끄세요. 기존 config.json은 초기화하지 않습니다.

크래시 관련 한계: 이 패치는 구형 번역으로 인한 코드 혼용을 해소합니다. 원본 hasNVInstalled 함수가 cwItemData nil을 검사하지 않는 점과 원본 효과 리소스/게임 API 호환성은 변경하지 않았으므로, 강제 종료 해결을 보장하지 않습니다. 계속 종료되면 이번 실행 시각의 nightVision.log, scripting.log와 크래시 리포트를 확인해야 합니다.

검증: 1.81 대비 표시 문자열만 변경(RGB 설명에서 name→label 표시 치환 포함), LuaJIT 문법 검사, Native Settings 모의 실행에서 프리셋 8개/RGB 3개/감마/단축키 2종 등록 및 프리셋·사용자 색·감마·키 저장 결과가 원본과 일치함을 확인. ZIP CRC 통과. 게임 실행/실제 효과 적용은 미검증입니다.

포함 파일:
bin/x64/plugins/cyber_engine_tweaks/mods/nightVision/modules/settingsUI.lua
bin/x64/plugins/cyber_engine_tweaks/mods/nightVision/modules/item_data.lua
