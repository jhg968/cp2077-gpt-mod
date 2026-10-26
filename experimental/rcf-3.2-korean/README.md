# Redscript Configuration Framework 3.2.0 한국어 지역화 패치 v1

사용자가 제공한 구버전 KR 패치의 번역을 Framework 3.2.0에 맞춰 이식했습니다.
기존 KR ZIP에는 구형 기능 코드가 포함되어 있어 그대로 사용할 수 없습니다.

## 변경

- Framework 3.2.0 공식 English.reds의 지역화 키 194개를 한국어로 제공합니다.
- 기존 번역 160개를 바탕으로, 컨트롤러 및 숫자 입력 관련 34개 항목을 추가했습니다.
- 플러그인 명칭 DVRCFInput을 RedRCFInput으로 정정했습니다.
- 3.2.0에서 바뀐 Big UI 기본값 및 +/- 버튼 설명을 반영했습니다.
- ZIP은 `r6/scripts/RedscriptConfigFramework/translations/Korean.reds` 한 파일만 제공합니다.
- Settings/HubPopup/RedLogger/Input XML/DLL/저장 데이터는 덮어쓰지 않습니다.

## 구버전 KR 패치를 그대로 사용하면 안 되는 이유

구버전 `DVRCF_Settings.reds`와 `DVRCF_HubPopup.reds`는 `RedData.Json` 및 `JsonObject`를 사용합니다.
3.2.0 원본은 `RedFunctions.Json` 및 `JsonMap`을 사용하고, 패드 탐색 멤버 및 기능도 추가되어 있습니다.
기존 KR의 Settings에는 최신 OptionsProvider가 요구하는 `padNav`, `PadKey`, `SetPad`가 없습니다.
이전 실행에서 관측한 컴파일 실패와 일치하는 파일 불일치입니다.
번역만 필요한 경우 기능 코드 전체를 구형 파일로 교체하면 안 됩니다.

## 설치

1. 게임을 종료합니다.
2. 기존 `Redscript Configuration Framework KR` 모드는 비활성화합니다. 두 번역 패치를 함께 켜지 마세요.
3. Framework 공식 3.2.0, RedFunctions 및 필수 의존성은 유지합니다.
4. 이 디렉터리의 `RCF-3.2.0-Korean-Localization-v1.zip`을 MO2에 별도 모드로 설치합니다.
5. 원본 Framework보다 높은 파일 우선순위를 지정합니다. MO2 왼쪽 목록에서 원본보다 아래에 배치합니다.
6. 게임 텍스트 언어를 한국어로 설정하고 게임을 실행합니다.

원본에 구 KR 패치를 직접 덮어쓴 적이 있다면, 공식 3.2.0 파일이 복구된 상태인지 먼저 확인하세요.
사용자 설정 JSON은 지울 필요가 없습니다.

## 검증

정적 검사 완료: 공식 영어 키 194개와 집합/개수 일치, 중복 키 없음, 문자열 직렬화 및 자리표시자 보존,
지역화 클래스 이름과 번역 문자열 외 코드 동일, ZIP 파일 목록 및 무결성 확인.
게임에서의 redscript 컴파일, 글꼴 표시 및 UI 크기는 아직 검증하지 않았습니다.

적용 후 `redscript_rCURRENT.log`에서 컴파일 성공을 확인하고, 허브의 옵션/검색/프리셋/컨트롤러/숫자 입력 UI를 확인하세요.
오류가 발생하면 이 지역화 모드만 비활성화해 원복하고 해당 실행의 redscript 로그를 공유하세요.

## 범위 및 제한

이 패치는 3.2.0의 지역화 패키지에 있는 194개 항목을 번역합니다.
하드코딩된 `<current session>` 같은 일부 문구, 카드 설명 및 게임 내 위키 본문은 원본 그대로 남습니다.
구 KR의 F12 기본 키 변경도 이식하지 않았습니다. 원하는 키는 Framework 설정에서 직접 지정하세요.
이후 공식 Framework 업데이트 시 지역화 키가 추가되면 다시 대조해야 합니다.

기존 한국어 번역은 사용자가 첨부한 KR 모드에서 가져왔으며, 원본 제작자의 번역 기여를 유지합니다.
네이티브 DLL 바이너리 패치는 포함하지 않습니다.
