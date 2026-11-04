# Cyberware Injector 2.3.3 한국어 호환 패치 v1

기존 Player Body Cyberware Injector KR은 최신 기능이 빠진 init.lua 전체를 덮어씁니다. 이 패치는 제공된 2.3.3의 최신 init.lua를 기준으로 기존 한국어 문구를 옮긴 버전입니다.

## 설치

1. 기존 `Player Body Cyberware Injector KR` 비활성화.
2. Cyberware Injector 2.3.3 원본 설치 및 활성화.
3. 이 ZIP을 별도 모드로 설치하고 MO2에서 원본보다 아래에 배치.
4. 최종 적용되는 파일이 이 패치의 `bin/x64/plugins/cyber_engine_tweaks/mods/KiasuBurgerReplacer/init.lua`인지 확인.
5. 게임을 재시작하고 CET를 열어 저장·삭제·콘솔 출력 버튼을 확인.

독립 실행 모드가 아닙니다. 원본의 redscript, archive, XL, 라이브러리가 필요합니다. 이 ZIP에는 개인 JSON·저장 파일이 없습니다.

## 호환 수정

기존 KR에서 누락된 최신 코드를 유지합니다.

- 저장 후 ReplacerSystem.SetJson(json), 삭제 후 SetJson(nil) 호출.
- 컴포넌트의 renderingPlaneAnimationParam 읽기 및 JSON 저장.
- 남성 V의 Inorganic Materials 다리 컴포넌트에 대응하는 원래 몸통 다리 숨김 마스크.

창 제목과 버튼 4개, 로그 15개 등 서로 다른 표시 문자열 19개를 한국어로 제공합니다. 기능 코드, JSON 키, 컴포넌트 식별자 및 원본 데이터 형식은 변경하지 않습니다. 별도 언어 파일을 지원하지 않아 최신 init.lua의 표시 문자열을 교체하는 방식입니다. 향후 원본 업데이트 시 재비교가 필요합니다.

## 검증

- 입력 ZIP 무결성 확인.
- 번역된 문자열을 영어로 되돌리면 2.3.3 원본과 정확히 일치함을 확인.
- LuaJIT에서 파일 로드·이벤트 등록·창 열기/닫기 및 표시 문구 확인.
- 모의 게임 API에서 컴포넌트 리소스 콜백, 남성 다리 숨김 마스크, 렌더링 파라미터 직렬화, 저장 SetJson 적용·삭제 시 초기화, 콘솔 출력 확인. 원본과 패치 모두 통과.
- 같은 모의 조건에서 구형 KR은 다리 숨김 마스크 검사 실패.
- 실제 게임·CET·REDscript 컴파일·바디 렌더링 검증은 수행하지 않음.
