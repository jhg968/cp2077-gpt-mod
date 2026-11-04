# Much Better AI 2.4 한국어 호환 패치 v1

## 설치

1. 기존 `Much Better AI KR`을 완전히 비활성화합니다. 새 패치와 함께 켜두면 구형 Lua 및 config.reds가 남으므로 안 됩니다.
2. Much Better AI 2.4 원본 및 필수 모드를 활성화합니다.
3. 이 ZIP을 별도 모드로 설치하고 원본보다 아래에 배치합니다.
4. 게임 언어를 한국어로 실행하면 자동 적용됩니다.
5. MO2에서 nativeSettingsUI.lua, settingsManager.lua, config.reds의 최종 제공 모드는 2.4 원본이어야 합니다. Korean.reds만 새 패치가 제공합니다.

직접 설치한 환경에서는 기존 KR의 위 파일 3개를 2.4 원본으로 복원해야 합니다. 개인 settings.json은 이 패치에 포함하지 않습니다. 저장된 설정의 이관은 최신 원본 settingsManager.lua가 처리합니다.

## 검토 결과

기존 KR에는 번역 외의 구형 기능 코드가 있습니다.

- config.reds: 최신 EnableAggressionFloor/AggressionRingCaps 함수 누락, 은신·소음·감지 장치 기능 기본값 및 전술 수치 차이.
- settingsManager.lua: 최신 SchemaVersion 6 대신 4 사용, 스키마 5·6 이관과 일부 런타임 설정 연결 누락.
- nativeSettingsUI.lua: 최신에서 제거된 AggressionFloorPreset 선택 항목 및 구형 기본값·설명 포함.
- Korean.reds: 최신 AI 동작과 달라진 설명 및 기본값이 남아 있음.

## 변경 범위

공식 Codeware 언어 패키지 구조를 사용해 `r6/scripts/MuchBetterAI/Localization/Packages/Korean.reds` 하나만 교체합니다. 최신 영문 패키지의 키 271개를 모두 제공하며 기존 번역을 재사용합니다.

현재 동작에 맞춰 명중 압박·사격 각도 이동·지원군 합류·사기 붕괴·빈틈 압박 빈도·측면 기동 빈도·퀵핵 빈도·수색 접근·동시 공격 인원 등 표시 문구 12개를 수정했습니다. 구형 AggressionFloorPreset 관련 키 5개는 최신 표준 패키지에 없어 제외했습니다.

최신 원본의 AI 기능 코드, 기본값, 설정 스키마 및 이관 코드는 그대로 사용합니다. 이 패치는 직접 AI 수치를 변경하지 않습니다. 이후 원본 업데이트 시 English.reds의 변경 여부를 비교해야 합니다.

## 검증

- ZIP/RAR 압축 해제 및 데이터 읽기 오류 없음 확인.
- 최신 표준 영문 키 271개와 번역 키 일치, 한국어 제공자 등록 확인.
- 최신 패키지 골격에서 표시 문자열만 변경했는지 확인.
- LuaJIT에서 원본 nativeSettingsUI.lua 및 localizer.lua 실행. Native Settings와 게임 번역 조회만 모의 처리.
- 명중 판정 모드 0/1/2 및 세부 옵션 표시 상태에서 UI 호출 132/137/138회, 번역 조회 키 총 271개가 모두 해결됨을 확인.
- UI 구성 중 설정 저장이 발생하지 않음 확인.
- 실제 REDscript 컴파일, CET 화면 배치, AI 게임플레이는 검증하지 못함.
