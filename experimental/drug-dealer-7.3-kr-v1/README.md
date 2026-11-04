# Drug Dealer 7.3 한국어 호환 패치 v1

## 설치

1. 기존 `Drug Dealer - Become a Kingpin KR`을 완전히 비활성화합니다. 새 패치와 함께 켜 두지 마세요. 이전 Settings.reds와 Audioware 설정을 제거해야 합니다.
2. Drug Dealer 7.3 원본 및 해당 버전의 필수 모드를 설치하고 활성화합니다. 최신 원본은 AudioXL 음성 설정을 사용합니다.
3. 새 ZIP을 별도 모드로 설치하고 MO2에서 원본보다 아래에 배치합니다.
4. 한국어로 게임을 실행합니다. 설정 메뉴·경력 화면·지도·일지와 거래 관련 문구를 확인하세요.
5. 기존 KR을 게임 폴더에 직접 설치했다면, 기존 KR ZIP에 들어 있던 파일 중 최신 원본에 없는 `r6/audioware/DrugDealer/DD_DrugDealerAudio.yml`도 제거해야 합니다. Settings.reds는 삭제 상태로 두지 말고 7.3 원본 파일을 복원하세요.

## 호환 문제

기존 Settings.reds는 최신 기능 코드까지 덮어씁니다. Lunatic 난이도, EnemyPresence 및 InvasionGracePeriod 열거형, Mod Settings가 없을 때의 대체 함수 등이 빠지고 여러 게임플레이 수치도 구형으로 돌아갑니다. 새 패치는 Settings.reds를 포함하지 않고 최신 원본의 설정 코드와 기본값을 사용합니다.

기존 한국어 archive는 영문 경로(en-us)를 덮어쓰는 구조였습니다. 새 패치는 공식 ArchiveXL 한국어(kr-kr) 등록을 사용합니다. 이전 Audioware 자막은 최신 AudioXL sounds.json의 kr-kr 자막 필드로 옮겼습니다. 음성 파일·음량·이벤트 이름·영문 자막은 변경하지 않았습니다.

## 번역 범위

- 기존 번역 582개 항목 보존 + 신규 160개 항목 번역 = 최신 원본과 같은 742개 항목.
- 원본에 중복된 DD.Tutorial.V4 키가 2개 있으므로 고유 키는 741개입니다. 원본 순서와 두 항목을 그대로 유지합니다.
- 시티 센터 거래, 구역 침공, 경력 화면, 퀘스트 일지·목표, 최신 약물 효과와 신규 설정 번역.
- 기존 남녀 V 문구 보존 및 신규 남성 문구 4개 추가.
- AudioXL 음성 자막 20개에 한국어 추가(기존 자막 재사용 및 신규 아군 대사 번역).
- 지도 분류 번역 스크립트는 최신과 비교해 표시 문구 2개만 다른 호환 파일을 유지.

## 포함 파일

- archive/pc/mod/DrugDealer-7.3-KR.archive
- archive/pc/mod/DrugDealer-7.3-KR.archive.xl
- r6/scripts/DrugDealer/Map/MapLocalizationProvider.reds
- red4ext/plugins/AudioXL/sounds/DrugDealer/sounds.json

원본의 Settings.reds, 퀘스트·전투·사업 코드, tweak 수치, 오디오 MP3, 개인 설정·세이브 파일은 포함하지 않습니다. AudioXL sounds.json은 파일 단위로 덮어쓰므로 향후 원본 업데이트 시 재비교가 필요합니다.

## 검증

입력 ZIP 무결성, 번역 리소스 재구축 후 재파싱 일치, 생성 archive 인덱스·체크섬, 원본 키 순서·성별 필드, 모든 {0} 등 치환자 보존, 약물 효과 수치·지속 시간 숫자 보존, 설정에서 사용하는 83개 번역 키 포함 여부를 확인했습니다. AudioXL manifest는 kr-kr 자막 필드를 제거하면 최신 원본과 완전히 같습니다.

실제 REDscript 컴파일, 게임 화면과 AudioXL 재생 검증은 수행하지 못했습니다. 설치 후 컴파일 오류가 있다면 r6/logs/redscript_rCURRENT.log를 확인하세요.
