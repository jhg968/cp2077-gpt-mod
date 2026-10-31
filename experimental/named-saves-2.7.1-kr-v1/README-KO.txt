Named Saves 2.7.1 KR 설정 보완 v1

기존 Config.reds를 덮어쓰는 한글 패치 형태를 유지하면서 Named Saves 2.7.1의 최신 설정 구조를 보존한 교체판입니다. 2.7.1 원본에 이미 포함된 한국어 설정 제목/설명을 사용하고 범주 이름은 기존 KR처럼 일반으로 지정합니다. 별도 DLL/아카이브는 포함하지 않습니다.

설정 3개:
- 마지막으로 사용한 이름 기억
- 모든 캐릭터에서 검색
- 검색 결과에서 범주 제목 숨기기

public 선언, 세 옵션 기본값 false, searchAllCategories 의존성, ShouldRememberLastUsed 함수는 2.7.1 원본과 같습니다. 구형 KR에서 마지막 이름 기억 기본값을 true로 바꾸던 부분은 유지하지 않습니다. 원하면 게임 설정에서 활성화하세요.

MO2:
1. 기존 Named Saves KR을 비활성화합니다.
2. Named Saves 2.7.1 원본은 유지합니다.
3. 이 ZIP을 새 모드로 설치하고 원본보다 아래에 배치합니다.
4. r6/scripts/NamedSaves/Config.reds의 최종 제공자가 이 보완판인지 확인합니다.
5. 게임을 새로 실행하고 최신 redscript_rCURRENT.log에서 컴파일 완료를 확인합니다.

Filter Saves 1.7.1과 함께 쓰는 경우 이전 Filter-Saves-Named-Saves-2.7.1-Compat-v2는 계속 비활성화하세요. 이번 파일은 Named Saves의 한국어 설정 패치이며, 이전 Filter Saves 호환 패치를 대체하거나 다시 활성화할 이유가 되지 않습니다.

검증: 2.7.1 원본 대비 category/displayName/description 표현만 변경, 그 외 바이트 보존. 최신 공개 설정 3개와 기본값, 의존성, 사용처 대조, ZIP CRC 확인. 게임 내 컴파일/실행은 아직 미검증입니다.
