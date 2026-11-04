# Dark Future 3.0.0-for-2.5 한국어 호환 패치 v1

## 설치

1. MO2에서 기존 `Dark Future - Urban Survival Gameplay KR`을 완전히 비활성화합니다. 새 패치와 함께 켜두면 구형 DFSettings.reds가 남으므로 안 됩니다.
2. 제공된 Dark Future 3.0.0-for-2.5 원본 및 해당 버전의 필수 모드를 활성화합니다.
3. 이 ZIP을 별도 모드로 설치하고 원본보다 아래에 배치합니다.
4. 게임을 한국어로 실행합니다. 별도 언어 선택 없이 적용됩니다.
5. MO2 데이터 탭에서 `r6/scripts/Dark Future/Settings/DFSettings.reds`의 최종 제공 모드가 최신 원본인지 확인합니다. 새 번역 패치는 이 파일을 제공하지 않습니다.

직접 설치한 환경이라면 이전 KR의 DFSettings.reds 대신 최신 원본 파일을 복원해야 합니다. 기존 KR archive 두 개를 제거한 뒤 새 archive 3개를 설치합니다. 게임에서 저장한 개인 설정은 이 ZIP에 포함하거나 덮어쓰지 않습니다.

## 기존 KR의 구조와 문제

- Dark Future Localization KR.archive: 메인 UI 번역 918개, 자막 5개를 게임의 한국어 리소스 경로에 덮어쓰는 방식.
- darkfuture_module_consumableanims_localization KR.archive: 소모품 애니메이션 문구 49개를 덮어쓰는 방식.
- DFSettings.reds: 설정 클래스 전체 덮어쓰기. 실제 한글 문구는 번역 archive에서 제공하며, 이 파일 자체는 한글화에 필수적이지 않음.

구형 설정 파일에는 최신 DFCrashAnimSetting 열거형, energyLossRatePctV2 등 설정·캐시 필드, 숙취 치료 관련 처리 등이 없습니다. 최신 애니메이션 서비스와 욕구 시스템이 이 정의를 참조하므로 함께 쓰면 코드 호환 문제가 생길 수 있습니다. 또한 구형 KR에는 운반 중량 감소 비활성화·HUD 끄기·차량 수면 키 변경 등 번역과 무관한 기본값 차이가 있습니다.

새 패치는 번역용 archive 덮어쓰기 구조를 유지하면서 DFSettings.reds 전체 교체만 제거합니다. 최신 기능 코드와 기본값은 원본을 사용하며, 이전 KR의 별도 기본값 조정은 이식하지 않습니다. 실제 저장된 설정 값은 게임 설정에서 확인하세요.

## 패치 구성

1. Dark Future Localization KR.archive
   - 최신 메인 UI 1,072개 항목: 기존 783개 유지, 기존 키 58개 설명·이름 수정, 신규 231개 번역.
   - 최신 원본에서 빠진 구형 키 77개 제외.
   - 메인 행동 자막 20개: 기존 5개 유지, 신규 15개 번역.
2. darkfuture_module_consumableanims_localization KR.archive
   - 기존 49개 유지 + 연속 애니메이션 한도 관련 2개 추가 = 51개.
3. Dark Future Module - Relax Action Localization KR.archive
   - 새 휴식 모듈 UI 13개 및 행동 자막 51개 번역.

새로 등장한 핵심 용어는 Vice Affinity=향락 적응, Euphoria=도취, Crash=후유증, Overdrive=오버드라이브, Flatline=심정지, Buzz=니코틴 각성, Intoxication=취기입니다. 기존 정신력·영양·수분·에너지 용어와 함께 사용합니다.

원본의 한국어 ArchiveXL 등록과 자막 맵 경로를 그대로 사용하므로 별도 XL 파일은 필요하지 않습니다. 원본 Dark Future.archive의 상호작용 한국어 25개는 이미 번역되어 있어 그대로 사용합니다. 원본 리소스·퀘스트·소리·스크립트·설정 기본값은 새 패치에 포함하지 않습니다.

## 검증

- 분할 ZIP 결합 후 전체 CRC 검사 통과.
- 최신 메인 UI 1,072개 키와 순서 일치, 모든 이름 있는 치환자 보존.
- 새로 번역하거나 검토해 수정한 리치 텍스트의 색상·강조·아이콘 태그 순서와 리터럴 줄바꿈 보존.
- 원본의 활성 설정 표시 주석이 참조하는 번역 키 378개 모두 포함.
- 생성 리소스 5개 재파싱 후 번역 데이터와 동일함을 확인.
- 생성 archive 3개의 인덱스·경로 해시·세그먼트·체크섬 확인.
- 원본 XL의 한국어 등록 및 한국어 자막 맵의 리소스 참조 확인.
- 기능 스크립트 덮어쓰기 없음 확인.

실제 REDscript 컴파일, 게임 화면의 글자 길이·배치, 자막 표시 및 게임플레이 검증은 수행하지 못했습니다. 설치 후 오류가 있으면 r6/logs/redscript_rCURRENT.log를 첨부하세요.
