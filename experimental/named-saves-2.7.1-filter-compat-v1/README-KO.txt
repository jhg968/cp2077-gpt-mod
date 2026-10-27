Filter Saves + Named Saves 2.7.1 호환 보완 v1

수정 대상은 첨부한 Filter Saves by Lifepath and Type의 filter_saves.reds 한 파일입니다. Named Saves 2.7.1 원본을 기준으로 합니다.

원인:
- 기존 Named Saves KR.zip은 466바이트의 구형 Config.reds로 최신 설정을 덮어씁니다. searchAllCategories/hideCategoryHeaders가 없고 rememberLastUsed의 공개 선언과 기본값도 최신 원본과 다릅니다.
- Named Saves 2.7.1 원본에는 여섯 개의 설정 제목/설명 한국어 문자열이 모두 들어 있습니다. 별도 KR 패치는 필요 없습니다.
- Filter Saves는 Named Saves 내부 m_searchInput 필드를 참조하지만 최신 원본은 searchInput을 사용합니다.

수정:
GetNamedSavesSearchQuery에서 내부 필드를 직접 읽는 대신 Named Saves 공개 CreateNamedSavesSearchEvent()의 query를 반환합니다. 원본 함수가 입력창 미생성 여부를 검사하고 UTF8 소문자 변환을 처리합니다. Named Saves가 없는 조건 분기는 그대로입니다. 저장 파일 기록/삭제 로직은 변경하지 않습니다.

MO2 설치 순서:
1. 기존 Named Saves KR 모드를 비활성화하세요. 이 보완판에는 Config.reds가 없으므로 반드시 구형 KR을 꺼야 첫 오류도 해결됩니다.
2. Named Saves 2.7.1 원본과 Filter Saves 원본은 활성화합니다.
3. 이 ZIP을 별도 모드로 설치하고 Filter Saves 원본보다 우선하도록 왼쪽 목록에서 아래에 둡니다.
4. 모드 정보의 파일 충돌에서 r6/scripts/filter_saves.reds의 최종 제공자가 이 보완판인지 확인합니다.
5. MO2로 게임을 다시 실행하고 최신 redscript_rCURRENT.log를 확인합니다.

구형 KR은 마지막 이름 기억의 기본값을 true로 강제했지만 최신 원본은 false입니다. 기존 옵션이 달라 보이면 Named Saves 설정에서 원하는 값으로 지정하세요.

게임 확인: 불러오기 메뉴의 저장 메모 검색, 퀘스트 검색, 인생 경로/저장 종류 필터, 모든 캐릭터에서 검색, 범주 제목 숨기기를 확인합니다. 오류가 남으면 최신 redscript_rCURRENT.log를 첨부하세요.

검증: 수정 위치 한 곳, 그 외 원본 바이트 보존, Named Saves 2.7.1 공개 함수/반환 query 필드 확인, 요구 설정 두 항목과 한국어 키 여섯 개 확인, Named Saves 미설치 분기 유지, ZIP CRC 확인. 실제 REDscript 컴파일과 게임 실행은 이 환경에서 검증하지 못했습니다.

이 보완판은 DLL, archive, Named Saves 원본 스크립트를 포함하지 않습니다. 두 원본 모드와 함께 사용하세요.
