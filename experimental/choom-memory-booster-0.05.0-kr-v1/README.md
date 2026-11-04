# Choom Memory Booster 0.05.0 한국어 언어 팩 v1

## 설치

1. MO2에서 기존 `Choom Memory Booster KR`을 비활성화합니다. 기존 패치의 init.lua는 0.04.2 전체 파일이므로 새 원본을 덮어쓰면 안 됩니다.
2. Choom Memory Booster 0.05.0 원본을 설치하고 활성화합니다.
3. 이 ZIP을 별도 모드로 설치하고, 원본보다 아래에 배치해 `languages/registry.lua`가 이 패치의 파일로 적용되게 합니다.
4. 게임을 재시작하고 CET에서 CMB 창을 엽니다. `SETTINGS > Languages`에서 `한국어`를 선택합니다. 이후 선택은 원본 기능을 통해 자동 저장됩니다.
5. 필요하면 CET 콘솔에서 `CMB.SetLanguage("ko")`를 사용할 수 있습니다.

## 변경 범위

- `languages/ko.lua`: 공식 영어 템플릿의 152개 키 전체를 한국어로 제공(숫자·MB 단위 등은 유지).
- `languages/registry.lua`: 원본 English/Français 항목을 유지하고 한국어 선택 항목을 추가.
- 원본 init.lua, cmb_i18n.lua, cmb_config.lua, 개인 설정 파일은 포함하지 않습니다. 최신 타이머와 진행 막대, 테마, 간단히/고급 화면, 설정 탭을 원본 그대로 사용합니다.
- 창 제목·버전·로그·내보낸 보고서·CET 단축키 설명은 원본의 번역 시스템 범위 밖이므로 영어로 유지됩니다.
- 다른 추가 언어 팩도 사용한다면 registry.lua를 병합해 각 언어 항목을 보존해야 합니다. 이 파일은 제공된 원본 기준 English/Français/한국어 3개 언어를 등록합니다.
- 향후 업데이트 때 원본 en.lua 및 registry.lua의 변경 여부를 확인하세요. 새로운 미번역 키는 원본 로더가 영어로 표시합니다.

## 검증

- 두 입력 ZIP 무결성 확인.
- 공식 영어 템플릿과 키 152개 일치, 빈 번역 없음.
- LuaJIT에서 언어 팩 구문 검사 및 원본 cmb_i18n.lua 로더 실행.
- 모든 한국어 항목이 영어 대체 없이 로드됨을 확인.
- 문자열 서식 토큰의 종류·순서 일치 및 string.format 호출 검사.
- English/Français/한국어 전환, 잘못된 언어 거절, 알 수 없는 키 대체, ImGui ## 식별자 보존 확인.
- 실제 게임 화면의 글꼴·배치 및 재시작 후 언어 저장은 게임에서 확인해야 합니다.
