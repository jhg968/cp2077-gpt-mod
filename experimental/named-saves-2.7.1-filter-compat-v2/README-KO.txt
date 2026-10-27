Filter Saves + Named Saves 2.7.1 호환 보완 v2

v1의 모듈 타입 가져오기 누락을 수정했습니다. NamedSavesSearchEvent는 NamedSaves.UI 모듈에 있으므로 Named Saves가 설치된 경우에만 해당 모듈을 import하고, 검색 이벤트 변수 타입을 명시했습니다.

기존 수정 유지: 사라진 m_searchInput 대신 공개 CreateNamedSavesSearchEvent()에서 query를 읽습니다. Named Saves 미설치 조건 분기는 유지합니다.

MO2 적용:
1. 구형 Named Saves KR은 계속 비활성화합니다. Named Saves 2.7.1 원본에 최신 한국어 설정이 있습니다.
2. Named Saves 2.7.1 및 Filter Saves 원본은 활성화합니다.
3. 이전 호환 패치 v1을 비활성화하고 이 v2 ZIP을 새 모드로 설치합니다.
4. v2를 Filter Saves 원본보다 아래에 두어 r6/scripts/filter_saves.reds를 덮어쓰게 합니다.
5. MO2로 재실행하고 최신 r6/logs/redscript_rCURRENT.log를 확인합니다.

게임 내에서 저장 메모/퀘스트 검색, 인생 경로/저장 종류 필터, 모든 캐릭터 검색을 확인하세요.

검증: v1 대비 조건부 import 및 명시적 타입 두 부분만 수정, 다른 바이트 보존. 원본 모듈명/공개 클래스/함수/필드 대조, 원본에서 같은 조건부 import 문법 사용 확인, ZIP CRC 통과. 실제 게임 컴파일 및 실행은 이 환경에서 검증하지 못했습니다.
