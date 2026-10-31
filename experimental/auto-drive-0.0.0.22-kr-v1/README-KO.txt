Auto Drive Enhanced 0.0.0.22 KR 업데이트 v1

첨부된 0.0.0.22 원본을 기준으로 만든 번역 전용 패치입니다. 원본 모드가 필요합니다.

110개 항목: 기존 번역 94개 유지, 신규 16개 번역, 최신 원본에서 제거된 키 2개 제외. 구형 바닐라 v2.30 AI 전환, 차량 제한, 창문에 팔 올리기, 치트 범주와 전투 중 치트 차단/수배 수준 고정/피해 무효화 등을 번역했습니다.

이번 패치는 한국어 전용 localization 리소스 1개와 이를 등록하는 ArchiveXL 설정만 포함합니다. 기존 KR에 들어 있던 차량 AI 동작 리소스와 퀘스트 파일, 기본값 3개를 바꾸던 settings.reds는 포함하지 않습니다. 원본 en-us 리소스를 덮어쓰지 않고 kr-kr을 명시적으로 등록합니다. 영어 게임 설정에서는 원본 영어가 유지됩니다.

MO2 적용:
1. 기존 auto_drive_enhanced KR 모드를 비활성화합니다. 기존 모드 안에 병합하지 말고 새 모드로 설치하세요.
2. Auto Drive Enhanced 0.0.0.22 원본은 활성화합니다.
3. 이 ZIP을 별도 모드로 설치하고 원본 아래에 배치합니다.
4. 기존 KR의 settings.reds와 auto_drive_enhanced kr.archive가 다른 모드에서도 제공되고 있지 않은지 확인합니다.
5. MO2로 게임을 완전히 다시 실행합니다.

게임 설정에서 Auto Drive Enhanced의 옵션명/설명, v2.30 AI 선택과 전환 안내가 한국어로 표시되는지 확인하세요. 기존 사용자 설정은 이 패치가 초기화하지 않습니다. 구형 KR의 강제 기본값이 사라져도 이미 저장한 설정은 남을 수 있으므로 주행 AI, 경로 교통 정리, 최대 속도 비율은 원하는 값인지 직접 확인하세요.

수동 설치: 기존 KR의 r6/scripts/auto_drive_enhanced/settings.reds가 원본을 덮어쓴 경우 0.0.0.22 원본을 다시 적용해 복구하세요. 기존 KR 아카이브는 백업 후 제거하고, 새 archive와 archive.xl을 같은 archive/pc/mod 경로에 넣으세요. 기존 KR을 이름만 바꿔 함께 로드하지 마세요.

포함 파일:
archive/pc/mod/auto_drive_enhanced kr.archive
archive/pc/mod/auto_drive_enhanced kr.archive.xl

검증: 최신 키 110개 일치, 신규 키 16개 완전 번역, 기존 번역 94개 보존, 소스의 리터럴 번역 키 모두 존재, CR2W 195 형식/이름 테이블 유지, 바이너리 재파싱, 헤더/테이블 CRC32, 아카이브 인덱스 CRC64와 리소스 SHA1, ZIP CRC 확인. 게임 내 실행/표시는 미검증입니다. 문제가 있으면 최신 ArchiveXL 로그와 redscript_rCURRENT.log, 표시 화면을 보내주세요.
