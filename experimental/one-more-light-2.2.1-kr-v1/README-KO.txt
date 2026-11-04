One More Light 2.2.1 KR 호환 보완 v1

첨부한 2.2.1 원본을 기준으로 만든 한국어 번역 교체판입니다. 2.2.1 원본이 필요합니다.

확인한 문제: 화면 문구 11개의 secondaryKey는 같지만 기존 KR 숫자 ID는 99101~99111, 최신 원본은 665599101~665599111입니다. 기존 KR은 영어 리소스 base/journal/onemorelight.json을 덮어쓰는 구조입니다.

보완: 최신 원본의 숫자 ID와 파일 형식을 유지하고 동일 secondaryKey에 기존 번역을 연결했습니다. 메시지의 놀려오렴 오타를 놀러 오렴으로 바로잡았으며 나머지 번역 문구는 유지했습니다. 한국어 전용 리소스를 ArchiveXL에 kr-kr로 등록하므로 원본 영어는 덮어쓰지 않습니다.

퀘스트/저널/스트리밍/월드 노드 변경이나 퀘스트 상태 수정은 포함하지 않습니다. 번역 리소스 1개와 한국어 등록 XL만 포함합니다.

MO2 적용:
1. 기존 New Quest - One More Light KR을 비활성화합니다. 기존 모드 폴더에 병합하지 마세요.
2. One More Light 2.2.1 원본을 활성화합니다.
3. 이 ZIP을 별도 모드로 설치하고 원본 아래에 배치합니다.
4. 모드 파일에 OneMoreLight KR.archive와 OneMoreLight KR.archive.xl 두 파일이 있는지 확인합니다.
5. MO2로 게임을 완전히 다시 실행합니다.

수동 적용: 기존 OneMoreLight KR.archive를 게임 폴더 밖으로 백업하고 이 ZIP의 archive 폴더를 게임 폴더에 병합합니다. 원본 OneMoreLight.archive 및 OneMoreLight.archive.xl은 유지하세요.

확인: 퀘스트 제목/목표/설명, 메시지, 재키 봉안함 관련 표시가 한국어인지 확인하세요. 이미 진행한 대화나 메시지를 이 패치가 다시 발생시키지는 않습니다. 게임 화면 언어가 한국어여야 합니다.

검증: 11개 숫자 ID와 secondaryKey가 최신 원본과 정확히 일치, 기존 번역 연결, CR2W 재파싱/헤더 및 테이블 CRC32, 아카이브 인덱스 CRC64/리소스 SHA1, ZIP CRC 통과. 실제 게임 실행/표시는 아직 미검증입니다.
