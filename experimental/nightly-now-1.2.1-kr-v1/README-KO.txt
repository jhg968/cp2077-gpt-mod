NightlyNow Core 1.2.1 KR 호환 보완 v1

첨부한 NightlyNow 1.2.1 원본을 기준으로 만든 번역 패치입니다. 1.2.1 원본이 필요합니다.

구형 KR의 문제:
- Settings.reds가 최신 uiScale 설정과 Mod Settings 미설치 시 사용하는 빈 리스너 함수를 제거합니다.
- HoloHook.reds가 최신 모드 연락처 표시/읽음 처리/정렬/화면 갱신 코드를 구버전으로 되돌립니다.
- 번역 아카이브에는 새 UI 크기 관련 키 3개가 없습니다.

보완:
- 최신 화면 문구 16개 키를 모두 한국어 리소스에 포함했습니다. 새 UI 범주, UI 크기, UI 크기 설명을 번역했습니다. 지원 모드 이름 Drug Dealer/Punish Cruelty/Injuries는 원문 이름을 유지했습니다.
- 기존 번역을 바탕으로 하되 X 위치 설명은 최신 원문과 맞춰 정리했습니다. Y 위치 설명의 다시 불러오기 안내는 유지합니다.
- 한국어는 kr-kr 전용 리소스와 ArchiveXL 설정으로 등록합니다. 원본 영어 리소스를 덮어쓰지 않습니다.
- Settings.reds는 포함하지 않아 최신 원본과 uiScale 설정을 그대로 사용합니다.
- 최신 HoloHook.reds에서 Empty Contact/Empty Preview 두 표시 문자열만 빈 연락처/미리보기 없음으로 번역했습니다. 나머지 바이트는 최신 원본과 같습니다.

MO2 적용:
1. 기존 NightlyNow Core KR을 비활성화합니다. 기존 폴더에 병합하지 마세요.
2. NightlyNow 1.2.1 원본을 활성화합니다.
3. 이 ZIP을 별도 모드로 설치하고 원본 아래에 배치합니다.
4. Settings.reds는 반드시 1.2.1 원본에서 제공되고, HoloHook.reds는 새 KR 패치에서 제공되는지 확인합니다.
5. 게임을 완전히 다시 실행하고 redscript_rCURRENT.log에서 컴파일 완료를 확인합니다.

수동 적용: 구형 KR의 Settings.reds/HoloHook.reds가 원본을 덮어쓴 경우 1.2.1 원본을 먼저 다시 적용해 복구한 뒤 이 ZIP을 적용합니다. 기존 NightlyNow KR.archive는 게임 경로 밖에 백업하고 교체합니다.

확인: NightlyNow 코어 설정에 UI 크기, 정보 위젯, 진행 바 옵션이 한국어로 보이는지 확인하세요. 모드로 추가된 홀로 연락처/문자 화면의 읽음 상태와 화면 갱신도 확인합니다. 이 패치는 사용자 설정을 초기화하거나 퀘스트 진행 상태를 변경하지 않습니다.

검증: 최신 리소스 16개 키와 일치, 모든 설정 메타데이터 키 존재, 최신 Settings.reds 덮어쓰기 없음, HoloHook에서 두 번역을 되돌리면 최신 원본과 바이트 일치. CR2W 재파싱/CRC32, 아카이브 인덱스 CRC64/리소스 SHA1, ZIP CRC 통과. 실제 REDscript 컴파일/게임 실행은 아직 미검증입니다.
