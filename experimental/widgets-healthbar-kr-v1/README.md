# Minimap Widgets / Informative Healthbar 한국어 패치 v1

사용자가 제공한 업데이트본을 기준으로 만든 비공식 별도 한국어 패치입니다.
두 원본 모드는 각각 필요합니다. 기존 KR 패치를 통째로 최신본에 덮어쓰면 기능 코드가 되돌아가거나 구형 CET 모드가 함께 실행될 수 있어 지역화 파일만 분리했습니다.

| ZIP | 필요한 원본 | 번역 범위 |
|---|---|---|
| Minimap-Widgets-3.2.2.1-KR-v1.zip | Minimap Widgets 3.2.2.1 | 공식 영어 지역화 키 332개 |
| Informative-Healthbar-1.13-KR-v1.zip | Informative Healthbar 1.13 | 공식 영어 지역화 키 285개 |

## 설치 — MO2

1. 게임을 종료합니다.
2. 기존 `Minimap Widgets KR` 및 `Informative Healthbar KR` 패치는 둘 다 비활성화합니다.
3. 최신 원본 두 모드는 계속 활성화합니다. 원본의 필수 의존성도 유지합니다.
4. 두 ZIP을 각각 **새 모드로 설치**합니다. 구 KR 폴더에 병합/덮어쓰기 설치하지 마세요. 구버전 파일이 남을 수 있습니다.
5. 각 새 KR 패치가 대응 원본보다 높은 파일 우선순위를 갖게 합니다. MO2 왼쪽 목록에서는 각 원본보다 아래에 둡니다.
6. 게임 텍스트 언어를 한국어로 설정하고 게임을 새로 실행합니다.
7. redscript 로그의 컴파일 결과와 각 모드 설정/위젯 표시를 확인합니다.

미니맵의 구형 CET `bin/x64/plugins/cyber_engine_tweaks/mods/Minimap Widgets/init.lua`가 다른 설치본이나 수동 설치에서 남아 있으면 새 redscript 미니맵과 함께 실행될 수 있습니다.
MO2 데이터 탭에서 해당 구형 init.lua의 제공자를 확인하세요. 첨부된 최신 원본과 새 KR ZIP은 이 Lua 파일을 제공하지 않습니다.
새 미니맵 설정은 Redscript Configuration Framework에서 열며, 구형 CET/Native Settings 메뉴와 다릅니다.
`r6/scripts/MinimapWidgets`는 최신 원본 경로이므로 제거하지 마세요.

## 변경 내용

### Minimap Widgets

- 기존 Lua 번역 패키지를 새 redscript 지역화 체계에 맞춰 이식했습니다.
- 탭/설정/마커/색상/위치/나침반/날씨/Nova 날씨/달력/스토리 경과일/실제 시간/지역/갱단/픽서/거리/FPS/처치/소지금 항목을 번역했습니다.
- 지역화 키 332개를 모두 제공하고 provider에 `kr-kr`을 등록합니다.
- 구형 init.lua와 구형 설정/날씨 JSON은 포함하지 않습니다.

### Informative Healthbar

- 기존 KR과 최신 원본에 공통인 키 256개를 바탕으로 신규 29개를 번역했습니다.
- Conscience, 프레임 생성 FPS, Classic White 테마, Marmur Bank와 최신 Night City Bank의 분리 및 수익률/수익/세금/레드 카드 진행도를 반영했습니다.
- 기존 NCB 번역 중 은행 이름/부채 포함 여부 등 변경된 의미를 최신 원문에 맞게 수정했습니다.
- 더 이상 사용하지 않는 키 5개는 제외했습니다.
- 구형 기능 .reds 11개를 덮어쓰지 않습니다. 최신 무게 표시 방어, 은행 API, SynthDose 처리, DrugDealer의 최신 설명 API 등을 유지합니다.
- 구 KR의 HUD 좌표 강제 변경도 포함하지 않습니다. 위치/기본값은 최신 원본 및 저장된 사용자 설정을 따릅니다.

## ZIP 파일 범위

각 ZIP에는 한국어 지역화 `.reds`와 한국어 등록 provider `.reds`, 총 2개 파일만 들어 있습니다.
CET Lua, DLL, 아카이브, 기능 모듈, 입력 XML 및 사용자 설정은 포함하지 않습니다.
동적으로 표시되는 다른 모드의 랭크/날짜/이름은 해당 모드가 반환하는 언어를 따를 수 있습니다.
최신 모드가 지역화하지 않는 하드코딩 문구(예: Healthbar의 초기 WAITING...)는 그대로 남습니다.

## 검증 결과와 제한

- 원본 영어 키와 한국어 키의 집합/개수 일치, 중복 없음.
- 문자열 직렬화, printf/자리표시자/마크업, 줄바꿈, 후행 공백 검사 통과.
- 클래스 이름과 번역 문자열 외 지역화 코드 구조 동일.
- provider는 한국어 등록 외 원본 코드 동일.
- 원본 위에 적용하는 병합 검사에서 provider 1개 변경 및 Korean 1개 추가만 확인.
- ZIP 파일 목록, CRC, SHA-256 확인.
- 실제 게임의 redscript 컴파일 및 UI 표시는 아직 검증하지 않았습니다.

적용 후 문제 발생 시 새 KR 패치만 끄면 원복됩니다. 새 실행의 redscript_rCURRENT.log를 공유하면 컴파일 결과를 확인할 수 있습니다.
수동으로 구 KR을 원본에 덮어쓴 적이 있다면 원본 최신 파일을 먼저 복구해야 합니다. 사용자 설정 파일을 지울 필요는 없습니다.

기존 번역은 사용자가 제공한 KR 자료를 참고·활용했습니다. 번역 데이터와 읽기 가능한 패치 소스, 상세 해시는 이 디렉터리에 함께 제공합니다.
